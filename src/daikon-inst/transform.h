#ifndef TRANSFORM_H
#define TRANSFORM_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"
#include "utils/options.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/LinkAllPasses.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/DIBuilder.h"
#pragma GCC diagnostic pop

#include "segment.h"
#include "loopdata.h"
#include "irtoz3expr/irtoz3expr_index.h"
#include "bmc/glb_model.h"

//typedef std::set<const llvm::BasicBlock*> bb_set_t;
//typedef std::vector<const llvm::BasicBlock*> bb_vec_t;


class transform : public llvm::FunctionPass
{
public:
  static char ID;
  //  std::string name;
  std::unique_ptr<llvm::Module>& module;
  options& o;
  z3::context& z3context;
  value_expr_map& def_map;

  std::map<llvm::Loop*, loopdata*>& ld_map;
  name_map& localNameMap;
  //  std::map< std::string, llvm::Value* > nameValueMap;
  std::map<std::string, llvm::Value*>& exprValMap;

  //  llvm::DIBuilder *DBuilder;
  //  llvm::DIFile *Unit;
  //  llvm::DICompileUnit *CU;
  llvm::Function *printf_func;
  irtoz3expr_index* ir2e;

  std::list<z3::expr> nonIndParams;
  std::list<z3::expr> loopCntr;
  std::list<z3::expr> glbPreExprs;
  std::list<llvm::Loop *> loopList;
  llvm::AttributeList attr;

  std::set< llvm::Value* > arrays_seen;

  std::map<llvm::Value*, std::list<z3::expr>*> rdInd;
  std::map<llvm::Value*, std::list<z3::expr>*> wrInd;
  std::map<llvm::Value*, std::list<z3::expr>*> allArrInd;
  std::map<llvm::Loop*, std::list<z3::expr>*> rangeExpr;

  //  std::map< const llvm::BasicBlock*, std::set<const llvm::BasicBlock*> > loop_ignore_edge;
  //  std::map< const llvm::BasicBlock*, std::set<const llvm::BasicBlock*> > rev_loop_ignore_edge;

  glb_model g_model; // Dummy global model passed to irtoz3expr; no other use in tiler

  transform(std::unique_ptr<llvm::Module>& ,
            options& , z3::context& ,
            value_expr_map& ,
            std::map<llvm::Loop*, loopdata*>& ,
            name_map& ,
            std::map<std::string, llvm::Value*>&);
  ~transform();

  bool removeAssertStmt(llvm::Loop* L);
  bool removeAssumeStmt(llvm::Function &f);
  void initArrays(llvm::Function &f);
  void initToRand(llvm::Function &f);

  std::list<z3::expr> getZ3ExprForIndex (llvm::Value *V, llvm::Loop *L);
  std::list<z3::expr> getZ3ExprForIndex (llvm::Instruction *I, llvm::Loop *L);
  std::list<z3::expr> getZ3ExprForIndex (llvm::Constant *C, llvm::Loop *L);
  std::list<z3::expr> getZ3ExprForIndex (llvm::BinaryOperator *bop, llvm::Loop *L);
  std::list<z3::expr> getZ3ExprForIndex (llvm::ICmpInst *icmp, llvm::Loop *L);
  std::list<z3::expr> getZ3ExprForIndex (llvm::PHINode *phi, llvm::Loop *L);

  std::list<std::string> getArgNamesList();
  std::string getNameStrForDaikon(z3::expr e);
  std::string getExprNameStrForDaikon(z3::expr e);

  void insertFuncCallNDef(llvm::Loop *L);
  void insertFuncDef(std::string fName);
  void insertFuncCall(std::string fName, llvm::Loop *L);
  void clearDSforDaikon();
  void adjustWrRdInd();

  void setRangesForLoop(llvm::Loop *L);
  void generateTileFromSrcExp(llvm::Loop *L);
  std::list<z3::expr> getRefinedMinMaxTiles(llvm::Loop *L);
  std::list<z3::expr> getRefinedMinMaxReadTiles(llvm::Loop *L);
  z3::expr getTileExprFromList(std::string arrStr, std::list<z3::expr> *l,
                               bool isRRC, bool isRd, llvm::Loop *L);
  bool checkOverlap(std::string arrStr, z3::expr e, bool isRd);
  bool checkRelevantRange(z3::expr e);
  void refineList(std::string arrStr, z3::expr e, std::list<z3::expr> *l, bool isRd, llvm::Loop *L);
  void printTileToFile(std::string fileName, const std::list<z3::expr>& tileExprList);

  void genTracePrintStmts(llvm::IRBuilder<> &builder, llvm::Function *F);
  void insertHeaderPrintStmts(llvm::IRBuilder<> &builder);
  void insertDeclInfoPrintStmts(llvm::IRBuilder<> &builder, llvm::Function *F, bool isEntry);
  void insertFuncNamePrintStmt(llvm::IRBuilder<> &builder, llvm::Function *F, bool isEntry);
  void insertVarPrintStmts(llvm::IRBuilder<> &builder, llvm::Value *x);
  void insertPrintfCall(llvm::IRBuilder<> &builder, const char * str);

  virtual bool runOnFunction(llvm::Function &f);
  llvm::StringRef getPassName() const;
  void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::PHINode* getInductionVariable(llvm::Loop *L, llvm::ScalarEvolution *SE);
  void populateLoopCntr(llvm::Loop *L);

  void collect_arrays(llvm::Function &f );
  //void search_loops_for_access_expressions(std::vector<std::pair<llvm::Value*,llvm::Value*> >&);
  void search_loops_for_access_expressions( );
  void search_loop_for_access_expressions( llvm::Loop* L);
};

#endif
