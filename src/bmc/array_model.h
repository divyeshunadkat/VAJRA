#ifndef TILER_ARRAY_MODEL_H
#define TILER_ARRAY_MODEL_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"
#include "utils/options.h"

// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wunused-parameter"
// // #include "llvm/Pass.h"
// #include "llvm/IR/Value.h"
// #include "llvm/IR/Constants.h"
// // #include "llvm/Support/raw_ostream.h"
// // #include "llvm/IR/Instructions.h"
// // #include "llvm/IR/IntrinsicInst.h"
// #pragma GCC diagnostic pop

class array_state{
public:

  // array_state( unsigned total_partitions ) {
  //   pm_state = new partition_model_state();
  // }
  array_state() {}

  //anything else is needed???
  std::vector<z3::expr>& get_name_vec() { return array_index_names; };
private:
  std::vector<z3::expr> array_index_names;
};


class array_model_full;
class array_model_fixed_len;
class array_model_partition;

class array_model{
public:
  array_model( z3::context& ctx_ ) : z3_ctx(ctx_) {}

  // need to provide copy operator

  // void init_array_state( const bb* );
  z3::expr join_array_state( std::vector<z3::expr>&,
                             std::vector<unsigned>& prevs,
                             unsigned src
                             // std::vector<const bb*>&,
                             // const bb*
                             );
  virtual z3::expr get_fresh_ary_name( unsigned ) = 0;
  // virtual z3::expr array_write( llvm::Instruction* I, z3::expr idx,
  //                               z3::expr val ) = 0;
  // virtual z3::expr array_read( llvm::Instruction* I, z3::expr idx ) = 0;

  // array_state& get_array_state( const bb* b ) { return exit_ary_map.at(b); }
  array_state& get_state( unsigned b ) { return exit_ary_map.at(b); }
  void set_array_state( unsigned b, array_state& s ) {
    exit_ary_map[b] = s;
  }

  z3::expr get_array_state_var( unsigned b, unsigned ith_ary ) {
    return exit_ary_map.at(b).get_name_vec()[ith_ary];
  }

private:
  z3::context& z3_ctx;
  array_model_t model = NONE;
  // std::map< const bb*, array_state > exit_ary_map;
  std::map< unsigned, array_state > exit_ary_map;

  friend array_model_full;
  friend array_model_fixed_len;
  friend array_model_partition;
};


class array_model_full : public array_model {
public:
  array_model_full( z3::context& ctx_ ) : array_model(ctx_) {
    model = FULL;
  }

  inline void set_array_num( unsigned len ) {
    num_arrays = len;
    for( unsigned i = 0; i < num_arrays; i++) {
      ar_sorts.push_back( z3_ctx.array_sort( z3_ctx.int_sort(),
                                             z3_ctx.int_sort() ) );
    }
  }

  inline void set_array_num( std::vector<z3::sort>& sorts ) {
    ar_sorts = sorts;
    num_arrays = ar_sorts.size();
  }

  inline void
  set_access_map( std::map< const llvm::Instruction*, unsigned >& map ) {
    ary_access_to_index = map;
  }

  inline void
  insert_access_map( const llvm::Instruction* I, unsigned idx ) {
    ary_access_to_index[I] = idx;
  }

  // void init_state( const bb* );
  void init_state( unsigned );
  void init_state( unsigned eb, array_state& s );
  virtual z3::expr get_fresh_ary_name( unsigned );
  //virtual

  std::pair<z3::expr,z3::expr>
  array_write( unsigned bidx, const llvm::StoreInst* I,
               z3::expr& idx, z3::expr& val );
  //virtual
  z3::expr array_read( unsigned bidx, const llvm::LoadInst* I, z3::expr& idx );

  void update_names( unsigned, std::vector<const llvm::Instruction*>&);
  void update_name( unsigned, unsigned );
  void copy_to_init_state( array_state& );

  int get_array_index(unsigned, z3::expr);
  int get_array_index(array_state&, z3::expr);

private:
  unsigned num_arrays;
  std::vector< z3::sort > ar_sorts;
  std::map< const llvm::Instruction*, unsigned > ary_access_to_index;
};

class array_model_fixed_len : public array_model {
public:
  array_model_fixed_len( z3::context& ctx_ ) : array_model(ctx_) {
    model = FIXED_LEN;
  }

  // void init_state( const bb* );
  void init_state( unsigned );

  inline void set_partition_len( unsigned len ) { num_partition = len; }
  inline void
  set_access_map( std::map< const llvm::Instruction*, unsigned >& map ) {
    ary_access_to_patition_map = map;
  }
  virtual z3::expr get_fresh_ary_name( unsigned );
  //virtual
  std::pair<z3::expr,z3::expr>
  array_write( unsigned bidx, const llvm::StoreInst* I, z3::expr& idx, z3::expr& val );
  //virtual
  z3::expr array_read( unsigned bidx, const llvm::LoadInst* I, z3::expr& val );

private:
  unsigned num_partition=0;
  std::map< const llvm::Instruction*, unsigned > ary_access_to_patition_map;

};


class array_model_partition : public array_model {
public:
  array_model_partition( z3::context& ctx_ ) : array_model(ctx_) {
    model = PARTITION;
  }
  virtual z3::expr get_fresh_ary_name( unsigned );

};




#endif //TILER_ARRAY_MODEL_H
