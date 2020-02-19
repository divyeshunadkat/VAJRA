#include "bmc/bmc_fun_pass.h"

char bmc_fun_pass::ID = 0;

bmc_fun_pass::bmc_fun_pass( options& o_, z3::context& z3_,
                            value_expr_map& def_map_, bmc& b_)
  : bmc_pass(o_,z3_,b_), llvm::FunctionPass(ID), def_map(def_map_)
{}

bmc_fun_pass::~bmc_fun_pass() {}

bool bmc_fun_pass::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }

  populateArrAccMap(&f);

  bmc_fun *bmc_fun_ptr = new bmc_fun(z3_ctx, ary_to_int,
                                     bmc_obj.g_model); // local pointer
  assert(bmc_fun_ptr);

  def_map.copy_values(bmc_fun_ptr->m);

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

  bmc_ds_ptr->init_array_model( o.ar_model );

  // unsigned bidx = 0;
  // for( const bb* src : bmc_ds_ptr->bb_vec ) {
  //   for(auto PI = llvm::pred_begin(src),E = llvm::pred_end(src);PI != E;++PI) {
  //     const bb* prev = *PI;
  //     if(bmc_ds_ptr->ignore_edge( src, prev )) continue;
  //     if(std::find(bmc_ds_ptr->bb_vec.begin(), bmc_ds_ptr->bb_vec.end(), prev)
  //        == bmc_ds_ptr->bb_vec.end())
  //       continue;
  //     unsigned pre_bidx = 0;
  //     for( const bb* prev_candidate : bmc_ds_ptr->bb_vec ) {
  //       if( prev_candidate == prev ) break;
  //       pre_bidx++;
  //     }
  //     bmc_ds_ptr->pred_idxs[bidx].push_back( pre_bidx );
  //   }
  //   bidx++;
  // }

  translateParams(f);
  do_bmc();

  // Add constraint that path leading to atleast one exit block gets executed
  std::vector<z3::expr> exit_paths;
  for( auto bb : bmc_fun_ptr->bb_vec) {
    if(!hasSuccessor(bb)) {
      auto exit_bb_id = bmc_fun_ptr->find_block_idx(bb);
      exit_paths.push_back(bmc_fun_ptr->block_to_path_bit.at(exit_bb_id));
    } else {}
  }
  bmc_fun_ptr->bmc_vec.push_back( _or( exit_paths, z3_ctx) );

  eliminate_vars(z3_ctx, bmc_fun_ptr->quant_elim_vars, bmc_fun_ptr->bmc_vec );

  return false;
}


llvm::StringRef bmc_fun_pass::getPassName() const {
  return "Constructs BMC formula for a function - unroll param needed";
}

void bmc_fun_pass::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
