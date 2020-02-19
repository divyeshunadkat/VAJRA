#include "array_model.h"

z3::expr array_model::join_array_state( std::vector<z3::expr>& conds,
                                        std::vector<unsigned>& prevs,
                                        unsigned src
                                        ) {
  assert( conds.size() > 0  &&  prevs.size() == conds.size() );
  auto& s_names = exit_ary_map[src].get_name_vec(); // fresh state created
  unsigned ar_size = exit_ary_map.at(prevs.at(0)).get_name_vec().size();
  std::vector<z3::expr> vec;
  for( unsigned j=0; j < ar_size; j++ ) {
    //check if all equal
    auto& o_name = exit_ary_map.at(prevs.at(0)).get_name_vec().at(j);
    bool is_all_equal = true;
    for( unsigned i=1; i < conds.size(); i++ ) {
      auto& next_name = exit_ary_map.at(prevs.at(i)).get_name_vec().at(j);
      if( !z3::eq( o_name, next_name) ) {
        is_all_equal = false;
        break;
      }
    }
    if( is_all_equal ) {
      // if all symbols are euqal; no need to join.
      s_names.push_back( o_name );
    }else{
      z3::expr new_name = get_fresh_ary_name(j);
      for( unsigned i=0; i < conds.size(); i++ ) {
        auto& p_st = exit_ary_map.at(prevs.at(i)).get_name_vec();
        vec.push_back( z3::implies( conds[i], new_name == p_st.at(j) ) );
      }
      s_names.push_back( new_name );
    }
  }
  return _and( vec, z3_ctx );
}

z3::expr array_model_full::get_fresh_ary_name( unsigned i ) {
  z3::sort ar_sort = ar_sorts.at(i);
  if( !ar_sort.is_array() ) {
    tiler_error( "bmc", "bad sort is passed!!" );
  }
  auto ar = get_fresh_const( z3_ctx, ar_sort, "arr" );
  return ar;
}

void array_model_full::init_state( unsigned eb ) {
  array_state& s = exit_ary_map[eb];
  auto& vec = s.get_name_vec();
  vec.clear();
  for( unsigned i = 0; i < num_arrays; i++) {
    vec.push_back( get_fresh_ary_name( i ) );
  }
}

void array_model_full::init_state( unsigned eb, array_state& s ) {
  if( s.get_name_vec().size() == 0 )
    init_state(eb);
  else
    exit_ary_map[eb] = s;
}

void array_model_full::copy_to_init_state( array_state& in ) {
  array_state& s = exit_ary_map.at(0);
  auto& vec = s.get_name_vec();

  auto& in_vec = in.get_name_vec();
  for( unsigned i = 0; i < num_arrays; i++) {
    vec[i] = in_vec.at(i);
  }
}

std::pair<z3::expr,z3::expr>
array_model_full::array_write( unsigned bidx, const llvm::StoreInst* I,
                               z3::expr& idx, z3::expr& val ) {
  array_state& ar_st = get_state( bidx );
  auto i = ary_access_to_index.at(I);
  auto& vec = ar_st.get_name_vec();
  z3::expr ar_name = vec.at(i);
  z3::expr new_ar = get_fresh_ary_name(i);
  vec[i] = new_ar;
  return std::make_pair( (new_ar == z3::store( ar_name, idx, val )), new_ar);
}

z3::expr
array_model_full::array_read( unsigned bidx, const llvm::LoadInst* I,
                              z3::expr& idx) {
  array_state& ar_st = get_state( bidx );
  auto i = ary_access_to_index.at(I);
  auto& vec = ar_st.get_name_vec();
  z3::expr ar_name = vec.at(i);
  return z3::select( ar_name, idx);
}

void array_model_full::
update_names( unsigned eb,
              std::vector<const llvm::Instruction*>& arrays_updated ) {
  array_state& s = exit_ary_map.at(eb);
  auto& vec = s.get_name_vec();
  for( auto I : arrays_updated) {
    auto i = ary_access_to_index.at(&(*I));
    z3::expr new_ar = get_fresh_ary_name(i);
    vec[i] = new_ar;
    //vec[i] = get_fresh_ary_name(i);
  }
}

void array_model_full::update_name( unsigned eb, unsigned i) {
  array_state& s = exit_ary_map.at(eb);
  auto& vec = s.get_name_vec();
  z3::expr new_ar = get_fresh_ary_name(i);
  vec[i] = new_ar;
}

int array_model_full::get_array_index( unsigned bidx, z3::expr e ) {
  array_state& s = exit_ary_map.at(bidx);
  return get_array_index(s, e);
}

int array_model_full::get_array_index( array_state& s, z3::expr e ) {
  auto& vec = s.get_name_vec();
  int index = -1;
  for( unsigned i = 0; i < num_arrays; i++) {
    if( z3::eq(vec[i], e) ) index = i;
  }
  return index;
}

//=======================================================================

z3::expr array_model_fixed_len::get_fresh_ary_name( unsigned i ) {
  return get_fresh_int(z3_ctx);
}

void array_model_fixed_len::init_state( unsigned //const bb*
                                        eb ) {
  array_state& s = exit_ary_map[eb];
  auto& vec = s.get_name_vec();
  vec.clear();
  for( unsigned i = 0; i < num_partition; i++) {
    vec.push_back( get_fresh_int(z3_ctx) );
  }
}

std::pair<z3::expr,z3::expr>
array_model_fixed_len::array_write( unsigned bidx,
                                    const llvm::StoreInst* I,
                                    z3::expr& idx,
                                    z3::expr& val ) {
  tiler_error( "bmc", "stub!!" );
  return std::make_pair(idx,idx);
}

z3::expr array_model_fixed_len::array_read( unsigned bidx,
                                            const llvm::LoadInst* I,
                                            z3::expr& idx) {
  tiler_error( "bmc", "stub!!" );
  return idx;
}

// array_state&
// array_model_fixed_len::join_array_state(std::vector<const bb*> prevs,
//                                         const bb* b ) {
//   exit_ary_map[b];
//   array_state& st = exit_ary_map.at(b); // tobe added

//   return st;
// }
