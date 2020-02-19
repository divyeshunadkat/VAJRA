#ifndef TILER_BMC_LLVM_AGGR_H
#define TILER_BMC_LLVM_AGGR_H

#include<bmc/bmc_pass.h>

class bmc_llvm_aggr {

public:
  options& o;
  z3::context& z3_ctx;
  bmc& bmc_obj;
  value_expr_map& def_map;
  std::map<llvm::Function*,
           std::map<const llvm::Value*, const llvm::Value*>>& fn_v2v_map;
  int& unsupported;

  llvm::Function* base_f = NULL;
  llvm::Function* diff_f = NULL;

  bmc_pass* p = NULL;
  int N_cntr=1;

  std::vector<z3::expr> orig_bmc_vec;  //bmc vec for the base cases
  std::vector<z3::expr> bmc_vec;  //bmc vec for the base case of each spec with its path bit
  std::vector<z3::expr> spec_vec; //specs from original post and the computed pre
  std::vector<z3::expr> quant_elim_vars; //from all functions

  bmc_llvm_aggr(options&, z3::context&, bmc&, value_expr_map&,
                std::map<llvm::Function*,
                  std::map<const llvm::Value*, const llvm::Value*>>&,
                int &);
  ~bmc_llvm_aggr();

  bmc_ds* get_bmc_ds_ptr(const llvm::Function*);
  void set_bmc_ds_in_pass(const llvm::Function*);
  void copy_value_expr_map(llvm::Function*);
  void realign_ary_to_int(llvm::Function*, llvm::Function*);
  void set_aggr_N(llvm::Function*);
  void do_bmc(llvm::Function*);
  void connect_path_exit_bits(llvm::Function*, llvm::Function*);
  void collect_base_case_exprs();
  void substitute_N_base();
  void substitute_N_spec();
  void add_exit_constraint();
  void generate_bmc();
  void set_spec_vec(std::vector<z3::expr>&);
  bool check_base_case();
  const llvm::Instruction* get_ary_alloca(z3::expr);
  const llvm::AllocaInst* get_mapped_alloca(const llvm::AllocaInst*);
  void get_base_spec(std::vector<z3::expr>&, std::vector<z3::expr>&);
  void flatten_path(std::vector<z3::expr>&, z3::expr, std::vector<exprs>& );
  void compute_pre(std::vector<z3::expr>&, std::vector<z3::expr>&,
                   std::vector<z3::expr>&, std::vector<z3::expr>&);
  void extract_expr(std::vector<z3::expr>, std::vector<z3::expr>&);
  void propogate_array_equalities(std::vector<z3::expr>&);
  void get_post(std::vector<z3::expr>&);
  void get_hyp(std::vector<z3::expr>&, std::vector<z3::expr>&);
  bool has_rem_in_spec(exprs);
  bool verify();
  bool verify_post(std::vector<z3::expr>&, std::vector<z3::expr>&);
  std::vector<z3::expr> inst_exists_quant(std::vector<z3::expr>&, z3::expr);
};

#endif // TILER_BMC_LLVM_AGGR_H
