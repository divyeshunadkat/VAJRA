#ifndef COLLECT_FUN_BLOCKS_H
#define COLLECT_FUN_BLOCKS_H

#include "daikon-inst/loopdata.h"

bool cmp_loopdata_by_line_num (loopdata* ld1, loopdata* ld2);

class collect_fun_blocks : public llvm::FunctionPass
{
  public:
  static char ID;
  z3::context& z3_ctx;
  options& o;
  std::map<llvm::Loop*, loopdata*>& ld_map;

  collect_fun_blocks(z3::context& ,
                     options&,
                     std::map<llvm::Loop*, loopdata*>&);
  void collect_nonloop_blocks(llvm::Function*);
  void collect_allloop_blocks(loopdata*,
                              std::vector<llvm::BasicBlock*>&);

  virtual bool runOnFunction(llvm::Function &f);
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  virtual llvm::StringRef getPassName() const;
};

#endif // COLLECT_FUN_BLOCKS_H
