#ifndef TILER_GLB_MODEL_H
#define TILER_GLB_MODEL_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"

class glb_state {
public:
  glb_state() {}
  std::vector<z3::expr>& get_glb_name_vec() { return glb_names; };

private:
  std::vector<z3::expr> glb_names;
};

class glb_model{
public:
  glb_model( z3::context& ctx_ ) : z3_ctx(ctx_) {}
  glb_model( z3::context& ctx_, glb_model& g_m_ ) : z3_ctx(ctx_)
    , glb_sorts( g_m_.get_sorts() )
    , glb_to_id( g_m_.get_glb_to_id() )
  {}

  void update_name(unsigned, std::vector<const llvm::GlobalVariable*>&);
  z3::expr join_glb_state( std::vector<z3::expr>&,
                           std::vector<unsigned>&, unsigned
                          // std::vector<const bb*>&, const bb*
                           );
  void init_state( unsigned );
  void set_state( unsigned, glb_state& );
  //void init_state( const bb* );
  //void set_state( const bb*, glb_state& );

  z3::expr get_fresh_glb_name( unsigned, std::string );
  z3::expr get_fresh_glb_name( unsigned );

  void insert_glb_sort( z3::sort );
  void insert_glb_to_id( const llvm::GlobalVariable*, unsigned );
  void insert_name_to_glb( std::string, const llvm::GlobalVariable* );

  std::pair<z3::expr,z3::expr> glb_write( unsigned bidx,
                                          const llvm::StoreInst* ,
                                          z3::expr& );
  z3::expr glb_read( unsigned bidx, const llvm::LoadInst* );

  glb_state& get_state( unsigned b ) { return exit_glb_map.at(b); }

  // glb_state& get_glb_state( const bb* b ) { return exit_glb_map.at(b); }

  inline void set_glb_to_id( std::map< const llvm::GlobalVariable*, unsigned >& g_id_map) {
    glb_to_id = g_id_map;
  }

  inline void set_name_to_glb( std::map< std::string, const llvm::GlobalVariable* >& name_glb_map) {
    name_to_glb = name_glb_map;
  }

  void refresh_glb_state( unsigned bidx,
                          const llvm::GlobalVariable* g) {
    unsigned i = glb_to_id[g];
    auto& vec =  exit_glb_map[bidx].get_glb_name_vec();
    vec[i] = get_fresh_glb_name(i);
    return;
  }

  inline z3::expr
  get_state_var( unsigned bidx,
                 const llvm::GlobalVariable* g) {
    unsigned i = glb_to_id[g];
    return exit_glb_map[bidx].get_glb_name_vec().at(i);
  }

  inline z3::expr
  get_state_var( unsigned bidx, unsigned i) {
    return exit_glb_map[bidx].get_glb_name_vec().at(i);
  }
  std::map< const llvm::GlobalVariable*, unsigned >& get_glb_to_id() {
    return glb_to_id;
  }

  std::vector< z3::sort >& get_sorts() {
    return glb_sorts;
  }

private:
  z3::context& z3_ctx;
  // std::map< const bb*, glb_state > exit_glb_map;
  std::map< unsigned, glb_state > exit_glb_map;
  std::vector< z3::sort > glb_sorts;
  std::map< const llvm::GlobalVariable*, unsigned > glb_to_id;
  std::map< std::string, const llvm::GlobalVariable*> name_to_glb;
};

#endif // TILER_GLB_MODEL_H
