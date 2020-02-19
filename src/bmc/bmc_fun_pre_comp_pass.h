#ifndef TILER_BMC_FUN_PRE_COMP_PASS_H
#define TILER_BMC_FUN_PRE_COMP_PASS_H

#include "bmc/bmc_pass.h"

class bmc_fun_pre_comp_pass : public bmc_pass, public llvm::FunctionPass {

public:
  static char ID;

public:
  bmc_fun_pre_comp_pass( options&, z3::context&, bmc&);
  ~bmc_fun_pre_comp_pass();

  virtual bool runOnFunction( llvm::Function & );
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::StringRef getPassName() const;
};

#endif // TILER_BMC_FUN_PRE_COMP_PASS_H
