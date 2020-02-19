#ifndef TILER_AGGREGATE_H
#define TILER_AGGREGATE_H

#include "utils/z3Utils.h"
#include "bmc/bmc_ds.h"

class peel_ctx {
 public:
  peel_ctx( z3::context& ctx_ ) : z3_ctx(ctx_), outs(ctx_), ins(ctx_) {};

  z3::context& z3_ctx;
  z3::expr_vector outs;
  z3::expr_vector ins;

  inline void add_context( z3::expr out, z3::expr in) {
    outs.push_back( out );
    ins.push_back( in );
  }
  inline void apply( exprs& fs ) {
    for(unsigned i=0; i<outs.size(); i++) {
      z3::expr out = outs[i];
      z3::expr in = ins[i];
      inplace_substitute( fs, out, in );
    }
  }
  inline void apply( z3::expr& e ) {
    for(unsigned i=0; i<outs.size(); i++) {
      z3::expr out = outs[i];
      z3::expr in = ins[i];
      inplace_substitute( e, out, in );
    }
  }
  inline void clear() {
    while(!outs.empty()) {
      outs.pop_back();
    }
    while(!ins.empty()) {
      ins.pop_back();
    }
  }
};


// enum aggr_tag {tile, overlap, counter, aggregate, unknown};

typedef bmc_ds_aggr aggr;

class change{
public:
  aggr* loop;
  z3::expr var;
  z3::expr change_expr;
  z3::expr idx;
  z3::expr lower;
  z3::expr upper;
};

// class bmc_ds_aggr;

// class aggregate{
//   aggregate(z3::expr f_, z3::func_decl op_, z3::expr index_,
//             z3::expr start_, z3::expr end_ ) :
//     f(f_), op(op_), index(index_), start(start_), end(end_)
//   {}
// public:
//   z3::expr f;
//   z3::func_decl op;
//   z3::expr index;
//   z3::expr start;
//   z3::expr end;
// };

// aggregate guess_aggregate( z3::expr loop_body,
//                            std::map<z3::expr, enum aggr_tag> subexpr_tags ) {
// }

class aggr_solver{
public:
  aggr_solver( options& o_, z3::context& z3_,
               std::map< const llvm::Loop*, aggr*>& aggrs_, z3::expr N_ )
    : o(o_)
    , z3_ctx( z3_ )
    , aggrs( aggrs_)
    , N(N_) {
  }
private:
  options& o;
  z3::context& z3_ctx;
  std::map< const llvm::Loop*, aggr*> aggrs;
  z3::expr N;

  bool expand_context( peel_ctx& p_ctx, exprs& trail );

  aggr* find_aggr( z3::expr f );

  void get_aggragates( exprs& path,
                      std::vector<std::pair<aggr*,unsigned>>& aggrs );
  z3::expr property_subtraction( z3::expr h, z3::expr p );

  aggr* find_aggr_to_peel( exprs& prop,
                           exprs& path, exprs& trail );
  void flatten_path( exprs& path, exprs& path_conds,
                     std::vector<exprs>& flatten_paths);

  void adjust_prop_for_sub( aggr* a, exprs& sub_prop );
  void substitute_aggr_names( aggr* a, aggr* sub_a, exprs& prop );
  void mk_hypothesis( aggr*, peel_ctx, exprs&, exprs& );
  void mk_hyp_for_diff(aggr* a, exprs& hyp, exprs prop);
  void check_base_case( aggr*, peel_ctx, exprs, exprs );
  bool check_induct_case( aggr*, peel_ctx, exprs, exprs, exprs);
  // void applyAbduction(exprs& path, z3::expr post,
  //                     std::vector<std::pair<aggr*,unsigned>>& aggrs,
  //                     std::map<aggr*, z3::expr >& prop_map );
  void append_linked_bodies(aggr*, exprs&, exprs&, exprs& );
  void peel( aggr*, exprs&, std::vector< exprs >& );
  void property_simplification( aggr*, exprs hyp, exprs& trail, exprs& prop,
                                exprs& pre_prop );
  bool verify_aggr( aggr* a, exprs path, exprs trail, peel_ctx& p_ctx,
                    peel_ctx& cntr_ctx, exprs& prop, exprs pre_prop );
  bool verify_body( aggr* a, exprs path, exprs prop, exprs hyp, peel_ctx p_ctx,
                    peel_ctx cntr_ctx, exprs& pre_prop );
  bool check_pre_path_prop(exprs path, exprs prop, exprs pre_prop);
  void extract_expr(exprs expr_list, exprs& l);
  void propogate_array_equalities(exprs& list);
  void quantify_pre(aggr* a, exprs& list);
  void compute_pre_prop(aggr* a, exprs trail, exprs qe_hyp, exprs prop,
                        exprs& pre_prop);
  exprs elim_quant_hyp(aggr* a, exprs& hyp);
  void non_interference( aggr* a, peel_ctx cntr_ctx, exprs hyp, exprs body,
                         exprs pre_prop );

  bool is_body_N_independent(aggr* a, exprs linked_path, exprs peeled_body);

  void detect_swap( z3::expr ar, exprs& o_trail, exprs&, exprs& );
  void compute_swap_pre_over_trail( aggr* sup_a, exprs& trail, exprs& prop );

  void glue_gen( exprs path, exprs prop );
  void mk_dependency_path( exprs fs, exprs prop, peel_ctx& p_ctx,
                           exprs& loops, exprs& rest );

public:
  bool verify();
};


#endif // TILER_AGGREGATE_H
