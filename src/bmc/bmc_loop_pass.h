#ifndef TILER_BMC_LOOP_PASS_H
#define TILER_BMC_LOOP_PASS_H

#include "bmc/bmc_pass.h"
#include "llvm/Analysis/LoopPass.h"

class bmc_loop_pass : public bmc_pass, public llvm::FunctionPass {

public:
  static char ID;
  value_expr_map& def_map;

public:
  // bmc_pass( options&, z3::context&, bmc&, ValueExprMap&);
  bmc_loop_pass( options&, z3::context&, value_expr_map&, bmc&);
  ~bmc_loop_pass();

  void populate_bmc_ds( bmc_loop* bmc_loop_ptr );
  void add_latch_join_path( llvm::Loop*, bmc_loop*);
  void add_out_var_defs( llvm::Loop*, bmc_loop*);
  void tag_exprs( llvm::Loop*, bmc_loop*);
  void update_names(bmc_loop*, bool);
  void copy_locals_map(bmc_loop*, bmc_loop*);

  bmc_loop* loopdata_to_bmc_ptr( loopdata* ld );

  virtual bool runOnFunction( llvm::Function & );
  bool runOnEachLoop(llvm::Loop*, llvm::Loop*);
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::StringRef getPassName() const;
};

class bmc_aggr_pass : public bmc_pass, public llvm::FunctionPass {

public:
  static char ID;
  value_expr_map& def_map;

public:
  bmc_aggr_pass( options&, z3::context&, value_expr_map&, bmc&);
  ~bmc_aggr_pass();

  virtual bool runOnFunction( llvm::Function & );
  void update_names( bmc_ds_aggr* bmc_aggr_ptr, bool is_init);
  void update_heap_model( bmc_ds_aggr*, bmc_ds_aggr* );
  void init_aggr_lists(  bmc_ds_aggr* );
  void init_glb_and_arry(  bmc_ds_aggr*, bmc_ds_aggr* );
  void post_sub_loop_stiching(  bmc_ds_aggr*, bmc_ds_aggr* );
  void local_scalars_stiching(  bmc_ds_aggr*, bmc_ds_aggr* );
  bmc_ds_aggr* runOnLoop(llvm::Loop*, bmc_ds_aggr*);
  virtual void getAnalysisUsage(llvm::AnalysisUsage &au) const;
  llvm::StringRef getPassName() const;

  void print(std::ostream& o);
  inline void dump() { print( std::cout ); }
};

#endif // TILER_BMC_LOOP_PASS_H
