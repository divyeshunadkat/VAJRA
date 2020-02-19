#ifndef INSERT_MAIN_H
#define INSERT_MAIN_H

#include <string>
#include "utils/options.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/raw_ostream.h"
#pragma GCC diagnostic pop

class insert_main : public llvm::ModulePass
{
public:
  static char ID;
  options& o;

  insert_main(options& options) : llvm::ModulePass(ID), o(options)
  { }
  virtual bool runOnModule( llvm::Module & );
  llvm::StringRef getPassName() const;
  void getAnalysisUsage(llvm::AnalysisUsage &au) const;
};

#endif
