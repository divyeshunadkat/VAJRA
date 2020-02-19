#ifndef SLICEDPOST_CHECK_H
#define SLICEDPOST_CHECK_H

#include "utils/options.h"
#include "utils/z3Utils.h"
#include "utils/llvmUtils.h"
#include "segment.h"
/*
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/IRBuilder.h"
#include "llvm/Analysis/CFGPrinter.h"
#pragma GCC diagnostic pop
*/
class slicedpost_check : public llvm::FunctionPass
{
public:
  static char ID;
  options& o;
  std::map< llvm::Value*, std::string > localNameMap;
  std::map< std::string, llvm::Value* > nameValueMap;
  std::set< llvm::Value* > arrValSet;
  std::vector< llvm::BasicBlock* > cutPoints;
  std::vector< segment > segVec;

  //  llvm::DominatorTree *DT;
  //  llvm::LoopInfo *LI;
  //  llvm::ScalarEvolution *SE;

  std::map< const llvm::BasicBlock*, std::set<const llvm::BasicBlock*> > loop_ignore_edge;
  std::map< const llvm::BasicBlock*, std::set<const llvm::BasicBlock*> > rev_loop_ignore_edge;

  slicedpost_check(options& options);
  ~slicedpost_check();

  void insertFuncCall(llvm::Function*, llvm::IRBuilder<>&, llvm::Value*);

  virtual bool runOnFunction(llvm::Function &f);
  llvm::StringRef getPassName() const;
  void getAnalysisUsage(llvm::AnalysisUsage &au) const;
};

#endif
