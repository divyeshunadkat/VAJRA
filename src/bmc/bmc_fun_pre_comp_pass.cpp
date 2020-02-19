#include "bmc/bmc_fun_pre_comp_pass.h"

char bmc_fun_pre_comp_pass::ID = 0;

bmc_fun_pre_comp_pass::
bmc_fun_pre_comp_pass( options& o_, z3::context& z3_, bmc& b_)
  : bmc_pass(o_,z3_,b_), llvm::FunctionPass(ID)
{}

bmc_fun_pre_comp_pass::~bmc_fun_pre_comp_pass() {}

bool bmc_fun_pre_comp_pass::runOnFunction( llvm::Function &f ) {
  if(!f.getName().startswith(o.origFuncName)) {
    return false;
  }

  populateArrAccMap(&f);

  bmc_fun *bmc_fun_ptr = new bmc_fun(z3_ctx, ary_to_int,
                                     bmc_obj.g_model); // local pointer
  assert(bmc_fun_ptr);

  // set the pointer in base class
  bmc_ds_ptr = bmc_fun_ptr;
  auto pair = std::make_pair( &f, bmc_fun_ptr);
  bmc_obj.get_func_formula_map().insert( pair );

  collect_loop_backedges(this, bmc_fun_ptr->loop_ignore_edges,
                         bmc_fun_ptr->rev_loop_ignore_edges);
  bmc_fun_ptr->bb_vec.clear();
  computeTopologicalOrder(f, bmc_fun_ptr->rev_loop_ignore_edges,
                          bmc_fun_ptr->bb_vec, bmc_fun_ptr->block_to_id);
  bmc_fun_ptr->setup_prevs_non_repeating();
  bmc_fun_ptr->eb = bmc_fun_ptr->bb_vec[0];

  return false;
}

llvm::StringRef bmc_fun_pre_comp_pass::getPassName() const {
  return "Constructs BMC formula for the peel function in the aggregation algo";
}

void bmc_fun_pre_comp_pass::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
