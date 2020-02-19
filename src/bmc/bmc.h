#ifndef TILER_BMC_H
#define TILER_BMC_H

#include "utils/options.h"
#include "utils/z3Utils.h"
#include "utils/llvmUtils.h"
#include "z3++.h"
#include "bmc/bmc_ds.h"
#include "bmc/glb_model.h"
#include "daikon-inst/collect_loopdata.h"
#include "daikon-inst/collect_fun_blocks.h"
#include "daikon-inst/build_name_map.h"

#define OUTSIDE_ANY_LOOP_CODE_PTR NULL

class bmc {
public:
  options& o;
  z3::context& z3_ctx;
  value_expr_map& def_map;
  std::unique_ptr<llvm::Module>& module;
  std::map<const bb*,
           std::pair<std::vector<std::string>,std::vector<std::string> > >&
  bb_comment_map;

  std::map< const llvm::Function*, bmc_fun*> func_formula_map;
  // loop_formula_map[NULL] maps to data for the code that is not in any loop
  std::map< const llvm::Loop*, bmc_loop*> loop_formula_map;
  std::map< const llvm::Loop*, bmc_ds_aggr*> aggr_map;
  z3::expr aggr_N; // the parameter for aggregation (should be identified in collect loop data)

  std::map<llvm::Loop*, loopdata*>& ld_map;

  name_map& localNameMap;
  std::map< const bb*, rev_name_map > revStartLocalNameMap;//todo: likely useless
  std::map< const bb*, rev_name_map > revEndLocalNameMap;

  std::map<std::string, llvm::Value*>& exprValMap;

  bmc(std::unique_ptr<llvm::Module>& m_,
   std::map<const bb*,std::pair<std::vector<std::string>,std::vector<std::string> > >& bb_comment_map_,
      options& o_, z3::context& z3_,
      value_expr_map& def_map_,
      std::map<llvm::Loop*, loopdata*>& ldm,
      name_map& lMap,
      std::map<std::string, llvm::Value*>& evMap)
    : o(o_)
    , z3_ctx(z3_)
    , def_map(def_map_)
    , module(m_)
    , bb_comment_map( bb_comment_map_ )
    , aggr_N(z3_)
    , ld_map(ldm)
    , localNameMap(lMap)
    , exprValMap(evMap)
    , g_model(z3_)
  {}

  ~bmc() {
    for( auto& it: func_formula_map ) {
      delete it.second;
    }
    for( auto& it: loop_formula_map ) {
      delete it.second;
    }
    for( auto& it: aggr_map ) {
      delete it.second;
    }
    for( auto& it: ld_map ) {
      delete it.second;
    }
  }

  //-------------------------------------------
  // Global model
  std::vector<z3::expr> glb_bmc_vec;
  glb_model g_model;
  glb_state populate_glb_state();
  void init_glb();

  //-------------------------------------------
  // Checking Specs and Reporting results
  void check_all_spec(bmc_ds*);
  bool run_solver(z3::expr &, bmc_ds*);
  bool run_solver(z3::expr&, std::vector<z3::expr>&);

  void produce_witness_call( z3::model mdl, const llvm::CallInst* call );
  void produce_witness( z3::model, bmc_ds*, unsigned call_count=0 );
  std::string get_val_for_instruction( const llvm::Instruction* I,
                                       z3::model& mdl,
                                       std::map<std::string, std::string>&,
                                       bmc_ds*,  unsigned call_count );

  //-------------------------------------------
  void run_bmc_pass();
  void collect_aggr_pass();
  void collect_bmc_ds_pass();
  void collect_rev_name_map_pass();

  std::map< const llvm::Function*, bmc_fun*>& get_func_formula_map();
  std::map< const llvm::Loop*, bmc_loop*>& get_loop_formula_map();
  std::map< const llvm::Loop*, bmc_ds_aggr*>& get_loop_aggr_map();
  // ValueExprMap& get_value_expr_map();
};

#endif // TILER_BMC_H
