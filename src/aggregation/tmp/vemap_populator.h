#ifndef TILER_VEMAP_POPULATOR_H
#define TILER_VEMAP_POPULATOR_H

#include "llvm/Analysis/LoopPass.h"
#include "loopdata.h"
#include "utils/options.h"
#include "utils/llvmUtils.h"

class params_populator : public llvm::FunctionPass {

public:
  static char ID;
  z3::context& z3_ctx;
  options& o;
  value_expr_map& params;

public:
  vef_populator( z3::context& _ctx,
                 options& o_,
                 value_expr_map& p)
    : z3_ctx(_ctx)
    , o(o_)
    , params(p);
  {}

  virtual bool runOnFunction( llvm::Function & );
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::StringRef getPassName() const;
};


class aggregation_maps {

public:
  z3::context& z3_ctx;
  llvm::Loop *L = NULL;

  value_expr_map init_map;
  value_expr_map entry_map;
  value_expr_map exit_map;
  value_expr_map final_map;

  aggregation_maps( z3::context& ctx_ ) : z3_ctx( ctx_ ) {};
};


class aggr_map_populator : public llvm::LoopPass {

public:
  static char ID;
  z3::context& z3_ctx;
  std::map<llvm::Loop*, aggregation_maps*>& aggr_map;

  virtual bool doInitialization(llvm::Loop *, llvm::LPPassManager &);
  virtual bool runOnLoop(llvm::Loop *, llvm::LPPassManager &);
  virtual bool doFinalization();
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::StringRef getPassName() const;

};

#endif // TILER_VEMAP_POPULATOR_H
