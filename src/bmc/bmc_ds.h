#ifndef TILER_BMC_DS_H
#define TILER_BMC_DS_H

#include <unordered_map>
#include "utils/z3Utils.h"
#include "utils/llvmUtils.h"
#include "bmc/glb_model.h"
#include "bmc/array_model.h"
// #include "aggregation/aggregate.h"

enum aggr_tag {tile, overlap, counter, aggregate, unknown};

typedef std::unordered_map<z3::expr, enum aggr_tag, expr_hash, expr_equal> expr_tag;

class bmc_ds {
public:
  z3::context& z3_ctx;
  value_expr_map m;

  bmc_ds( z3::context& z3_ctx_,
          std::map<const llvm::Instruction*, unsigned>& aim,
          glb_model& g_model_ )
    : z3_ctx( z3_ctx_)
    , m(z3_ctx)
    , g_model( g_model_ )
    , ar_model_full( z3_ctx )
    , ar_model_fixed( z3_ctx )
    , ary_to_int(aim)
    , aggr_N(z3_ctx)
{}
  //--------------------------------------------------------------------------
  //interface to global model

  glb_model g_model;
  bool glb_model_already_init = false;

  std::pair<z3::expr,z3::expr>
  glb_write(unsigned, const llvm::StoreInst*, z3::expr& );
  z3::expr glb_read( unsigned, const llvm::LoadInst*);
  z3::expr join_glb_state( std::vector<z3::expr>&,
                             std::vector<unsigned>&, unsigned );

  glb_state& get_glb_state( const bb* b );
  z3::expr get_glb_state_var( unsigned bidx, const llvm::GlobalVariable*);
  void set_glb_state( unsigned bidx, glb_state& );
  void init_glb_model( glb_state& );
  void init_glb_model();
  void refresh_glb_state( unsigned, const llvm::GlobalVariable* );

  //--------------------------------------------------------------------------
  //interface to array model

  array_model_t ar_model_init = NONE;
  array_model_full      ar_model_full;
  array_model_fixed_len ar_model_fixed;
  // array_model_partition ar_model_part;

  std::map< const llvm::Instruction*, unsigned > ary_access_to_index;
  std::map< const llvm::Instruction*, unsigned > ary_to_int;

  void set_ary_to_int(std::map< const llvm::Instruction*, unsigned >&);

  std::pair<z3::expr,z3::expr>
  array_write(unsigned, const llvm::StoreInst*, z3::expr&, z3::expr& );
  z3::expr array_read( unsigned, const llvm::LoadInst*, z3::expr& idx);
  z3::expr join_array_state( std::vector<z3::expr>&,
                             std::vector<unsigned>&, unsigned );

  array_state& get_array_state( const bb* b );
  array_state& get_array_state( unsigned bidx );
  void set_array_state( unsigned bidx, array_state& );
  z3::expr get_array_state_var( unsigned bidx, const llvm::AllocaInst*);
  z3::expr get_array_state_var( unsigned bidx, const llvm::Instruction*);
  z3::expr get_array_state_var( const bb* b, const llvm::Instruction*);

  int get_array_index( unsigned, z3::expr);
  int get_array_index( array_state&, z3::expr);
  const llvm::Instruction* get_alloca_for_index(unsigned index);

  //--------------------------------------------------------------------------
  // initialization of array models
  // two array models can not be initialized at the sametime;
  // once a model is initialized, call to the other initializations will throw
  // error.
  void init_partition_array_model(unsigned part_num);
    void init_full_array_model( std::vector<z3::sort>&,
                              std::map<const llvm::Instruction*,unsigned>&,
                              array_state& );
  void init_full_array_model( unsigned,
                              std::map<const llvm::Instruction*,unsigned>&,
                              array_state& );
  void init_fixed_len_array_model( unsigned,
                                   std::map<const llvm::Instruction*,unsigned>&);
  void init_array_model( array_model_t );
  void init_array_model( array_model_t ar_model_local, array_state& );
  void refresh_array_state( unsigned, std::vector<const llvm::Instruction*>& );
  void refresh_array_state( unsigned, const llvm::Instruction* );

  //--------------------------------------------------------------------------

  inline void import_expr_map( value_expr_map& m_ ) {
    // m.copy_values( m_ );
    m_.copy_values( m );
  }

  const bb* eb; //todo: deprecate

  unsigned processed_bidx = 0;
  bb_vec_t bb_vec; // index in this vector is the block id
  std::map< unsigned, std::vector<unsigned> > pred_idxs;
  std::vector< std::pair<unsigned,unsigned> > exits; //block_position,succ_no
  std::vector< unsigned > latches;

  std::map< const bb*, unsigned> block_to_id; // todo: deprecate

  std::map< unsigned, z3::expr > block_to_path_bit;
  std::map< unsigned, std::vector<z3::expr> > block_to_exit_bits;

  void print_formulas( unsigned print_from = 0, unsigned print_spec_from = 0);

  void insert_prev_idx( unsigned bidx, unsigned prev_bidx);
  std::vector<unsigned>& get_prev_idxs( unsigned bidx);

  unsigned find_block_idx( const bb* b);

  inline void add_latch( unsigned lidx  ) {
    latches.push_back( lidx );
  }

  inline void add_latch( const bb* latch  ) {
    auto l_idx = find_block_idx( latch );
    add_latch( l_idx );
  }

  inline void add_latches( std::vector<const bb*> latches  ) {
    for( const bb* latch : latches )
      add_latch( latch );
  }

  inline void add_exit( unsigned lidx, unsigned succ_num  ) {
    exits.push_back( {lidx, succ_num} );
  }

  inline void add_exit( const bb* exit, unsigned succ_num  ) {
    auto l_idx = find_block_idx( exit );
    add_exit( l_idx, succ_num );
  }

  inline void add_exits( std::vector< std::pair< const bb*, unsigned > > es ) {
    for( auto& exit : es )
      add_exit( exit.first, exit.second );
  }

  inline
  void get_exit_block_positions( const bb* prev,
                                 std::vector<unsigned>& positions ) {
    for( auto& bidx : exits) {
      if( bb_vec[bidx.first] == prev ) positions.push_back( bidx.first );
    }
  }

  inline z3::expr get_path_bit( unsigned bidx ) {
    return block_to_path_bit.at(bidx);
  }

  inline void set_path_bit( unsigned bidx, z3::expr b ) {
    auto it = block_to_path_bit.find(bidx);
    if( it != block_to_path_bit.end() ) {
      block_to_path_bit.erase( it );
    }
    auto pair = std::make_pair( bidx, b );
    block_to_path_bit.insert( pair );
  }

  inline std::vector< z3::expr >& get_exit_bits( unsigned bidx ) {
    return block_to_exit_bits.at(bidx);
  }

  inline z3::expr get_exit_bit( unsigned bidx, unsigned succ_num ) {
    auto& vec= get_exit_bits( bidx );
    if( vec.size() == 0 && succ_num == 0 ) {
      return z3_ctx.bool_val(true);
    }if( vec.size() == 0 && succ_num > 0 ) {
      // special case of artificial wiring; for aggregation module
      // aggregation module interferes with generation of exit and path bits
      return z3_ctx.bool_val(true);
    }else{
      assert(  succ_num < vec.size() );
      return vec[succ_num];
    }
  }

  inline void set_exit_bits( unsigned bidx, std::vector<z3::expr>& b ) {
    block_to_exit_bits[bidx] = b;
  }

  inline z3::expr get_exit_branch_path( unsigned bidx, unsigned succ_num) {
    return get_path_bit( bidx ) && get_exit_bit( bidx, succ_num );
  }

  inline void add_bmc_formulas(  std::vector< z3::expr > fs ) {
    bmc_vec.insert( bmc_vec.begin(), fs.begin(), fs.end() );
  }

  void setup_prevs_non_repeating();
  void copy_and_stich_segments( unsigned times );
  void copy_and_stich_segments( std::vector<const bb*>&,
                                std::map< unsigned, std::vector<unsigned> >&,
                                std::vector< std::pair<unsigned,unsigned> >&,
                                std::vector< unsigned >& latches,
                                unsigned times
                                );
  std::vector<z3::expr> bmc_vec;  //final result;
  std::vector<z3::expr> spec_vec; //specs from the code;
  std::vector<z3::expr> quant_elim_vars;
  std::vector<z3::expr> assert_path_bits;
  std::vector<llvm::Value*> quant_elim_val;
  z3::expr aggr_N;

  expr_tag subexpr_tags;

  std::set<std::string> locals;
  std::map< const llvm::Instruction*, std::string > dbg_name_map;

  std::map< const bb*, bb_set_t > loop_ignore_edges;
  std::map< const bb*, bb_set_t > rev_loop_ignore_edges;

  bool ignore_edge( const bb* cb, const bb* prev) {
    if( exists( loop_ignore_edges, cb ) )
      return exists( loop_ignore_edges.at( cb ), prev);
    return false;
  }

  inline void dump_bb_vec() {
    for( auto* b : bb_vec) {
      if(b) LLVM_DUMP(b);
    }
  }

  virtual ~bmc_ds() {}
};

class bmc_fun : public bmc_ds {

public:
  bmc_fun( z3::context& z3_ctx_,
           std::map<const llvm::Instruction*, unsigned>& aim,
           glb_model& g_model)
    : bmc_ds( z3_ctx_, aim, g_model) {}

  // Call sites
  std::vector<const llvm::CallInst*> call_sites;
  unsigned get_call_count( const llvm::CallInst* call );

  virtual ~bmc_fun() = default;
};
class bmc_ds_aggr;
class bmc_loop : public bmc_ds {

  loopdata* ld = 0;
public:
  bmc_loop( z3::context& z3_ctx_,
            std::map<const llvm::Instruction*, unsigned>& aim,
            glb_model& g_model,
            loopdata* ld_ )
    : bmc_ds( z3_ctx_, aim, g_model)
    , ld(ld_) {}

  inline loopdata* get_loopdata() { return ld; }

  void get_written_arrays( std::vector<const llvm::AllocaInst*>& );
  void get_written_globals( std::vector<const llvm::GlobalVariable*>& );
  std::vector<const llvm::AllocaInst*>& get_pure_read_arrays();
  std::vector<const llvm::GlobalVariable*>& get_pure_read_globals();
  std::vector<llvm::Value*>& get_read_outer_locals();

  void collect_loop_back_edges(llvm::Loop*);
  virtual ~bmc_loop() = default;
  friend bmc_ds_aggr;
};

class aggr_name {
public:
  aggr_name(z3::expr i, z3::expr en, z3::expr ex, z3::expr f)
    : i(i), en(en), ex(ex), f(f), val(NULL) {}
  aggr_name(z3::expr i, z3::expr en, z3::expr ex, z3::expr f, llvm::Value* v)
    : i(i), en(en), ex(ex), f(f), val(v) {}
  z3::expr i;
  z3::expr en;
  z3::expr ex;
  z3::expr f;
  const llvm::Value* val;
  unsigned bmc_idx = 0; // for backward book keeping
  inline void setInit(z3::expr e )  { i = e;  }
  inline void setEntry(z3::expr e ) { en = e; }
  inline void setExit(z3::expr e )  { ex = e; }
  inline void setFinal(z3::expr e ) { f = e;  }
  inline void setVal(const llvm::Value* v){ val = v;  }
  inline const llvm::Value* getVal()  { return val; }

  inline void dump() { print( std::cout ); }
  inline void print( std::ostream& o ) {
    o << "[init: " << i << " entry: "<< en
      << " exit: "<< ex << " final: "<< f << "]";
  }
};

class bmc_ds_aggr : public bmc_loop {
public:
  bmc_ds_aggr( z3::context& z3_ctx_,
               std::map<const llvm::Instruction*, unsigned>& aim,
               glb_model& g_model,
               loopdata* ld_,
               bmc_ds_aggr* parent_)
    : bmc_loop( z3_ctx_, aim, g_model, ld_),
      parent(parent_), uf_name(z3_ctx_),
      uf_expr(z3_ctx_) {}

  virtual ~bmc_ds_aggr() = default;

  bmc_ds_aggr* parent;

  // pointer to sub loops
  std::vector<bmc_ds_aggr*> sub_loops;
  
  //Scalars: Locals, global
  std::vector<aggr_name> aggr_scalars;
  //Arrays: Locals, global
  std::vector<aggr_name> aggr_arrays;
  // Reads from previous or outer loops
  std::vector<z3::expr> aggr_reads;

  // Aggr expr
  z3::func_decl uf_name;
  z3::expr uf_expr;
  bool isPeelLast();
  bool isPeelFirst();
  bool hasSubLoops();

  void getInitArrays ( z3::expr_vector& );
  void getEntryArrays( z3::expr_vector& );
  void getExitArrays ( z3::expr_vector& );
  void getFinalArrays( z3::expr_vector& );

  void getInitVars ( z3::expr_vector& );
  void getEntryVars( z3::expr_vector& );
  void getExitVars ( z3::expr_vector& );
  void getFinalVars( z3::expr_vector& );

  z3::expr getLoopCounter();
  z3::expr getLastCounterExpr();
  z3::expr getFirstCounterExpr();
  int getStepCnt();
  int getTileSize();
  int getNumUpdInd();
  bool isWriteOverLapping();
  bool isReadOverLappingWrite();
  bool isNextIterReadOverlappingWrite();

  std::map<llvm::Value*, std::list<llvm::Value*>>& getReadMap();
  std::map<llvm::Value*, std::list<llvm::Value*>>& getWriteMap();
  std::map<llvm::Value*, std::list<z3::expr>>& getReadExprMap();
  std::map<llvm::Value*, std::list<z3::expr>>& getWriteExprMap();
  z3::expr getReadTile(llvm::Value*);
  z3::expr getWriteTile(llvm::Value*);
  exprs getInterferingReadExprList();
  void change_nonaggr_arr_name(exprs&, exprs&);

  void dump();
  void print( std::ostream& );
};

#endif // TILER_BMC_DS_H
