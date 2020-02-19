#ifndef LOOPDATA_H
#define LOOPDATA_H

#include "segment.h"
#include "utils/z3Utils.h"
#include "utils/llvmUtils.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

class loopdata {
public:
  z3::context& c;

  llvm::Loop* loop = NULL;     // pointer to the loop

  loopdata* parent = NULL;     // for travering the loop graph
  std::vector<loopdata*> childHeads;
  std::vector<loopdata*> next; // in case of "if" there can be multiple nexts
  std::vector<const llvm::BasicBlock*> to_inner;
  std::vector<llvm::BasicBlock*> blocks;

  // For loop level cloning functionality. May get deprecated
  std::vector<llvm::BasicBlock*> cloned_blocks;
  std::map<const bb*, bb*> blocks_to_cloned_map;

  const llvm::BasicBlock* getLoopPredecessor() {
    if( loop == NULL ) return NULL;
    auto b = loop->getLoopPredecessor();
    assert( b );
    return b;
  }

  void getLoopPredecessor( std::vector<const llvm::BasicBlock*>& return_blocks) {
    auto b = getLoopPredecessor();
    assert( b );
    return_blocks.clear();
    return_blocks.push_back(b);
  }

  void getExitingBlocks(std::vector<std::pair<const llvm::BasicBlock*,
                        unsigned> >& return_blocks) {
    // llvm::SmallVector<llvm::BasicBlock*,10> ExitingBlocks;
    // loop->getExitingBlocks(ExitingBlocks);
    // for( auto b : ExitingBlocks ) {
    //   return_blocks.push_back( {b,0} );
    // }
    if( loop == NULL ) return;
    llvm::SmallVector< std::pair<const llvm::BasicBlock*,const llvm::BasicBlock*>,10> exitEdges;
    loop->getExitEdges( exitEdges );
    for( auto e : exitEdges ) {
      unsigned succ_num = getSuccessorIndex( e.first, e.second );
      return_blocks.push_back( {e.first, succ_num} );
    }
  }

  void getLoopLatches(std::vector<const llvm::BasicBlock*>& return_blocks) {
    if( loop == NULL ) return;
    llvm::SmallVector<llvm::BasicBlock*,10> blocks;
    loop->getLoopLatches( blocks);
    for( auto b : blocks ) {
      return_blocks.push_back( b );
    }
  }

  void getWrittenArrays(std::vector<const llvm::AllocaInst*>& );
  void getWrittenGlbs(std::vector<const llvm::GlobalVariable*>& );

  void setPureReadArrays();
  void setPureReadGlbs();

  //return a list of blocks that only includes block from the current loop
  std::vector<llvm::BasicBlock*>& getCurrentBlocks() {
    return blocks;
  }

  // store the map between instruction of loop blocks and cloned blocks
  llvm::ValueToValueMapTy VMap;

  // loop head phi names
  std::map<llvm::PHINode*, std::string > headPhiNameMap;

  // counter
  llvm::Value* ctr;     // llvm object for the counter
  llvm::Value* ctr_out; // llvm object for the counter value from latch
  z3::expr ctrZ3Expr;   // z3   object for the counter
  std::string ctrName;  // string for the counter

  // bound expressions
  int stepCnt;
  z3::expr initBound;
  z3::expr exitBound;
  bool isStrictBound = true;
  llvm::Value* initValue;  // llvm object for the exit value
  llvm::Value* exitValue;  // llvm object for the exit value

  // exit/past condition: conjunction of quantified array properties
  std::vector<z3::expr> exitCond;
  std::vector<z3::expr> pastCond;

  // Segments
  std::vector<segment*> arrivalSegment; // segment that arrives at the loop
  std::vector<segment*> enterSegment;   // segment that goes inside the loop
  std::vector<segment*> exitSegment;    // segment that goes away from the loop

  // Overlap Variables
  std::vector<llvm::Value*> ov_inp;
  std::vector<llvm::Value*> ov_out;

  std::vector<llvm::Value*> aggr_arr;

  // Constant Variables accessed but not modified in the loop
  std::vector<llvm::Value*> const_val;

  // Eliminate vars
  std::vector<llvm::Value*> quant_elim_val;

  // Array which are read but not written
  std::vector<const llvm::AllocaInst*> arrPureRead;

  // Array reads and writes
  std::map<llvm::Value*, std::list<llvm::Value*>> arrRead;
  std::map<llvm::Value*, std::list<llvm::Value*>> arrWrite;

  // Array reads and writes exprs
  std::map<llvm::Value*, std::list<z3::expr>> arrReadExpr;
  std::map<llvm::Value*, std::list<z3::expr>> arrWriteExpr;

  // Array read and write tile expr
  std::map<llvm::Value*, z3::expr> readTile;
  std::map<llvm::Value*, z3::expr> writeTile;

  // Array read and write in current iteration overlap bit
  std::map<llvm::Value*, bool> isReadOverlappingWrite;

  // Array read in next iteration and write in current iteration overlap bit
  std::map<llvm::Value*, bool> isNextIterReadOverlappingWrite;

  // Array write tile overlap in current iteration bit
  std::map<llvm::Value*, bool> isWriteOverlapping;

  //Array write tile size
  std::map<llvm::Value*, int> readTileSize;
  std::map<llvm::Value*, int> writeTileSize;
  std::map<llvm::Value*, int> numUpdInd;

  // Array reads and writes min and max exprs
  std::map<llvm::Value*, std::list<z3::expr>> readMinMax;
  std::map<llvm::Value*, std::list<z3::expr>> writeMinMax;

  // Globals which are read but not written
  std::vector<const llvm::GlobalVariable*> glbPureRead;

  // Global reads and writes
  std::map<llvm::Value*, std::list<llvm::Value*>> glbRead;
  std::map<llvm::Value*, std::list<llvm::Value*>> glbWrite;

  // Assertion
  bool is_assert_loop = false;

  //peeling attributes
  bool peel_direction_first = false; //default last peel direction

  // maps a alloca for the read arr to a loop that previously wrote to it
  std::map<llvm::Value*, llvm::Loop*> interfering_loops;

  loopdata( z3::context& c_ ) : c(c_),
                                ctrZ3Expr(c),
                                initBound(c),
                                exitBound(c)
  {}

  ~loopdata() {}

  // setters
  void setLoop(llvm::Loop *l);
  void setParent(loopdata *p);
  void addChildHead(loopdata *ch);
  void setHeadPhiName( llvm::PHINode *, std::string );
  void setCtr(llvm::Value *v);
  void setCtrZ3Expr(z3::expr ce);
  void setCtrName(std::string cn);
  void setStepCnt(int step);
  void setInitBound(z3::expr e);
  void setExitBound(z3::expr e);
  void addNextToVec(loopdata *n);
  void addEnterSegment(segment *s);
  void addExitSegment(segment *s);

  //getters
  std::string getHeadPhiName( llvm::PHINode *);

  void print();
};

#endif
