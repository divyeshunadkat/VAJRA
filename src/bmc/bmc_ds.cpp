#include "bmc/bmc_ds.h"
#include "utils/z3Utils.h"
#include "daikon-inst/loopdata.h"

unsigned bmc_ds::find_block_idx( const bb* b) {
  unsigned bidx = 0;
  for( const bb* prev_candidate : bb_vec ) {
    if( prev_candidate == b ) break;
    bidx++;
  }
  return bidx;
}

void bmc_ds::insert_prev_idx( unsigned bidx, unsigned prev_bidx) {
  assert( prev_bidx < bidx ); // check to ensure acyclicity
  pred_idxs[bidx].push_back( prev_bidx );
}

std::vector<unsigned>& bmc_ds::get_prev_idxs( unsigned bidx) {
  return pred_idxs[bidx];
}

// void bmc_ds::setup_prevs_non_repeating() {
//   unsigned bidx = 0;
//   unsigned gap_idx = 0;
//   unsigned start_sub_body = 0;
//   unsigned end_sub_body = 0;
//   if( gaps.size() > 0 ) {
//     start_sub_body = gaps[gap_idx].first;
//     end_sub_body = gaps[gap_idx].second;
//   }
//   for( const bb* src : bb_vec ) {
//     if( gap_idx < gaps.size() ) {
//       if( bidx >= end_sub_body ) {
//         //process the entry header
//         for( const bb* pre_b : sub_loop->entry_edges ) {
//           unsigned pre_b_idx = find_block_idx( pre_b );
//           insert_prev_idx( start_sub_body, pre_b_idx );
//         }
//         gap_idx++;
//         start_sub_body = gaps[gap_idx].first;
//         end_sub_body = gaps[gap_idx].second;
//       }else if( bidx >= start_sub_body ) {
//         for( auto p_idx: sub_loop->get_pred_idxs( bidx-start_sub_body ) ) {
//           insert_prev_idx( bidx, p_idx+start_sub_body );
//         }
//         continue;
//       }
//     }
//     pred_idxs[bidx].empty();
//     for(auto PI = llvm::pred_begin(src),E = llvm::pred_end(src);PI != E;++PI) {
//       const bb* prev = *PI;
//       if( ignore_edge( src, prev ) ) continue;
//       if( loop_bmc_ds* lbds = is_sub_loop_exit_block( prev ) ) {
//         std::vector<unsigned> positions;
//         lbds->get_exit_block_positions( prev, positions);
//         for( auto prev_bdx : positions) {
//           //mulitple copies create issue with phi node issue.
//           insert_prev_idx( bidx, pre_bidx );
//         }
//       }else{
//         unsigned pre_idx = find_block_idx( prev );
//         if( pre_bidx == bb_vec.size() ) continue;
//         assert( pre_bidx < bidx );
//         insert_prev_idx( bidx, pre_bidx );
//       }
//     }
//     bidx++;
//   }
// }


void bmc_ds::setup_prevs_non_repeating() {
  unsigned bidx = 0;
  for( const bb* src : bb_vec ) {
    if( bidx < processed_bidx ) { bidx++; continue; }
    pred_idxs[bidx].empty();
    for(auto PI = llvm::pred_begin(src),E = llvm::pred_end(src);PI != E;++PI) {
      const bb* prev = *PI;
      if( ignore_edge( src, prev ) ) continue;
      unsigned pre_bidx = find_block_idx( prev );
      if( pre_bidx == bb_vec.size() ) continue; // block not found
      assert( pre_bidx < bidx );                // ensure acyclic graph
      pred_idxs[bidx].push_back( pre_bidx );
    }
    bidx++;
  }
}

void bmc_ds::
copy_and_stich_segments( unsigned times ) {
  copy_and_stich_segments( bb_vec, pred_idxs, exits, latches, times);
}

void bmc_ds::
copy_and_stich_segments( std::vector<const bb*>& b_vec,
                         std::map< unsigned, std::vector<unsigned> >& prevs,
                         std::vector< std::pair<unsigned,unsigned> >& exits,
                         std::vector< unsigned >& latches,
                         unsigned times ) {
  if( times == 1 ) return;
  assert( times > 1 );
  /// check before processing
#ifndef NDEBUG
  for( unsigned l : latches ) {
    auto t = b_vec[l]->getTerminator();
    unsigned idx_succ =0;
    for(; idx_succ < t->getNumSuccessors();idx_succ++ ) {
      if( b_vec[0] == t->getSuccessor( idx_succ) ) break;
    }
    assert( idx_succ < t->getNumSuccessors());
  }
#endif
  // copy block vectors
  unsigned shift = b_vec.size();
  for( unsigned copy_num = 1; copy_num < times; copy_num++ ) {
    for( unsigned i=0;i < shift; i++ ) {
      b_vec.push_back( b_vec[i] );
    }
  }
  assert( b_vec.size() == times*shift );
  // wiring new blocks
  unsigned old_exits_size = exits.size();
  std::map< unsigned, std::vector<unsigned> > copy;
  for( unsigned copy_num = 1; copy_num < times; copy_num++ ) {
    unsigned local_shift = copy_num*shift;
    // wiring previous blocks for the newly copied blocks
    for( auto it : prevs ) {
      auto& prev = it.second;
      auto& copy_prev = copy[it.first+local_shift];
      for( unsigned i = 0; i < prev.size(); i++ ) {
        copy_prev.push_back( prev[i]+local_shift);
      }
    }
    assert( prevs[local_shift].size() == 0 );
    // Since latches of previous copy are now in the previous blocks
    // of the header of the current copy, wiring header to latches
    for( unsigned l : latches ) {
      prevs[local_shift].push_back(l+local_shift-shift);
    }
    //populating exits
    for( unsigned i = 0; i < old_exits_size; i++ ) {
      exits.push_back( {exits[i].first+local_shift,exits[i].second} );
    }
  }
  for( unsigned i=0; i < latches.size(); i++ ) {
    latches[i] = latches[i]+ (times-1)*shift;
  }
  prevs.insert( copy.begin(), copy.end() );
}

void bmc_ds::print_formulas(unsigned print_from, unsigned print_spec_from ) {
  std::cout << "Printing the bmc formula\n";
  for( unsigned i=print_from; i < bmc_vec.size(); i++ ) {
    std::cout << bmc_vec[i] << "\n";
  }
  std::cout << "Printing the specifications found from the code\n";
  for( unsigned i=print_spec_from; i < spec_vec.size(); i++ ) {
    std::cout << spec_vec[i] << "\n";
  }
}

//----------------------------------------------------------------------------
// manage global model

//returns a pair of
//  - update expr and
//  - the new that was created
std::pair<z3::expr,z3::expr>
bmc_ds::glb_write( unsigned bidx, const llvm::StoreInst* I, z3::expr& val ) {
  return g_model.glb_write( bidx, I, val );
}

z3::expr bmc_ds::glb_read( unsigned bidx, const llvm::LoadInst* I) {
  return g_model.glb_read( bidx, I );
}

z3::expr bmc_ds::get_glb_state_var( unsigned bidx,
                                    const llvm::GlobalVariable* g) {
  return g_model.get_state_var( bidx, g );
}

glb_state& bmc_ds::get_glb_state( const bb* b ) {
  unsigned bidx = find_block_idx(b);
  return g_model.get_state( bidx );
}
z3::expr bmc_ds::join_glb_state( std::vector<z3::expr>& cs,
                                 std::vector<unsigned>& prevs,
                                  unsigned src ) {
  return g_model.join_glb_state(cs, prevs, src );
}

void bmc_ds::set_glb_state( unsigned bidx, glb_state& s ) {
  assert( ar_model_init == FULL );
  return g_model.set_state( bidx , s );
}

void bmc_ds::init_glb_model(glb_state& s) {
  if( glb_model_already_init ) return;
  glb_model_already_init = true;

  if( s.get_glb_name_vec().size() == 0 )
    g_model.init_state(0);
  else
    g_model.set_state( 0 , s );
}

void bmc_ds::init_glb_model() {
  glb_state s;
  init_glb_model( s);
}

void bmc_ds::refresh_glb_state( unsigned bidx, const llvm::GlobalVariable* g) {
  g_model.refresh_glb_state( bidx, g );
}

//----------------------------------------------------------------------------
// manage array model

void bmc_ds::set_ary_to_int(std::map< const llvm::Instruction*, unsigned >& aim) {
  ary_to_int = aim;
}

void bmc_ds::init_array_model( array_model_t ar_model_local,
                               array_state& s ) {
  unsigned bidx = 0;
  for( const bb* bb : bb_vec ) {
    if( bb == NULL ) continue;
    if( bidx++ < processed_bidx ) continue; 
    for( auto it = bb->begin(), e = bb->end(); it != e; ++it) {
      auto I = &(*it);
      if( auto load = llvm::dyn_cast<const llvm::LoadInst>(I) ) {
        auto op_ptr = load->getPointerOperand();
        const llvm::BitCastInst* op_ptr_bc = NULL;
        if( (op_ptr_bc = llvm::dyn_cast<const llvm::BitCastInst>(op_ptr)) )
          op_ptr = op_ptr_bc->getOperand(0);
        if(auto gep = llvm::dyn_cast<const llvm::GetElementPtrInst>(op_ptr)) {
          auto op_gep_ptr = gep->getPointerOperand();
          if(auto addr = llvm::dyn_cast<const llvm::Instruction>(op_gep_ptr)) {
            ary_access_to_index[load] = ary_to_int.at(addr);
          }else{}// no errors!!
        }else{
          // tiler_error("bmc", "non array global write/read not supported!");
        }
      }else{} // no errors
      if(auto store = llvm::dyn_cast<const llvm::StoreInst>(I)) {
        auto op_ptr = store->getPointerOperand();
        const llvm::BitCastInst* op_ptr_bc = NULL;
        if( (op_ptr_bc = llvm::dyn_cast<const llvm::BitCastInst>(op_ptr)) )
          op_ptr = op_ptr_bc->getOperand(0);
        if(auto gep = llvm::dyn_cast<const llvm::GetElementPtrInst>(op_ptr)) {
          auto op_gep_ptr = gep->getPointerOperand();
          if(auto addr = llvm::dyn_cast<const llvm::Instruction>(op_gep_ptr)) {
            ary_access_to_index[store] = ary_to_int.at(addr);
          }else{}// no errors!!
        }else{
          // tiler_error("bmc", "non array global write/read not supported!");
        }
      }else{} // no errors
    }
  }
  unsigned array_num = ary_to_int.size();
  std::vector<std::pair< const llvm::Instruction*, unsigned >>
    ary_to_int_vec(ary_to_int.begin(), ary_to_int.end());
  auto comp = [](std::pair<const llvm::Instruction*, unsigned> const & x,
                std::pair<const llvm::Instruction*, unsigned> const & y) {
    return  x.second < y.second;
  };
  std::sort(ary_to_int_vec.begin(), ary_to_int_vec.end(), comp);
  std::vector<z3::sort> sorts;
  for(auto it = ary_to_int_vec.begin(); it != ary_to_int_vec.end(); it++) {
    llvm::Type* ty = it->first->getType();
    if( auto pty = llvm::dyn_cast<llvm::PointerType>(ty) ) {
      auto el_ty = pty->getElementType();
      z3::sort z_sort = llvm_to_z3_sort(z3_ctx, el_ty);
      if( auto alloc = llvm::dyn_cast<llvm::AllocaInst>(it->first) ) {
        if(alloc->isStaticAlloca()) {
          sorts.push_back(z_sort);
        } else {
          sorts.push_back(z3_ctx.array_sort( z3_ctx.int_sort(), z_sort ));
        }
      } else {assert(false);}
    } else {}
  }
  std::map< const llvm::Instruction*, unsigned >& map = ary_access_to_index;
  if(ar_model_local == FULL) {
    // full model using store and select
    //    init_full_array_model( array_num, map, s );
    init_full_array_model( sorts, map, s );
    // ar_model_full.init_state( eb );
  } else if ( ar_model_local == FIXED_LEN) { //
    // array has fixed number of 'symbolic' cells
    init_fixed_len_array_model(array_num, map);
  } else if ( ar_model_local == PARTITION) {
    // vaphor like model
    init_partition_array_model(array_num);
  } else {
    tiler_error("bmc", "array model initialization");
  }
}

void bmc_ds::init_array_model( array_model_t ar_model_local ) {
  array_state s;
  init_array_model( ar_model_local, s );
}
void bmc_ds::
init_full_array_model( unsigned array_num,
                       std::map< const llvm::Instruction*, unsigned >& map,
                       array_state& s ) {
  ar_model_full.set_access_map( map );//todo : hack!!
  if( ar_model_init != NONE ) return;
  ar_model_init = FULL;
  ar_model_full.set_array_num( array_num );
  ar_model_full.init_state( 0, s );
}

void bmc_ds::
init_full_array_model( std::vector<z3::sort>& sorts,
                       std::map< const llvm::Instruction*, unsigned >& map,
                       array_state& s ) {
  ar_model_full.set_access_map( map );//todo : hack!!
  if( ar_model_init != NONE ) return;
  ar_model_init = FULL;
  ar_model_full.set_array_num( sorts );
  ar_model_full.init_state( 0, s );
}

void bmc_ds::init_fixed_len_array_model(unsigned part_num,
                                     std::map< const llvm::Instruction*, unsigned >& map) {
  if( ar_model_init != NONE )
      tiler_error( "bmc", "array model is already initialized" );
  ar_model_init = FIXED_LEN;
  ar_model_fixed.set_partition_len( part_num );
  ar_model_fixed.set_access_map( map );
}


void bmc_ds::init_partition_array_model(unsigned part_num) {
  if( ar_model_init != NONE )
      tiler_error( "bmc", "array model is already initialized" );
  ar_model_init = PARTITION;
  // ar_model_part.init(part_num);
  tiler_error( "bmc", "stub!!" );
}


void bmc_ds::refresh_array_state( unsigned bidx,
                                  const llvm::Instruction* I) {
  assert( ar_model_init == FULL );
  ar_model_full.update_name( bidx, ary_to_int[I] );
}

//returns a pair of
//  - update expr and
//  - the new that was created
std::pair<z3::expr,z3::expr>
bmc_ds::array_write( unsigned bidx, const llvm::StoreInst* I,
                      z3::expr& idx, z3::expr& val ) {
  assert( I );
  switch( ar_model_init ) {
  case FULL     : return ar_model_full.array_write( bidx, I, idx, val ); break;
  case FIXED_LEN: return ar_model_full.array_write( bidx, I, idx, val ); break;
  // case PARTITION: return ar_model_full.array_write( I, val ); break;
  default:
    tiler_error( "bmc", "incomplete implementation of an array model!!" );
  }
}

z3::expr bmc_ds::array_read( unsigned bidx, const llvm::LoadInst* I,
                               z3::expr& idx ) {
  assert( I );
  switch( ar_model_init ) {
  case FULL     : return ar_model_full.array_read( bidx, I, idx ); break;
  case FIXED_LEN: return ar_model_full.array_read( bidx, I, idx ); break;
  // case PARTITION: return ar_model_full.array_read( I, val ); break;
  default:
    tiler_error( "bmc", "incomplete implementation of an array model!!" );
  }
}

z3::expr bmc_ds::get_array_state_var( unsigned bidx,
                                      const llvm::AllocaInst* alloc ) {
  unsigned ith_ary = ary_to_int.at( alloc );
  return ar_model_full.get_array_state_var( bidx, ith_ary );
}

z3::expr bmc_ds::get_array_state_var( unsigned bidx,
                                      const llvm::Instruction* alloc ) {

  unsigned ith_ary = ary_to_int.at( alloc );
  return ar_model_full.get_array_state_var( bidx, ith_ary );
}

z3::expr bmc_ds::get_array_state_var( const bb* b,
                                      const llvm::Instruction* alloc ) {
  unsigned bidx = find_block_idx(b);
  unsigned ith_ary = ary_to_int.at( alloc );
  return ar_model_full.get_array_state_var( bidx, ith_ary );
}

void bmc_ds::set_array_state( unsigned bidx, array_state& s ) {
  assert( ar_model_init == FULL );
  return ar_model_full.set_array_state( bidx , s );
}

array_state& bmc_ds::get_array_state( const bb* b ) {
  unsigned bidx = find_block_idx(b);
  return ar_model_full.get_state( bidx );
}

array_state& bmc_ds::get_array_state( unsigned bidx ) {
  return ar_model_full.get_state( bidx );
}

z3::expr bmc_ds::join_array_state(std::vector<z3::expr>& cs,
                                  std::vector<unsigned>& prevs,
                                  unsigned src ) {
  assert( src );
  assert( cs.size() == prevs.size() );
  switch(ar_model_init) {
  case FIXED_LEN: return ar_model_fixed.join_array_state(cs,prevs, src ); break;
  case FULL:      return ar_model_full.join_array_state(cs, prevs, src ); break;
  // case PARTITION: return ar_model_part.join_array_state(cs, prevs, src);break;
  default:
    tiler_error( "bmc", "incomplete implementation of an array model!!" );
  }
}

int bmc_ds::get_array_index( unsigned bidx, z3::expr e ) {
  return ar_model_full.get_array_index(bidx, e);
}

int bmc_ds::get_array_index( array_state& s, z3::expr e ) {
  return ar_model_full.get_array_index(s, e);
}

const llvm::Instruction* bmc_ds::get_alloca_for_index(unsigned index) {
  if(index < 0) return NULL;
  const llvm::Instruction* arr_alloc = NULL;
  auto it = ary_to_int.begin();
  for(; it != ary_to_int.end(); it++) {
    if(it->second == index) {
      arr_alloc = it->first;
      break;
    }
  }
  return arr_alloc;
}

//---------------------------------------------------------------------

unsigned bmc_fun::get_call_count( const llvm::CallInst* call ) {
  unsigned i = 0;
  while( i < call_sites.size() ) {
    if( call_sites[i] == call ) return i;
  }
  tiler_error( "bmc", "untracked callsite found!!" );
  return 0; // dummy return to avoid warning
}

//---------------------------------------------------------------------

void bmc_loop::collect_loop_back_edges(llvm::Loop* L) {
  auto h = L->getHeader();
  llvm::SmallVector<llvm::BasicBlock*,10> LoopLatches;
  L->getLoopLatches( LoopLatches );
  for( llvm::BasicBlock* bb : LoopLatches ) {
    loop_ignore_edges[h].insert( bb );
  }
}

void bmc_loop::get_written_arrays(
 std::vector<const llvm::AllocaInst*>& arrays_updated ) {
  ld->getWrittenArrays( arrays_updated );
}

void bmc_loop::get_written_globals(
  std::vector<const llvm::GlobalVariable*>& glbs ) {
  ld->getWrittenGlbs( glbs );
}

std::vector<const llvm::AllocaInst*>& bmc_loop::get_pure_read_arrays() {
  return ld->arrPureRead;
}
std::vector<const llvm::GlobalVariable*>& bmc_loop::get_pure_read_globals() {
  return ld->glbPureRead;
}
std::vector<llvm::Value*>& bmc_loop::get_read_outer_locals(){
  return ld->const_val;
}

//---------------------------------------------------------------------

bool bmc_ds_aggr::isPeelLast()  { return !ld->peel_direction_first; }
bool bmc_ds_aggr::isPeelFirst() { return ld->peel_direction_first; }

void bmc_ds_aggr::getInitArrays ( z3::expr_vector& names) {
  for( auto ag_names : aggr_arrays ) names.push_back( ag_names.i );
}
void bmc_ds_aggr::getEntryArrays( z3::expr_vector& names) {
  for( auto ag_names : aggr_arrays ) names.push_back( ag_names.en );
}
void bmc_ds_aggr::getExitArrays ( z3::expr_vector& names) {
  for( auto ag_names : aggr_arrays ) names.push_back( ag_names.ex );
}
void bmc_ds_aggr::getFinalArrays( z3::expr_vector& names) {
  for( auto ag_names : aggr_arrays ) names.push_back( ag_names.f );
}

void bmc_ds_aggr::getInitVars ( z3::expr_vector& names) {
  for( auto ag_names : aggr_scalars ) names.push_back( ag_names.i );
  getInitArrays( names );
}
void bmc_ds_aggr::getEntryVars( z3::expr_vector& names) {
  for( auto ag_names : aggr_scalars ) names.push_back( ag_names.en );
  getEntryArrays( names );
}
void bmc_ds_aggr::getExitVars ( z3::expr_vector& names) {
  for( auto ag_names : aggr_scalars ) names.push_back( ag_names.ex );
  getExitArrays( names );
}
void bmc_ds_aggr::getFinalVars( z3::expr_vector& names) {
  for( auto ag_names : aggr_scalars ) names.push_back( ag_names.f );
  getFinalArrays( names );
}


z3::expr bmc_ds_aggr::getLoopCounter() {
  return ld->ctrZ3Expr;
}

z3::expr bmc_ds_aggr::getLastCounterExpr() {
  return ld->exitBound;
}

z3::expr bmc_ds_aggr::getFirstCounterExpr() {
  return ld->initBound;
}

int bmc_ds_aggr::getStepCnt() {
  return ld->stepCnt;
}

int bmc_ds_aggr::getTileSize() {
  std::map<llvm::Value*, int>::iterator bit = ld->writeTileSize.begin();
  std::map<llvm::Value*, int>::iterator eit = ld->writeTileSize.end();

  int s = 1;
  for (; bit!=eit; bit++) {
    s = bit->second;
  }
  if(s==0) s=1;
  return s;
}

int bmc_ds_aggr::getNumUpdInd() {
  std::map<llvm::Value*, int>::iterator bit = ld->numUpdInd.begin();
  std::map<llvm::Value*, int>::iterator eit = ld->numUpdInd.end();

  int s = 1;
  for (; bit!=eit; bit++) {
    s = bit->second;
  }
  return s;
}

bool bmc_ds_aggr::isWriteOverLapping() {
  std::map<llvm::Value*, bool>::iterator bit = ld->isWriteOverlapping.begin();
  std::map<llvm::Value*, bool>::iterator eit = ld->isWriteOverlapping.end();

  bool b = false;
  for (; bit!=eit; bit++) {
    b = b || bit->second;
  }
  return b;
}

bool bmc_ds_aggr::isReadOverLappingWrite() {
  std::map<llvm::Value*, bool>::iterator bit = ld->isReadOverlappingWrite.begin();
  std::map<llvm::Value*, bool>::iterator eit = ld->isReadOverlappingWrite.end();

  bool b = false;
  for (; bit!=eit; bit++) {
    b = b || bit->second;
  }
  return b;
}

bool bmc_ds_aggr::isNextIterReadOverlappingWrite() {
  std::map<llvm::Value*, bool>::iterator bit = ld->isNextIterReadOverlappingWrite.begin();
  std::map<llvm::Value*, bool>::iterator eit = ld->isNextIterReadOverlappingWrite.end();

  bool b = false;
  for (; bit!=eit; bit++) {
    b = b || bit->second;
  }
  return b;
}

std::map<llvm::Value*, std::list<llvm::Value*>>& bmc_ds_aggr::getReadMap() {
  return ld->arrRead;
}

std::map<llvm::Value*, std::list<llvm::Value*>>& bmc_ds_aggr::getWriteMap() {
  return ld->arrWrite;
}


std::map<llvm::Value*, std::list<z3::expr>>& bmc_ds_aggr::getReadExprMap() {
  return ld->arrReadExpr;
}

std::map<llvm::Value*, std::list<z3::expr>>& bmc_ds_aggr::getWriteExprMap() {
  return ld->arrWriteExpr;
}

z3::expr bmc_ds_aggr::getReadTile(llvm::Value* v) {
  assert(v);
  z3::expr res(z3_ctx);
  res = ld->readTile.at(v);
  return res;
}

z3::expr bmc_ds_aggr::getWriteTile(llvm::Value* v) {
  assert(v);
  z3::expr res(z3_ctx);
  res = ld->writeTile.at(v);
  return res;
}

exprs bmc_ds_aggr::getInterferingReadExprList() {
  exprs ret_list;
  std::map<llvm::Value*,std::list<z3::expr>>::iterator bit;
  for(bit=ld->arrReadExpr.begin(); bit!=ld->arrReadExpr.end(); bit++) {
  /*if( auto alloc = llvm::dyn_cast<llvm::AllocaInst>(bit->first) ) {
      if(alloc->isStaticAlloca()) {
        int ArraySize = 1;
        const llvm::ConstantInt *CI = llvm::dyn_cast<llvm::ConstantInt>(alloc->getArraySize());
        assert(CI && "non-constant array size");
        ArraySize = CI->getZExtValue();
        if(ArraySize == 1) {
          for(llvm::Value* v : ld->arrRead.at(bit->first)) {
            z3::expr e = m.get_term(v);
            if(isSelect(e)) {
              ret_list.push_back(e.arg(0));
            } else if(e.is_array()) {
              ret_list.push_back(e);
            } else {} // Throw ERROR
          }
          continue;
        }
      } else {}
    }*/
    std::list<llvm::Value*>::iterator arrLoadIt = ld->arrRead.at(bit->first).begin();
    bool isPureRead = ld->arrWrite.count(bit->first) == 0;
    if(!isPureRead && bit->second.size() > 1)   continue;
    for(z3::expr e : bit->second) {
      if(check_sat(z3_ctx, e == ld->ctrZ3Expr)) {
        z3::expr e = m.get_term(*arrLoadIt);
        if(!isPureRead) {
          for( auto ag_names : aggr_arrays ) {
            if(ag_names.val == bit->first) {
              z3::expr_vector out(z3_ctx);
              out.push_back(ag_names.en);
              z3::expr_vector in(z3_ctx);
              in.push_back(ag_names.i);
              inplace_substitute(e, out, in);
            }
          }
        }
        z3::expr bound(z3_ctx);
        if( isPeelFirst() ) {
          bound = getFirstCounterExpr();
        } else {
          bound = getLastCounterExpr();
        }
        inplace_substitute(e, ld->ctrZ3Expr, bound);
        if(isSelect(e)) {
          ret_list.push_back(e);
        } else {} // Throw ERROR ??
      }
      arrLoadIt++;
    }
  }
  // TODO : Add exprs for interfering global vars in the list
  return ret_list;
}

void bmc_ds_aggr::change_nonaggr_arr_name(exprs& list1, exprs& list2) {
  std::map<llvm::Value*,std::list<z3::expr>>::iterator bit;
  for(bit=ld->arrReadExpr.begin(); bit!=ld->arrReadExpr.end(); bit++) {
    bool isPureRead = ld->arrWrite.count(bit->first) == 0;
    for(z3::expr e : bit->second) {
      if(check_sat(z3_ctx, e == ld->ctrZ3Expr)) {
        if(!isPureRead) {
          for( auto ag_names : aggr_arrays ) {
            if(ag_names.val == bit->first) {
              inplace_substitute(list1, ag_names.en, ag_names.i);
              inplace_substitute(list2, ag_names.en, ag_names.i);
            }
          }
        }
      }
    }
  }
}

bool bmc_ds_aggr::hasSubLoops() {
  return sub_loops.size() > 0;
}

void bmc_ds_aggr::dump() { print( std::cout ); }

void bmc_ds_aggr::print( std::ostream& o ) {
  o << "----------------------\n";
  o << uf_expr << "\n";
  o << "Aggragated variables:\n";
  for( auto a : aggr_scalars) { a.print(o); o << "\n"; }
  for( auto a : aggr_arrays) { a.print(o); o << "\n"; }
  o << "Pure variables:\n";
  for( auto a : aggr_reads) { o << a << "\n"; }
  o << "bmc:\n";
  print_exprs( o, bmc_vec );
  o << "spec:\n";
  print_exprs( o, spec_vec );
}
