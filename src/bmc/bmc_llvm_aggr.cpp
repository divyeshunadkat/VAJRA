#include "bmc/bmc_llvm_aggr.h"

bmc_llvm_aggr::
bmc_llvm_aggr( options& o_, z3::context& z3_, bmc& b_,
               value_expr_map& def_map_,
               std::map<llvm::Function*,
                 std::map<const llvm::Value*, const llvm::Value*>>& map_,
               int& unsup)
    : o(o_)
    , z3_ctx(z3_)
    , bmc_obj(b_)
    , def_map(def_map_)
    , fn_v2v_map(map_)
    , unsupported(unsup)
{
  p = new bmc_pass(o_, z3_, b_);
}

bmc_llvm_aggr::
~bmc_llvm_aggr() {
  delete p;
}

// Get bmc_ds_ptr from the bmc object for the function
bmc_ds* bmc_llvm_aggr::
get_bmc_ds_ptr(const llvm::Function* curr_f) {
  return bmc_obj.get_func_formula_map().at(curr_f);
}

// Set bmc_ds_ptr in bmc_pass object in this class
void bmc_llvm_aggr::
set_bmc_ds_in_pass(const llvm::Function* curr_f) {
  p->bmc_ds_ptr = get_bmc_ds_ptr(curr_f);
}

// Function copies the prev value_expr_map to the next funciton and stores it ref
void bmc_llvm_aggr::
copy_value_expr_map(llvm::Function* prev_f) {
  if(prev_f) {
    get_bmc_ds_ptr(prev_f)->m.copy_values(p->bmc_ds_ptr->m);
  } else {
    def_map.copy_values(p->bmc_ds_ptr->m);
  }
}

// Function to realign the ary_to_int map in the bmc_ds_ptr of current function
// as per the alloca to alloca map and ary_to_int map of prev function
// Take updated ary_to_int from bmc_ds_ptr and copy it in bmc_pass (not really needed)
void bmc_llvm_aggr::
realign_ary_to_int(llvm::Function* prev_f, llvm::Function* curr_f) {
  if(prev_f) {
    std::map< const llvm::Instruction*, unsigned >& prev_ary_to_int =
      get_bmc_ds_ptr(prev_f)->ary_to_int;
    std::map< const llvm::Instruction*, unsigned >& curr_ary_to_int =
      p->bmc_ds_ptr->ary_to_int;
    std::map<const llvm::Value*, const llvm::Value*>& alloca_map =
      fn_v2v_map.at(curr_f);
    auto it = curr_ary_to_int.begin();
    for(; it != curr_ary_to_int.end(); it++) {
      if(alloca_map.count(it->first) > 0) {
        if(auto I = llvm::dyn_cast<const llvm::Instruction>(alloca_map.at(it->first))) {
          unsigned i = prev_ary_to_int.at(I);
          curr_ary_to_int[it->first] = i;
        } else {} // do nothing
      } else {} // Do not remap array not present in the previous function
    }
  } else {}
  p->ary_to_int = p->bmc_ds_ptr->ary_to_int;
}

// Store the expr corresponding to N in for each function
void bmc_llvm_aggr::
set_aggr_N(llvm::Function* curr_f) {
  if(curr_f->arg_size() == 1 ) {
    p->bmc_ds_ptr->aggr_N = p->bmc_ds_ptr->m.get_term( &(*curr_f->arg_begin()) );
    //    for( auto ab = curr_f->arg_begin(), ae = curr_f->arg_end(); ab != ae; ab++) {
    //    }
  } else if(bmc_obj.g_model.get_sorts().size() == 1) {
    int glb_id = 0;
    p->bmc_ds_ptr->aggr_N = p->bmc_ds_ptr->g_model.get_state_var(0,glb_id);
  } else {
    llvm::BasicBlock* entry_bb = &curr_f->getEntryBlock();
    for( auto it = entry_bb->begin(), e = entry_bb->end(); it != e; ++it) {
      llvm::Instruction *I = &(*it);
      if( auto alloc = llvm::dyn_cast<llvm::AllocaInst>(I) ) {
        if(alloc->isStaticAlloca()) continue;
        if( auto zext = llvm::dyn_cast<llvm::ZExtInst>(alloc->getArraySize()) ) {
          p->bmc_ds_ptr->aggr_N = p->bmc_ds_ptr->m.get_term(zext->getOperand(0));
          break;
        }
      }
    }
  }
  if(p->bmc_ds_ptr->aggr_N) return;
  else tiler_error("FPI::","Unable to find the program variable N for induction");
}

// Function to generate the bmc formula for the current function
void bmc_llvm_aggr::
do_bmc(llvm::Function* curr_f) {
  p->bmc_ds_ptr->init_array_model( o.ar_model );
  p->translateParams(*curr_f);
  p->do_bmc();
}

void bmc_llvm_aggr:: collect_base_case_exprs() {
  // Collect bmc formula of each function for the base case check
  std::vector<z3::expr>& bmc_ = p->bmc_ds_ptr->bmc_vec;
  bmc_vec.insert(bmc_vec.end(), bmc_.begin(), bmc_.end());
  // Collect quant elim vars of each function as well
  std::vector<z3::expr> q_ = p->bmc_ds_ptr->quant_elim_vars;
  quant_elim_vars.insert(quant_elim_vars.end(), q_.begin(), q_.end());
}

// Function to add the implication from path bit of first block of current
// func to the exit bits of the prev func
void bmc_llvm_aggr::
connect_path_exit_bits(llvm::Function* prev_f, llvm::Function* curr_f) {
  // Add constraint that path leading from each exit block of prev func
  // goes to the entry block of next current func
  if(!prev_f) return;
  bmc_ds* prev_bmc_ds_ptr = get_bmc_ds_ptr(prev_f);
  std::vector<z3::expr> exit_paths;
  for( auto bb : prev_bmc_ds_ptr->bb_vec) {
    if(!hasSuccessor(bb)) {
      auto exit_bb_id = prev_bmc_ds_ptr->find_block_idx(bb);
      exit_paths.push_back(prev_bmc_ds_ptr->block_to_path_bit.at(exit_bb_id));
    } else {}
  }
  auto entry_bb_id = p->bmc_ds_ptr->find_block_idx(&(curr_f->getEntryBlock()));
  z3::expr entry_path = p->bmc_ds_ptr->block_to_path_bit.at(entry_bb_id);
  z3::expr impl_cons = implies(entry_path, _or(exit_paths, z3_ctx));
  p->bmc_ds_ptr->bmc_vec.push_back(impl_cons);
  std::vector<z3::expr>& qel = p->bmc_ds_ptr->quant_elim_vars;
  qel.insert(qel.end(), exit_paths.begin(), exit_paths.end());
}

void bmc_llvm_aggr::substitute_N_base() {
  z3::expr N_val = z3_ctx.int_val( N_cntr++ );
  inplace_substitute(bmc_vec, p->bmc_ds_ptr->aggr_N, N_val);
}

void bmc_llvm_aggr::substitute_N_spec() {
  z3::expr N_val = z3_ctx.int_val( 1 );
  inplace_substitute(spec_vec, p->bmc_ds_ptr->aggr_N, N_val);
}

void bmc_llvm_aggr::
add_exit_constraint() {
  // Add constraint that exit bit of atleast one exit block is true
  std::vector<z3::expr> exit_paths;
  for( auto bb : p->bmc_ds_ptr->bb_vec) {
    if(!hasSuccessor(bb)) {
      auto exit_bb_id = p->bmc_ds_ptr->find_block_idx(bb);
      exit_paths.push_back(p->bmc_ds_ptr->block_to_path_bit.at(exit_bb_id));
    } else {}
  }
  z3::expr or_cons =  _or( exit_paths, z3_ctx);
  p->bmc_ds_ptr->bmc_vec.push_back(or_cons);
  bmc_vec.push_back(or_cons);
}

// Top level function
void bmc_llvm_aggr::generate_bmc() {
  std::string f_name = o.origFuncName+o.SSA_SUFFIX;
  llvm::Function *prev_f = NULL;
  llvm::Function *curr_f = bmc_obj.module.get()->getFunction(f_name);
  base_f=curr_f;
  while(curr_f) {
    set_bmc_ds_in_pass(curr_f);
    copy_value_expr_map(prev_f);
    realign_ary_to_int(prev_f, curr_f);
    do_bmc(curr_f);
    set_aggr_N(curr_f);
    add_exit_constraint();
    connect_path_exit_bits(prev_f, curr_f);
    collect_base_case_exprs();
    substitute_N_base();
    if(!prev_f) {
      set_spec_vec(p->bmc_ds_ptr->spec_vec);
      substitute_N_spec();
    }
    // Next function to be preocessed
    f_name = f_name + o.DIFF_SUFFIX;
    diff_f = prev_f = curr_f;
    curr_f = bmc_obj.module.get()->getFunction(f_name);
  }
}

// Set the spec vec passed to it for base case bmc
void bmc_llvm_aggr::set_spec_vec(std::vector<z3::expr>& spec_) {
  spec_vec.clear();
  spec_vec = spec_;
}

// Function to perform the base case check on the new spec passed to it
bool bmc_llvm_aggr::check_base_case() {
  bool res = false;
  for(z3::expr e : spec_vec) {
    res= res || bmc_obj.run_solver(e, bmc_vec);
  }
  return !res;
}

// Get the alloca for the given array variable
const llvm::Instruction* bmc_llvm_aggr::get_ary_alloca(z3::expr arr_var) {
  for( auto bb : p->bmc_ds_ptr->bb_vec) {
    auto bidx = p->bmc_ds_ptr->find_block_idx(bb);
    int index = p->bmc_ds_ptr->get_array_index(bidx, arr_var);
    if(index < 0)
      continue;
    else
      return p->bmc_ds_ptr->get_alloca_for_index(index);
  }
  return NULL;
}

// Get the alloca in the base program corresponding to the alloca in the diff
const llvm::AllocaInst* bmc_llvm_aggr::
get_mapped_alloca(const llvm::AllocaInst* arr_alloca) {
  std::map<const llvm::Value*, const llvm::Value*>& alloca_map = fn_v2v_map[diff_f];
  if(alloca_map.count(arr_alloca) > 0) {
    const llvm::Value* mapped_val = alloca_map.at(arr_alloca);
    auto mapped_alloca = llvm::dyn_cast<const llvm::AllocaInst>(mapped_val);
    return mapped_alloca;
  } else {
    return arr_alloca;
  }
}

// Generate base case spec from the given post
void bmc_llvm_aggr::get_base_spec(std::vector<z3::expr>& post,
                                  std::vector<z3::expr>& base_spec) {
  base_spec = post;
  //  z3::expr arr_var = get_array_var(_and(post));
  std::vector<z3::expr> arr_var_vec = get_array_var_vec(_and(post));
  for(z3::expr arr_var : arr_var_vec) {
    auto arr_alloc = get_ary_alloca(arr_var);
    if(!arr_alloc) tiler_error("FPI::","Alloca not found for array var");
    auto alloc = llvm::dyn_cast<const llvm::AllocaInst>(arr_alloc);
    bmc_ds* base_bmc_ds_ptr = get_bmc_ds_ptr(base_f);
    auto mapped_alloc = get_mapped_alloca(alloc);
    z3::expr base_arr_var(z3_ctx);
    for( auto bb : base_bmc_ds_ptr->bb_vec) {
      if(!hasSuccessor(bb)) {
        auto bidx = base_bmc_ds_ptr->find_block_idx(bb);
        base_arr_var = base_bmc_ds_ptr->get_array_state_var(bidx, mapped_alloc);
        break;
      }
    }
    if(base_arr_var) {}
    else tiler_error("FPI::","Z3 expr not found for alloc");
    inplace_substitute(base_spec, arr_var, base_arr_var);
  }
}

void bmc_llvm_aggr::
flatten_path( std::vector<z3::expr>& path, z3::expr N,
              std::vector<exprs>& flatten_paths) {
  flatten_paths.clear();
  exprs empty_path;
  std::set<int> skip_access_ids;
  flatten_paths.push_back(empty_path);
  for( auto& f : path ) {
    if( f.is_or() ) {
      unsigned num = f.num_args();
      unsigned f_size = flatten_paths.size();
      for( unsigned copy_count = 1; copy_count < num; copy_count++ ) {
        for( unsigned c_idx =0; c_idx < f_size; c_idx ++ ) {
            auto& orig = flatten_paths.at(c_idx);
            flatten_paths.push_back( orig );
        }
      }
      unsigned access_idx = 0;
      for( unsigned arg_idx = 0; arg_idx < num; arg_idx++ ) {
        z3::expr f_arg = f.arg(arg_idx);
        for( unsigned c_idx = 0; c_idx < f_size; c_idx ++ ) {
          auto& fpath = flatten_paths.at(access_idx);
          if( f_arg.is_and() ) {
            for( unsigned and_idx = 0; and_idx < f_arg.num_args(); and_idx++ ) {
              fpath.push_back( f_arg.arg(and_idx) );
            }
          }else{
            fpath.push_back(f_arg);
          }
          access_idx ++;
        }
      }
    }else{
      int i=0;
      for( auto& flat_path : flatten_paths ) {
        flat_path.push_back( f );
        i++;
      }
    }
  }

  auto it = flatten_paths.begin();
  while(it != flatten_paths.end()) {
    if(!check_sat(z3_ctx, _and(*it) && (N > 1))) {
      it = flatten_paths.erase(it);
    }else{
      it++;
    }
  }
}

bool bmc_llvm_aggr::has_rem_in_spec(exprs post) {
  exprs check_mod;
  extract_expr(post, check_mod);
  for(z3::expr e : check_mod) {
    if(has_rem(e))
      return true;
  }
  return false;
}

// Generate precondition from the formula
void bmc_llvm_aggr::compute_pre(std::vector<z3::expr>& hyp,
                                std::vector<z3::expr>& body,
                                std::vector<z3::expr>& post,
                                std::vector<z3::expr>& pre) {
  pre.clear();
  if(post.empty() || hyp.empty()) return;
  extract_expr(body, pre);
  extract_expr(hyp, pre);
  extract_expr(post, pre);
  propogate_array_equalities(pre);
}

// Remove top level conjunction
void bmc_llvm_aggr::extract_expr(std::vector<z3::expr> expr_list, std::vector<z3::expr>& l) {
  for(z3::expr e : expr_list) {
    if(isAnd(e)) {
      unsigned args = e.num_args();
      for (unsigned i = 0; i<args; i++) {
        l.push_back(e.arg(i).simplify());
      }
    } else {
      l.push_back(e.simplify());
    }
  }
}

void bmc_llvm_aggr::propogate_array_equalities(exprs& list) {
  propogate_array_eq(list, z3_ctx);
  propogate_store_eq(list, z3_ctx);
  simplify_select_store_nest(list, z3_ctx);
  propogate_select_eq(list, z3_ctx);
  simplify_select_eq(list, z3_ctx);
}

// Rename the array in pre to its version in post
void bmc_llvm_aggr::get_post(std::vector<z3::expr>& post) {
  //  z3::expr arr_var = get_array_var(_and(post));
  std::vector<z3::expr> arr_var_vec = get_array_var_vec(_and(post));
  for(z3::expr arr_var : arr_var_vec) {
    auto arr_alloc = get_ary_alloca(arr_var);
    if(!arr_alloc) tiler_error("FPI::","Alloca not found for array var");
    auto alloc = llvm::dyn_cast<const llvm::AllocaInst>(arr_alloc);
    z3::expr post_arr_var(z3_ctx);
    for( auto bb : p->bmc_ds_ptr->bb_vec) {
      if(!hasSuccessor(bb)) {
        auto bidx = p->bmc_ds_ptr->find_block_idx(bb);
        post_arr_var = p->bmc_ds_ptr->get_array_state_var(bidx, alloc);
        break;
      }
    }
    if(post_arr_var) {}
    else tiler_error("FPI::","Z3 expr not found for alloc");
    inplace_substitute(post, arr_var, post_arr_var);
  }
}

// Generate the hypothesis from N-1 program
void bmc_llvm_aggr::get_hyp(std::vector<z3::expr>& post,
                            std::vector<z3::expr>& hyp) {
  hyp = post;
  //  z3::expr arr_var = get_array_var(_and(post));
  std::vector<z3::expr> arr_var_vec = get_array_var_vec(_and(post));
  for(z3::expr arr_var : arr_var_vec) {
    auto arr_alloc = get_ary_alloca(arr_var);
    if(!arr_alloc) tiler_error("FPI::","Alloca not found for array var");
    auto alloc = llvm::dyn_cast<const llvm::AllocaInst>(arr_alloc);
    z3::expr hyp_arr_var = p->bmc_ds_ptr->get_array_state_var(0, alloc);
    if(hyp_arr_var) {}
    else tiler_error("FPI::","Z3 expr not found for alloc");
    inplace_substitute(hyp, arr_var, hyp_arr_var);
  }
  z3::expr N_minus_TS = p->bmc_ds_ptr->aggr_N - 1;
  inplace_substitute( hyp, p->bmc_ds_ptr->aggr_N, N_minus_TS);
}

// Top level function
bool bmc_llvm_aggr::verify() {
  if( p->bmc_ds_ptr->spec_vec.empty() ) return true;
  // Keep a copy of the bmc_vec
  orig_bmc_vec = bmc_vec;
  unsigned i = 0;
  for(auto it = p->bmc_ds_ptr->spec_vec.begin();
      it != p->bmc_ds_ptr->spec_vec.end(); it++) {
    std::vector<z3::expr> post;
    std::vector<z3::expr> base_post;
    z3::expr spec = *it;
    z3::expr assert_path_bit(z3_ctx);
    if(p->bmc_ds_ptr->assert_path_bits.size() > i) {
      assert_path_bit = p->bmc_ds_ptr->assert_path_bits.at(i++);
      post.push_back((spec && assert_path_bit).simplify());
      std::vector<z3::expr> qe_vars;
      qe_vars.push_back(assert_path_bit);
      eliminate_vars(z3_ctx, qe_vars, post);
    } else {
      assert_path_bit = z3_ctx.bool_val(true);
      post.push_back(spec);
    }
    // Base case
    get_base_spec(post, base_post);
    set_spec_vec(base_post);
    substitute_N_spec();
    // Reset bmc vec and add the assert path bit
    bmc_vec = orig_bmc_vec;
    bmc_vec.push_back(assert_path_bit); // path bit retained for all intermediate pres
    if(!isExists(spec_vec.front())) {
      eliminate_vars(z3_ctx, quant_elim_vars, bmc_vec);
    } else {}
    if(!check_base_case()) {
      if(o.verbosity > 0)
        std::cout << "\n\nBase case check failed\n";
      std::cout << "\n\nVAJRA_VERIFICATION_FAILED\n\n";
      return false;
    } else {
      if(unsupported > 0) {
        std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
        return false;
      }
    }
    // Inductive case
    std::vector<z3::expr> body = p->bmc_ds_ptr->bmc_vec;
    body.push_back(assert_path_bit);
    if(!isExists(spec_vec.front())) {
      eliminate_vars(z3_ctx, p->bmc_ds_ptr->quant_elim_vars, body);
    } else{}

    if(isExists(spec_vec.front())) {
      std::vector<z3::expr> hyp;
      get_hyp(post, hyp);
      std::vector<z3::expr> exists_qe_hyp;
      z3::expr inst_val = z3_ctx.int_val(0);
      exists_qe_hyp = inst_exists_quant(hyp, inst_val);
      std::vector<z3::expr> exists_qe_post0;
      exists_qe_post0 = inst_exists_quant(post, inst_val);
      std::vector<z3::expr> exists_qe_postNm1;
      z3::expr Nm1 = p->bmc_ds_ptr->aggr_N - z3_ctx.int_val(1);
      exists_qe_postNm1 = inst_exists_quant(post, Nm1);
      z3::expr formula = _and(exists_qe_hyp) && _and(body) &&
        !(_and(exists_qe_post0)) && !(_and(exists_qe_postNm1));
      if( !check_sat( z3_ctx, formula ) ) {
        return true;
      } else {
        return false;
      }
    } else {}

    std::vector<std::vector<z3::expr>> flat_paths;
    flatten_path(body, p->bmc_ds_ptr->aggr_N, flat_paths);
    for(unsigned i=0; i<flat_paths.size(); i++) {
      body = flat_paths[i];
      std::vector<z3::expr> postp = post;
      if(!verify_post(postp, body)) {
        return false;
      }
    }
  }
  return true;
}

bool bmc_llvm_aggr::verify_post(std::vector<z3::expr>& post,
                                std::vector<z3::expr>& body) {
  while(1) {
    std::vector<z3::expr> hyp;
    std::vector<z3::expr> pre;
    std::vector<z3::expr> base_post;
    get_hyp(post, hyp);
    if( !check_sat( z3_ctx, _and(hyp) && _and(body)
                    && !_and(post) ) ) {
      return true;
    }
    // Modulo operation in the post condition is currently not handled
    if(has_rem_in_spec(post)) {
      std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
      return false;
    }
    compute_pre(hyp, body, post, pre);
    if(pre.empty()) {
      if( o.verbosity > 2 )
        std::cout << "\nEmpty Pre-condition Synthesized\n";
    } else {
      bool ref_arr = false;
      for(z3::expr e : pre) {
        if(is_false(e)) {
          if(o.verbosity > 0)
            std::cout << "\nInferred 'false' as a pre-condition\n";
          std::cout << "\n\nVAJRA_VERIFICATION_FAILED\n\n";
          return false;
        }
        if(ref_arr == false && has_select(e)) {
          ref_arr = true;
        }
      }
      if(ref_arr == false) {
        if(!check_sat(z3_ctx,  _and(pre))) {
          std::cout << "\n\nVAJRA_VERIFICATION_FAILED\n\n";
          return false;
        } else {
          std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
          return false;
        }
      }
      if( o.verbosity > 2 ) {
        std::cout << "\nSynthesized Pre-condition\n";
        dump(pre);
      }
      post = pre;
    }
    //    if(!check_sat( z3_ctx, neg_and(pre)))      return true;
    //    else      post = pre;
    z3::expr N_plus_TS = p->bmc_ds_ptr->aggr_N + 1;
    inplace_substitute( post, p->bmc_ds_ptr->aggr_N, N_plus_TS);
    // Check base case
    get_base_spec(post, base_post);
    set_spec_vec(base_post);
    substitute_N_spec();
    if(!check_base_case()) {
      if(o.verbosity > 0)
        std::cout << "\n\nBase case check failed\n";
      std::cout << "\n\nVAJRA_VERIFICATION_FAILED\n\n";
      return false;
    } else {
      if(unsupported > 0) {
        std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
        return false;
      }
    }
    get_post(post);
  }
  std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
  return false;
}

std::vector<z3::expr> bmc_llvm_aggr::
inst_exists_quant(std::vector<z3::expr>& prop, z3::expr inst_val) {
  std::vector<z3::expr> qe_prop;
  expr_set quant_set;

  for( z3::expr& h : prop ) {
    if( !isExists(h) ) {
      qe_prop.push_back(h);
      continue;
    }
    quant_set.clear();
    auto body = h.body();
    get_annon_variables( body, quant_set );
    for(auto annon : quant_set) {
      z3::expr_vector outs(h.ctx()), ins(h.ctx());
      outs.push_back( annon );
      ins.push_back( inst_val );
      z3::expr e = h.body().substitute( outs, ins );
      qe_prop.push_back(e.simplify());
    }
  }
  return qe_prop;
}
