#include "bmc/bmc_loop_pass.h"
#include "bmc/bmc_ds.h"

char bmc_loop_pass::ID = 0;

bmc_loop_pass::bmc_loop_pass( options& o_, z3::context& z3_,
                              value_expr_map& def_map_, bmc& b_)
  : bmc_pass(o_,z3_,b_), llvm::FunctionPass(ID), def_map(def_map_)
{}

bmc_loop_pass::~bmc_loop_pass() {
  //delete (bmc_loop*) bmc_ds_ptr;
}


//bool bmc_loop_pass::doInitialization(llvm::Loop *L, llvm::LPPassManager &LPM) {
//  return false; // did not modify the loop
//  }

loopdata*
// bmc_loop_pass::
is_sub_loop_exit_block( std::vector< loopdata* >& sub_loops, const bb* b ) {
  for( loopdata* sub_ld : sub_loops ) {
    std::vector< std::pair< const bb*, unsigned > > e_bs;
    sub_ld->getExitingBlocks( e_bs );
    for( auto e_b : e_bs ) {
      if( e_b.first == b ) return sub_ld;
    }
  }
  return NULL;
}

bmc_loop*
bmc_loop_pass::
loopdata_to_bmc_ptr( loopdata* ld ) {
  if(ld)
    return bmc_obj.loop_formula_map[ld->loop];
  else
    return NULL;
}


void bmc_loop_pass::populate_bmc_ds(  bmc_loop* bmc_loop_ptr ) {
  loopdata* ld = bmc_loop_ptr->get_loopdata();
  llvm::Loop *L = ld->loop;
  //Find back edges coming from latches
  bmc_loop_ptr->collect_loop_back_edges(L);
  // Collect blocks to be processed
  bmc_loop_ptr->bb_vec.clear();
  std::vector< std::pair< unsigned, unsigned> > gaps;
  std::vector< loopdata* >& sub_loops = ld->childHeads;
  unsigned gap_num = 0;
  for ( auto b : ld->getCurrentBlocks() ) {
    if( b == NULL ) {
      auto sub_loop = loopdata_to_bmc_ptr(sub_loops[gap_num++]);
      unsigned skip_len = sub_loop->bb_vec.size();
      unsigned start_gap = bmc_loop_ptr->bb_vec.size();
      for( unsigned i = 0; i < skip_len; i++ ) {
        auto b = sub_loop->bb_vec[i];
        bmc_loop_ptr->bb_vec.push_back( b );
      }
      unsigned end_gap = bmc_loop_ptr->bb_vec.size();
      gaps.push_back( {start_gap, end_gap} );
    }else{
      bmc_loop_ptr->bb_vec.push_back(b);
    }
  }
  bmc_loop_ptr->eb = L->getHeader();

  // Local vals to be eliminated
  bmc_loop_ptr->quant_elim_val.clear();
  for ( llvm::Value *v : ld->quant_elim_val )
    bmc_loop_ptr->quant_elim_val.push_back(v); //Collect vals to be eliminated

  // populate latches
  std::vector<const llvm::BasicBlock*> latches;
  ld->getLoopLatches( latches );
  bmc_loop_ptr->add_latches( latches );

  // populate exits
  std::vector<std::pair< const llvm::BasicBlock*, unsigned > > exits;
  ld->getExitingBlocks( exits );
  bmc_loop_ptr->add_exits( exits );

  // for( auto& latch : latches) {
  //   auto l_idx = bmc_loop_ptr->find_block_idx( latch );
  //   // unsigned bidx = 0;
  //   // for( const bb* b : bmc_loop_ptr->bb_vec ) {
  //   //   if( b == latch ) break;
  //   //   bidx++;
  //   // }
  //   bmc_loop_ptr->latches.push_back( lidx );
  // }
  assert( gaps.size() == ld->childHeads.size() );
  
  // add_latch_join_path(L, bmc_loop_ptr);

  { // prev population
    unsigned gap_idx = 0;
    unsigned start_sub_body = 0;
    unsigned end_sub_body = 0;
    bmc_loop* sub_loop = 0;
    if( gaps.size() > gap_idx ) { // initial
      start_sub_body = gaps[gap_idx].first;
      end_sub_body = gaps[gap_idx].second;
      sub_loop = loopdata_to_bmc_ptr(sub_loops[0]);
    }
    // assign prevs of each occured block
    for( unsigned bidx = 0; bidx <  bmc_loop_ptr->bb_vec.size(); bidx++ ) {
      const bb* src = bmc_loop_ptr->bb_vec[bidx];
      if( gap_idx < gaps.size() ) {
        if( bidx >= end_sub_body ) {
          //process the entry header
          std::vector<const bb*> entry_blocks;
          sub_loop->get_loopdata()->getLoopPredecessor( entry_blocks );
          for( const bb* pre_b : entry_blocks ) {
            unsigned pre_b_idx = bmc_loop_ptr->find_block_idx( pre_b );
            bmc_loop_ptr->insert_prev_idx( start_sub_body, pre_b_idx );
          }
          gap_idx++;
          if( gaps.size() > gap_idx ) {
            start_sub_body = gaps[gap_idx].first;
            end_sub_body = gaps[gap_idx].second;
            sub_loop = loopdata_to_bmc_ptr(sub_loops[gap_idx]);
          }
        }else if( bidx >= start_sub_body ) {
          for( auto p_idx: sub_loop->get_prev_idxs( bidx-start_sub_body ) ) {
            assert( p_idx+start_sub_body < bidx );
            bmc_loop_ptr->insert_prev_idx( bidx, p_idx+start_sub_body );
          }
          continue;
        }
      }
      bmc_loop_ptr->pred_idxs[bidx].empty();
      for(auto PI = llvm::pred_begin(src),E = llvm::pred_end(src);PI!=E;++PI) {
        const bb* prev = *PI;
        if( bmc_loop_ptr->ignore_edge( src, prev ) ) continue;
        //check if the block is existing block of some
        if( loopdata* lbds = is_sub_loop_exit_block( sub_loops, prev ) ) {
          auto sub_loop_bmc_ptr = loopdata_to_bmc_ptr(lbds);
          unsigned i=0;
          for(; i < sub_loops.size(); i++)
            if( sub_loops[i] == lbds ) break;
          assert( i < sub_loops.size() );
          unsigned shift = gaps[i].first;
          std::vector<unsigned> positions;
          sub_loop_bmc_ptr->get_exit_block_positions( prev, positions);
          for( auto prev_bidx : positions) {
            //mulitple copies create issue with phi node.
            bmc_loop_ptr->insert_prev_idx( bidx, prev_bidx+shift );
          }
        }else{
          unsigned prev_bidx = bmc_loop_ptr->find_block_idx( prev );
          if( prev_bidx == bmc_loop_ptr->bb_vec.size() ) continue;
          assert( prev_bidx < bidx );
          bmc_loop_ptr->insert_prev_idx( bidx, prev_bidx );
        }
      }
    }
  }
  // bmc_loop_ptr->setup_prevs_non_repeating();

  if( !o.llvm_unroll && o.unwind )
    bmc_loop_ptr->copy_and_stich_segments( o.loop_unroll_count );
}


bool bmc_loop_pass::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }

  populateArrAccMap(&f);

  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  llvm::Loop* prevL = NULL;
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    runOnEachLoop(L, prevL);
    prevL = L;
  }
  return false;
}

//bool bmc_loop_pass::runOnLoop(llvm::Loop *L, llvm::LPPassManager &LPM) {

bool bmc_loop_pass::runOnEachLoop(llvm::Loop *L, llvm::Loop *prevL) {
  // local pointer to record bmc
  bmc_loop* bmc_loop_ptr = new bmc_loop( z3_ctx, ary_to_int,
                                         bmc_obj.g_model,
                                         bmc_obj.ld_map.at(L) );
  assert( bmc_loop_ptr );

  def_map.copy_values(bmc_loop_ptr->m);

  // set the pointer in base class
  bmc_ds_ptr = bmc_loop_ptr;
  auto pair = std::make_pair( L, bmc_loop_ptr );
  bmc_obj.get_loop_formula_map().insert( pair );

  populate_bmc_ds( bmc_loop_ptr );

  bmc_loop_ptr->init_array_model( o.ar_model );

  if(prevL != NULL) {
    // copy names from the exit block of previous loop to the initial block of current loop
    bmc_loop* bmc_prev_loop_ptr = bmc_obj.get_loop_formula_map().at(prevL);
    for( auto& exit : bmc_prev_loop_ptr->exits ) {
      array_state& s = bmc_prev_loop_ptr->ar_model_full.get_state(exit.first);
      bmc_loop_ptr->ar_model_full.copy_to_init_state(s);
    }
    update_names(bmc_loop_ptr, true);
    copy_locals_map(bmc_loop_ptr, bmc_prev_loop_ptr);
  }

  do_bmc();                       // Create the bmc formula

  std::vector<z3::expr> latch_paths;
  for( auto& latch : bmc_loop_ptr->latches) {
    latch_paths.push_back(bmc_loop_ptr->block_to_path_bit.at(latch));
  }
  bmc_loop_ptr->bmc_vec.push_back( _or( latch_paths, z3_ctx));

  add_out_var_defs(L, bmc_loop_ptr);
  tag_exprs(L, bmc_loop_ptr);
  eliminate_vars(z3_ctx, bmc_loop_ptr->quant_elim_vars, bmc_loop_ptr->bmc_vec );

  update_names(bmc_loop_ptr, false);

  return false; // did not modify the loop
}

void bmc_loop_pass::copy_locals_map(bmc_loop* bmc_loop_ptr, bmc_loop* bmc_prev_loop_ptr) {
  value_expr_map& prev_m = bmc_prev_loop_ptr->m;
  value_expr_map& curr_m = bmc_loop_ptr->m;
  prev_m.copy_values(curr_m);
}

void bmc_loop_pass::update_names(bmc_loop* bmc_loop_ptr, bool is_init) {
  loopdata* ld = bmc_loop_ptr->get_loopdata();
  std::vector<const llvm::Instruction*> arrays_updated;
  std::map<llvm::Value*,std::list<llvm::Value*>>& arrayWrite = ld->arrWrite;
  for(std::map<llvm::Value*,std::list<llvm::Value*>>::iterator iter = arrayWrite.begin();
        iter != arrayWrite.end(); ++iter) {
    for ( llvm::Value *v : iter->second ) {
      if( auto a = llvm::dyn_cast<const llvm::Instruction>( v ) ) {
        arrays_updated.push_back(a);
      } else {
        tiler_error("bmc loop pass", "Unsupported value in array write list");        // error
      }
    }
  }

  std::vector<const llvm::GlobalVariable*> glbs_updated;
  std::map<llvm::Value*,std::list<llvm::Value*>>& glbWrite = ld->glbWrite;
  for(std::map<llvm::Value*,std::list<llvm::Value*>>::iterator iter = glbWrite.begin();
        iter != glbWrite.end(); ++iter) {
    if( auto g = llvm::dyn_cast<const llvm::GlobalVariable>( iter->first ) ) {
      glbs_updated.push_back(g);
    } else {
      tiler_error("bmc loop pass", "Unsupported value in glbvar write list");        // error
    }
  }

  if(!is_init) {
    for( auto& exit : bmc_loop_ptr->exits ) {
      bmc_loop_ptr->ar_model_full.update_names( exit.first, arrays_updated );
      bmc_obj.g_model.update_name( exit.first, glbs_updated );
    }
  } else {
    bmc_loop_ptr->ar_model_full.update_names( 0, arrays_updated );
    //bmc_obj.g_model.update_name( 0, glbs_updated );
  }
}

void bmc_loop_pass::add_out_var_defs( llvm::Loop* L, bmc_loop* bmc_loop_ptr ) {
  loopdata* ld = bmc_loop_ptr->get_loopdata();
  // Insert definitions of output variables
  z3::expr fresh_int = get_fresh_int( z3_ctx );
  bmc_loop_ptr->bmc_vec.push_back( fresh_int == bmc_loop_ptr->m.get_term( ld->ctr_out));
  bmc_loop_ptr->subexpr_tags[fresh_int] = counter;
  for ( llvm::Value *v : ld->ov_out ) {
    if( llvm::dyn_cast<llvm::LoadInst>(v) ) {
      continue;
    } else if( llvm::dyn_cast<llvm::StoreInst>(v) ) {
      continue;
    } else {
      z3::expr fresh_int = get_fresh_int( z3_ctx );
      bmc_loop_ptr->bmc_vec.push_back( fresh_int == bmc_loop_ptr->m.get_term(v) );
      bmc_loop_ptr->subexpr_tags[fresh_int] = overlap;
    }
  }
}

void bmc_loop_pass::tag_exprs( llvm::Loop* L, bmc_loop* bmc_loop_ptr ) {
  loopdata* ld = bmc_loop_ptr->get_loopdata();

  llvm::Value *vc = ld->ctr;
  for( unsigned i : bmc_loop_ptr->m.get_versions(vc)) {
    bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(vc,i)] = counter;
  }

  llvm::Value *vco = ld->ctr_out;
  for( unsigned i : bmc_loop_ptr->m.get_versions(vco)) {
    bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(vco,i)] = counter;
  }

  std::map<llvm::Value*,std::list<llvm::Value*>>& arrayRead = ld->arrRead;
  for(std::map<llvm::Value*,std::list<llvm::Value*>>::iterator iter = arrayRead.begin();
        iter != arrayRead.end(); ++iter) {
    for ( llvm::Value *v : iter->second ) {
      z3::expr e = bmc_loop_ptr->m.get_term(v);
      if(e) {
        bmc_loop_ptr->subexpr_tags[e] = tile;
      } else {} // no error
    }
  }

  std::map<llvm::Value*,std::list<llvm::Value*>>& arrayWrite = ld->arrWrite;
  for(std::map<llvm::Value*,std::list<llvm::Value*>>::iterator iter = arrayWrite.begin();
        iter != arrayWrite.end(); ++iter) {
    for ( llvm::Value *v : iter->second ) {
      z3::expr e = bmc_loop_ptr->m.get_term(v);
      if(e) {
        bmc_loop_ptr->subexpr_tags[e] = tile;
      } else {} // no error
    }
  }

  for ( llvm::Value *v : ld->ov_inp ) {
    z3::expr e = bmc_loop_ptr->m.get_term(v);
    if(e.is_app() && e.decl().decl_kind() == Z3_OP_SELECT) {
      bmc_loop_ptr->subexpr_tags[e] = overlap;
    } else if(e.is_app() && e.num_args()>0) {
      bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(v)] = aggregate;
    } else {
      for( unsigned i : bmc_loop_ptr->m.get_versions(v)) {
        // for(unsigned i = 0; i <= bmc_loop_ptr->m.get_count(v); i++) {
        bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(v,i)] = overlap;
      }
    }
  }

  for ( llvm::Value *v : ld->ov_out ) {
    z3::expr e = bmc_loop_ptr->m.get_term(v);
    if(e.is_app() && e.decl().decl_kind() == Z3_OP_STORE) {
      bmc_loop_ptr->subexpr_tags[e] = overlap;
    } else if(e.is_app() && e.num_args()>0) {
      bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(v)] = aggregate;
    } else {
      for( unsigned i : bmc_loop_ptr->m.get_versions(v)) {
        // for(unsigned i = 0; i <= bmc_loop_ptr->m.get_count(v); i++) {
        bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(v,i)] = overlap;
      }
    }
  }

  for ( llvm::Value *v : ld->aggr_arr ) {
    z3::expr e = bmc_loop_ptr->m.get_term(v);
    if(e.is_app() && e.num_args()>0) {
      bmc_loop_ptr->subexpr_tags[bmc_loop_ptr->m.get_term(v)] = aggregate;
    }
  }

  std::cout << "\n\n*** Printing tags ***\n\n";
  for(expr_tag::iterator iter = bmc_loop_ptr->subexpr_tags.begin();
        iter != bmc_loop_ptr->subexpr_tags.end(); ++iter) {
    std::cout << iter->first << "  --  " << iter->second << "\n";
  }
}

//bool bmc_loop_pass::doFinalization() {
//  return false; // did not modify the loop
//}

llvm::StringRef bmc_loop_pass::getPassName() const {
  return "Constructs BMC formula for each loop in the program - unroll param needed";
}

void bmc_loop_pass::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
