#include "slicedpost_check.h"

/*
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/DIBuilder.h"
#pragma GCC diagnostic pop
*/

extern std::list<z3::expr> getZ3ExprFromInv(std::string file);

char slicedpost_check::ID = 0;

slicedpost_check::slicedpost_check(options& options) : llvm::FunctionPass(ID), o(options) {

  //  DT = &getAnalysis<llvm::DominatorTreeWrapperPass>().getDomTree();
  //  LI = &getAnalysis<llvm::LoopInfoWrapperPass>().getLoopInfo();
  //  SE = &getAnalysis<llvm::ScalarEvolutionWrapperPass>().getSE();
}

slicedpost_check::~slicedpost_check() {
}

bool slicedpost_check::runOnFunction(llvm::Function &f) {

  find_cutpoints(this, f, cutPoints);
  std::vector<const llvm::BasicBlock*> bs;
  std::map< const llvm::BasicBlock*, unsigned > o_map;

  collect_loop_backedges(this, loop_ignore_edge, rev_loop_ignore_edge);
  computeTopologicalOrder(f, rev_loop_ignore_edge, bs, o_map);

  // Topological sort of the cutpoints
  std::sort( cutPoints.begin(), cutPoints.end(),
             [&](const llvm::BasicBlock* x, const llvm::BasicBlock* y) {return o_map.at(x) > o_map.at(y);});

  create_segments(f, cutPoints, segVec);

  std::cout << "Printing the block list for segments\n\n";
  for(segment& s : segVec) {
    printSegmentInfo(s);
  }

  // Topological sort of the segments
  //  std::sort( segVec.begin(), segVec.end(),
  //             [&](segment x, segment y) {return o_map.at(x.getEntryBlock()) > o_map.at(y.getEntryBlock());});

  //  std::cout << "Printing the block list for sorted segments\n\n";
  //  for(segment& s : segVec) {
  //    printSegmentInfo(s);
  //  }

/*
  int cntr=1;
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    if(cntr==o.loopNum) {
      deleteLoop(L, *DT, *SE, *LI);
    }
    cntr++;
  }
*/

  /*
  llvm::Function *assumeFunc = assume_prototype(f.getEntryBlock().getModule(), o->globalContext);
  llvm::Function *assertFunc = assert_prototype(f.getEntryBlock().getModule(), o->globalContext);
  llvm::LLVMContext& c = f.getContext();

  buildNameMap(f, localNameMap, nameValueMap);
  collectArr(f, arrValSet);

  std::string fName(f.getName());
  llvm::errs() << "\nProcessing function - " << fName << "\n";
  llvm::BasicBlock *preCondBlock=NULL;
  llvm::Instruction *firstStmtPre=NULL;
  llvm::BasicBlock *postCondBlock=NULL;
  int cntr=1;

  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    auto h = L->getHeader();
    llvm::SmallVector<llvm::BasicBlock*,10> LoopLatches;
    L->getLoopLatches( LoopLatches );
    if(cntr==1) {
      llvm::errs() << "\nProcessing " << o.loopNum << " loop\n";
      llvm::BasicBlock *allocbb = L->getLoopPredecessor();
      llvm::Instruction *lastStmt = allocbb->getTerminator();
      preCondBlock = allocbb->splitBasicBlock(lastStmt);
      firstStmtPre = lastStmt;
    }
    if(cntr==o.loopNum - 1) {
      llvm::errs() << "\nProcessing " << o.loopNum -1 << " loop\n";
      std::string invFilePath = getFuncNameForDaikon(L) + ".txt";
      std::list<z3::expr> preCondExprs = getZ3ExprFromInv(invFilePath);
      llvm::IRBuilder<> builder(firstStmtPre);
      for(z3::expr e : preCondExprs) {
        llvm::Value* val = getValueFromZ3Expr(e, builder, c, nameValueMap, arrValSet);
        insertFuncCall(assumeFunc, builder, val);
      }
    }
    if(cntr==o.loopNum) {
      llvm::errs() << "\nProcessing " << o.loopNum << " loop\n";
      for( llvm::BasicBlock* bb : LoopLatches ) {
        llvm::errs() << "\n Removing predecessor \n";
        h->removePredecessor(bb);
        bb->getTerminator()->setSuccessor(0, postCondBlock);
        postCondBlock = llvm::BasicBlock::Create(o->globalContext, "post", &f);
        llvm::IRBuilder<> builder(postCondBlock);
        std::string invFilePath = getFuncNameForDaikon(L) + ".txt";
        const std::list<z3::expr>& postCondExprs = getZ3ExprFromInv(invFilePath);
        for(z3::expr e : postCondExprs) {
          llvm::Value* val = getValueFromZ3Expr(e, builder, c, nameValueMap, arrValSet);
          insertFuncCall(assertFunc, builder, val);
        }
        builder.CreateRetVoid();
      }
      llvm::BasicBlock *predB = h->getSinglePredecessor();
      if(predB != NULL) {
        std::cout << "\n\nSingle Predecessor is NON-NULL\n\n";
        h->removePredecessor(predB);
      } else {
        std::cout << "\n\nSingle Predecessor is NULL\n\n";
      }
      preCondBlock->getTerminator()->setSuccessor(0, h);
    }
    cntr++;
  }
  */
  return false;
}

void slicedpost_check::insertFuncCall(llvm::Function* func, llvm::IRBuilder<>& irb, llvm::Value* V)
{
  llvm::SmallVector<llvm::Value*,2> argsVec;
  argsVec.push_back(V);
  irb.CreateCall(func, argsVec);
}

llvm::StringRef slicedpost_check::getPassName() const {
  return "Transforms the program for checking the sliced post condition";
}

void slicedpost_check::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  //au.setPreservesAll();
  //TODO: ...
  //au.addRequired<llvm::Analysis>();
  au.addRequired<llvm::DominatorTreeWrapperPass>();
  au.addRequired<llvm::LoopInfoWrapperPass>();
  au.addRequired<llvm::ScalarEvolutionWrapperPass>();
  //au.addRequired<llvm::DependenceAnalysisWrapperPass>();
}

