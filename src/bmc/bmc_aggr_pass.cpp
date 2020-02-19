#include "bmc/bmc_loop_pass.h"
#include "bmc/bmc_ds.h"

char bmc_aggr_pass::ID = 0;

bmc_aggr_pass::bmc_aggr_pass( options& o_, z3::context& z3_,
                              value_expr_map& def_map_, bmc& b_)
  : bmc_pass(o_,z3_,b_), llvm::FunctionPass(ID), def_map(def_map_)
{}

bmc_aggr_pass::~bmc_aggr_pass() {
  //delete (bmc_loop*) bmc_ds_ptr;
}

llvm::StringRef bmc_aggr_pass::getPassName() const {
  return "Constructs data structure for agrragation";
}

void bmc_aggr_pass::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}

void bmc_aggr_pass::print(std::ostream& o) {
  for( auto pair : bmc_obj.get_loop_aggr_map() ) {
    bmc_ds_aggr* a = pair.second;
    a->print(o);
  }
}

bool bmc_aggr_pass::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }

  if(f.arg_size() == 1 ) {
    for( auto ab = f.arg_begin(), ae = f.arg_end(); ab != ae; ab++) {
      bmc_obj.aggr_N = def_map.get_term( &(*ab) );
    }
  } else if(bmc_obj.g_model.get_sorts().size() == 1) {
    int glb_id = 0;
    bmc_obj.aggr_N = bmc_obj.g_model.get_state_var(0,glb_id);
  } else {
    tiler_error("Difference::","Unable to find the program variable N for induction");
  }

  populateArrAccMap(&f); // initializing ary_to_int

  runOnLoop( NULL, NULL );

  if(o.verbosity>2) {
    dump();
  }
  return false; // did not modify the function
}

void bmc_aggr_pass::update_heap_model( bmc_ds_aggr* bmc_aggr_ptr,
                                       bmc_ds_aggr* prev_bmc_aggr_ptr ) {
  if( prev_bmc_aggr_ptr ) {
    //get the initial names
    bb* pred_b = bmc_aggr_ptr->get_loopdata()->loop->getLoopPredecessor();

    array_state& s = prev_bmc_aggr_ptr->get_array_state( pred_b );
    glb_state& g = prev_bmc_aggr_ptr->get_glb_state( pred_b );

    bmc_aggr_ptr->init_array_model( o.ar_model, s );
    bmc_aggr_ptr->init_glb_model( g );
  }else{
    bmc_aggr_ptr->init_array_model( o.ar_model );
    bmc_aggr_ptr->init_glb_model(bmc_obj.g_model.get_state(0));
    //todo: copy the model from src
  }
}

void bmc_aggr_pass::init_aggr_lists(  bmc_ds_aggr* bmc_aggr_ptr ) {
  std::vector<const llvm::AllocaInst*> arrays_updated;
  bmc_aggr_ptr->get_written_arrays( arrays_updated );
  for( auto ar : arrays_updated) {
    z3::expr i_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    bmc_aggr_ptr->refresh_array_state( 0, ar );
    z3::expr en_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    aggr_name ag_name( i_name, en_name, en_name, en_name );
    ag_name.bmc_idx = bmc_aggr_ptr->ary_to_int[ar];
    bmc_aggr_ptr->aggr_arrays.push_back( ag_name );
  }

  std::vector<const llvm::GlobalVariable*> globals_updated;
  bmc_aggr_ptr->get_written_globals( globals_updated );
  for( auto g : globals_updated ) {
    z3::expr i_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    bmc_aggr_ptr->refresh_glb_state( 0, g );
    z3::expr en_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    aggr_name ag_name( i_name, en_name, en_name, en_name );
    bmc_aggr_ptr->aggr_scalars.push_back( ag_name );
  }

  for( auto ar : bmc_aggr_ptr->get_pure_read_arrays() ) {
    z3::expr ar_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    bmc_aggr_ptr->aggr_reads.push_back( ar_name );
  }
  for( auto g : bmc_aggr_ptr->get_pure_read_globals() ) {
    z3::expr ar_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    bmc_aggr_ptr->aggr_reads.push_back( ar_name );
  }
}

void bmc_aggr_pass::init_glb_and_arry(  bmc_ds_aggr* bmc_aggr_ptr,
                                        bmc_ds_aggr* prev_bmc_aggr_ptr ) {
  if( prev_bmc_aggr_ptr ) {
    init_aggr_lists( bmc_aggr_ptr );
    // std::vector<const llvm::AllocaInst*> arrays_updated;
    // bmc_aggr_ptr->get_written_arrays( arrays_updated );
    // for( auto ar : arrays_updated) {
    //   z3::expr i_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    //   bmc_aggr_ptr->refresh_array_state( 0, ar );
    //   z3::expr en_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    //   aggr_name ag_name( i_name, en_name, en_name, en_name );
    //   ag_name.bmc_idx = bmc_aggr_ptr->ary_to_int[ar];
    //   bmc_aggr_ptr->aggr_arrays.push_back( ag_name );
    // }

    // std::vector<const llvm::GlobalVariable*> globals_updated;
    // bmc_aggr_ptr->get_written_globals( globals_updated );
    // for( auto g : globals_updated ) {
    //   z3::expr i_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    //   bmc_aggr_ptr->refresh_glb_state( 0, g );
    //   z3::expr en_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    //   aggr_name ag_name( i_name, en_name, en_name, en_name );
    //   bmc_aggr_ptr->aggr_scalars.push_back( ag_name );
    // }

    // for( auto ar : bmc_aggr_ptr->get_pure_read_arrays() ) {
    //   z3::expr ar_name = bmc_aggr_ptr->get_array_state_var(  0 , ar );
    //   bmc_aggr_ptr->aggr_reads.push_back( ar_name );
    // }
    // for( auto g : bmc_aggr_ptr->get_pure_read_globals() ) {
    //   z3::expr ar_name = bmc_aggr_ptr->get_glb_state_var(  0 , g );
    //   bmc_aggr_ptr->aggr_reads.push_back( ar_name );
    // }
  }
}

void bmc_aggr_pass::post_sub_loop_stiching(  bmc_ds_aggr* sub_bmc_aggr_ptr,
                                             bmc_ds_aggr* bmc_aggr_ptr ) {
  bb* predecessor=sub_bmc_aggr_ptr->get_loopdata()->loop->getLoopPredecessor();
  array_state& s = bmc_aggr_ptr->get_array_state(predecessor);
  glb_state& g = bmc_aggr_ptr->get_glb_state(predecessor);
  unsigned pred_bidx = bmc_aggr_ptr->find_block_idx(predecessor);
  assert( sub_bmc_aggr_ptr->exits.size() == 1 );
  for( auto& exit : sub_bmc_aggr_ptr->exits ) {
    bmc_aggr_ptr->bb_vec.push_back( sub_bmc_aggr_ptr->bb_vec[exit.first]);
    unsigned last_pos = bmc_aggr_ptr->processed_bidx;
    bmc_aggr_ptr->set_array_state( last_pos, s );
    bmc_aggr_ptr->set_glb_state( last_pos, g );
    std::vector<z3::expr> exit_bits;
    bmc_aggr_ptr->set_exit_bits( last_pos, exit_bits);
    z3::expr p_b = bmc_aggr_ptr->get_path_bit( pred_bidx );
    bmc_aggr_ptr->set_path_bit( last_pos, p_b );

    std::vector<const llvm::AllocaInst*> arrays_updated;
    sub_bmc_aggr_ptr->get_written_arrays( arrays_updated );
    unsigned i = 0;
    for( auto ar : arrays_updated) {
      bmc_aggr_ptr->refresh_array_state( last_pos, ar );
      aggr_name& ag_name = sub_bmc_aggr_ptr->aggr_arrays.at(i);
      ag_name.ex = sub_bmc_aggr_ptr->get_array_state_var( exit.first, ar );
      ag_name.f = bmc_aggr_ptr->get_array_state_var( last_pos, ar );
      ag_name.setVal(ar);
      i++;
    }
    std::vector<const llvm::GlobalVariable*> globals_updated;
    sub_bmc_aggr_ptr->get_written_globals( globals_updated );
    i=0;
    for( auto gv : globals_updated ) {
      bmc_aggr_ptr->refresh_glb_state( last_pos, gv );
      aggr_name& ag_name = sub_bmc_aggr_ptr->aggr_scalars.at(i);
      ag_name.ex = sub_bmc_aggr_ptr->get_glb_state_var( exit.first, gv );
      ag_name.f = bmc_aggr_ptr->get_glb_state_var( last_pos, gv );
      i++;
    }
    bmc_aggr_ptr->processed_bidx++;
    //update names maps for all types of names
  }
  // update the final names of locals for the outer loop
  auto sub_loop = sub_bmc_aggr_ptr->get_loopdata()->loop;
  auto sub_head = sub_loop->getHeader();
  for( auto I = sub_head->begin(); llvm::isa<llvm::PHINode>(I); ++I ) {
    auto phi = llvm::cast<llvm::PHINode>(I);
    //do the following if we jump out of the loop head
    unsigned i = valueIdxFromLatch( phi, sub_loop);
    auto final_val_in_outer_loop =
      isLoopRotated( sub_loop ) ? phi->getIncomingValue(i) : phi;
    bmc_aggr_ptr->m.insert_new_def( final_val_in_outer_loop );
    //do the following if we jump 
  }
}

void bmc_aggr_pass::local_scalars_stiching(  bmc_ds_aggr* sub_bmc_aggr_ptr,
                                             bmc_ds_aggr* bmc_aggr_ptr ) {
  auto sub_loop = sub_bmc_aggr_ptr->get_loopdata()->loop;
  auto sub_head = sub_loop->getHeader();
  for( auto I = sub_head->begin(); llvm::isa<llvm::PHINode>(I); ++I ) {
    auto phi = llvm::cast<llvm::PHINode>(I);
    z3::expr en = sub_bmc_aggr_ptr->m.get_term( phi );
    z3::expr l_counter = sub_bmc_aggr_ptr->getLoopCounter();
    // if scalar matches, with the counter do not add in aggr list
    if( z3::eq( en, l_counter ) ) continue;
    unsigned i = valueIdxFromLatch( phi, sub_loop);
    z3::expr ex = sub_bmc_aggr_ptr->m.get_term( phi->getIncomingValue(i) );
    z3::expr i_n = bmc_aggr_ptr->m.get_term( phi->getIncomingValue(1-i) );
    auto final_val_in_outer_loop =
      isLoopRotated( sub_loop ) ? phi->getIncomingValue(i) : phi;
    z3::expr f = bmc_aggr_ptr->m.get_term( final_val_in_outer_loop );
    aggr_name ag_name( i_n, en, ex, f );
    sub_bmc_aggr_ptr->aggr_scalars.push_back( ag_name );
  }
  for( auto l : sub_bmc_aggr_ptr->get_read_outer_locals() ) {
    z3::expr l_name = sub_bmc_aggr_ptr->m.get_term( l );
    bmc_aggr_ptr->aggr_reads.push_back( l_name );
  }
}

bmc_ds_aggr*
bmc_aggr_pass::runOnLoop( llvm::Loop *L,
                          bmc_ds_aggr* prev_bmc_aggr_ptr ) {
  // local pointer to record bmc
  auto ld = bmc_obj.ld_map.at(L);
  auto bmc_aggr_ptr = new bmc_ds_aggr( z3_ctx, ary_to_int,
                                       bmc_obj.g_model, ld,
                                       prev_bmc_aggr_ptr );
  assert( bmc_aggr_ptr );

  // set the pointer in base class
  bmc_ds_ptr = bmc_aggr_ptr;
  auto pair = std::make_pair( L, bmc_aggr_ptr );
  bmc_obj.get_loop_aggr_map().insert( pair );

  //Find back edges coming from latches
  if( L ) {
    bmc_aggr_ptr->eb = L->getHeader();
    bmc_aggr_ptr->collect_loop_back_edges(L);
  } else {
    // outermost code
    assert( ld->getCurrentBlocks()[0] );
    bmc_aggr_ptr->eb = ld->getCurrentBlocks()[0];
    // if no loop, no back edges
  }
  if( prev_bmc_aggr_ptr )
    bmc_aggr_ptr->import_expr_map( prev_bmc_aggr_ptr->m );
  else
    bmc_aggr_ptr->import_expr_map( def_map );

  // Collect blocks to be processed
  bmc_aggr_ptr->bb_vec.clear();
  std::vector< loopdata* >& sub_loops = ld->childHeads;
  unsigned gap_num = 0;
  std::vector<unsigned> bmc_vec_gap_maker;
  z3::expr e(z3_ctx);// dummy filler
  for( auto b : ld->getCurrentBlocks() ) {
    if( b == NULL ) {
      // encounterred subloop

      //process the blocks of the current loops so far
      //
      // if(gap_num == 0 ) {
      //   init_glb_and_arry( bmc_aggr_ptr, prev_bmc_aggr_ptr );
      // }
      update_heap_model( bmc_aggr_ptr, prev_bmc_aggr_ptr );
      if( gap_num == 0 && prev_bmc_aggr_ptr ) init_aggr_lists( bmc_aggr_ptr );
      bmc_aggr_ptr->setup_prevs_non_repeating();
      do_bmc();

      //processing sub loops
      auto sub_loop = sub_loops[gap_num++];
      auto sub_bmc_aggr_ptr = runOnLoop( sub_loop->loop, bmc_aggr_ptr );
      bmc_ds_ptr = bmc_aggr_ptr; // reclaim bmc_ds_ptr
      post_sub_loop_stiching( sub_bmc_aggr_ptr, bmc_aggr_ptr);
      bmc_vec_gap_maker.push_back( bmc_aggr_ptr->bmc_vec.size() );
      // place dummy value later to be replaced
      bmc_aggr_ptr->bmc_vec.push_back(e);
    }else{
      bmc_aggr_ptr->bb_vec.push_back(b);
    }
  }
  assert( gap_num == ld->childHeads.size() );

  // if(gap_num == 0 ) {
  //   init_glb_and_arry( bmc_aggr_ptr, prev_bmc_aggr_ptr );
  // }
  update_heap_model( bmc_aggr_ptr, prev_bmc_aggr_ptr );
  if( gap_num == 0 && prev_bmc_aggr_ptr ) init_aggr_lists( bmc_aggr_ptr );
  bmc_aggr_ptr->setup_prevs_non_repeating();
  do_bmc();

  unsigned loop_count = 0;
  for(auto sub_loop : sub_loops) {
    auto sub_bmc_aggr_ptr = bmc_obj.get_loop_aggr_map().at( sub_loop->loop );
    bmc_aggr_ptr->sub_loops.push_back( sub_bmc_aggr_ptr ); //populate sub loop list 
    local_scalars_stiching( sub_bmc_aggr_ptr, bmc_aggr_ptr );
    // replace uninterated loop name in the
    unsigned dummy_idx = bmc_vec_gap_maker[loop_count];
    loop_count++;
    z3::expr_vector vars(z3_ctx);
    sub_bmc_aggr_ptr->getInitVars( vars );
    sub_bmc_aggr_ptr->getFinalVars( vars );
    z3::sort_vector sorts(z3_ctx);
    for( unsigned i = 0; i < vars.size(); i++ ) {
      sorts.push_back( vars[i].get_sort() );
    }
    static unsigned loop_name = 0;
    std::string l_name = "__loop"+ std::to_string(loop_name);
    loop_name++;
    z3::func_decl loop_f =
      z3_ctx.function( l_name.c_str(), sorts, z3_ctx.bool_sort() );
    bmc_aggr_ptr->bmc_vec[dummy_idx] = z3_ctx.bool_val(true);
    sub_bmc_aggr_ptr->uf_name = loop_f;
    sub_bmc_aggr_ptr->uf_expr = loop_f( vars );
    // Copy the specification given as a subloop in the spec of the outer dummy loop
    bmc_aggr_ptr->spec_vec.insert(bmc_aggr_ptr->spec_vec.end(),
                                  sub_bmc_aggr_ptr->spec_vec.begin(),
                                  sub_bmc_aggr_ptr->spec_vec.end());
  }

  // Local vals to be eliminated
  bmc_aggr_ptr->quant_elim_val.clear();
  for ( llvm::Value *v : ld->quant_elim_val )
    bmc_aggr_ptr->quant_elim_val.push_back(v); //Collect vals to be eliminated

  // populate latches
  std::vector<const bb*> latches;
  if( L ) {
    ld->getLoopLatches( latches );
  }else{
    for( const bb* b : ld->getCurrentBlocks() ) {
      if( b != NULL && llvm::isa<llvm::ReturnInst>( b->getTerminator() ) )
        latches.push_back(b);
    }
  }
  bmc_aggr_ptr->add_latches( latches );
  
  // populate exits
  std::vector<std::pair< const llvm::BasicBlock*, unsigned > > exits;
  ld->getExitingBlocks( exits );
  bmc_aggr_ptr->add_exits( exits );


  std::vector<z3::expr> latch_paths;
  for( auto& latch : bmc_aggr_ptr->latches) {
    latch_paths.push_back(bmc_aggr_ptr->block_to_path_bit.at(latch));
  }
  bmc_aggr_ptr->bmc_vec.push_back( _or( latch_paths, z3_ctx));

  // add_out_var_defs(L, bmc_aggr_ptr);
  // tag_exprs(L, bmc_aggr_ptr);
  eliminate_vars( z3_ctx, bmc_aggr_ptr->quant_elim_vars, bmc_aggr_ptr->bmc_vec );

  for(auto sub_bmc_aggr_ptr : bmc_aggr_ptr->sub_loops) {
    z3::expr uf_e = sub_bmc_aggr_ptr->uf_expr;
    bmc_aggr_ptr->bmc_vec.push_back(uf_e);
  }
  // update_names(bmc_aggr_ptr, false);

  return bmc_aggr_ptr; // did not modify the loop
}


