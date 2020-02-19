#include "aggregate.h"
//---------------------------------------------
// utility functions


//assumption: due to the nature of bmc formula generation,
//            ors are present only at the top level
void aggr_solver::
flatten_path( exprs& path, exprs& path_conds,
              std::vector<exprs>& flatten_paths) {
  //to_dnf
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
      bool skip = false;
      unsigned access_idx = 0;
      for( unsigned arg_idx = 0; arg_idx < num; arg_idx++ ) {
        skip = false;
        z3::expr f_arg = f.arg(arg_idx);
        if( o.verbosity > 1 )
          std::cout << "\nSAT check in Flattening\n";
        if(!check_sat(z3_ctx, f_arg && (N > 0))) {
          skip_access_ids.insert(access_idx);
          skip = true;
        }
        for( unsigned c_idx = 0; c_idx < f_size; c_idx ++ ) {
          auto& fpath = flatten_paths.at(access_idx);
          if( f_arg.is_and() ) {
            for( unsigned and_idx = 0; and_idx < f_arg.num_args(); and_idx++ ) {
              fpath.push_back( f_arg.arg(and_idx) );
            }
          }else{
            fpath.push_back(f_arg);
          }
          if(skip) fpath.push_back(N>0);
          access_idx ++;
        }
      }
    }else{
      int i=0;
      for( auto& flat_path : flatten_paths ) {
        if(skip_access_ids.count(i) == 0)
          flat_path.push_back( f );
        i++;
      }
    }
  }
}

void aggr_solver::
get_aggragates( exprs& path, std::vector<std::pair<aggr*,unsigned>>& aggrs ) {
  unsigned i = 0;
  for( z3::expr f : path ) {
    if( aggr* aggr = find_aggr( f ) ) {
      aggrs.push_back( std::make_pair(aggr, i) );
    }
    i++;
  }
}

aggr* aggr_solver::find_aggr( z3::expr f ) {
  z3::func_decl f_decl = f.decl();
  for( auto pair: aggrs) {
    aggr* aggr = pair.second;
    if( z3::eq(aggr->uf_name,f_decl)  ) return aggr;
  }
  return NULL;
}

//-----------------------------------

void aggr_solver::
peel( aggr* a, exprs& path_conds, std::vector< exprs >& peeled_body ) {
  exprs body;
  for( z3::expr b :a->bmc_vec) {
    body.push_back( b );
  }
  z3::expr a_counter = a->getLoopCounter();
  if( a->isPeelLast() ) {
    // replace
    z3::expr N_ = (a->getLastCounterExpr() + a->getTileSize()).simplify();
    z3::expr last = N_ - a->getTileSize();
    inplace_substitute( body, a_counter, last );
  }else if( a->isPeelFirst() ) {
    z3::expr N_ = (a->getFirstCounterExpr() + a->getTileSize()).simplify();
    z3::expr first = N_ - a->getTileSize();
    inplace_substitute( body, a_counter, first );
  }else{assert(false);}

  // Always flatten the paths
  flatten_path( body, path_conds, peeled_body );
  /*if( a->hasSubLoops() ) {
    flatten_path( body, path_conds, peeled_body );
  }else{
    peeled_body.push_back( body );
    }*/
}

aggr* aggr_solver::
find_aggr_to_peel( exprs& prop, exprs& path, exprs& trail ) {
  aggr* a = NULL;
  expr_set involved;
  get_variables( prop, involved);
  bool found = true;
  while( found ) {
    found = false;
    auto it=path.end();
    while (it>path.begin()) {
      it--;
      z3::expr f = *it;
      expr_set f_involved;
      get_variables( f, f_involved);
      if( are_intersecting( involved, f_involved ) ) {
        if( aggr* b =  find_aggr(f) ) {
          if( a == NULL ) {
            a = b;
            it = path.erase(it);
            found = true;
          }
        }else{
          trail.push_back( f );
          it = path.erase(it);
          found = true;
          set_insert( f_involved, involved );
        }
      }
    }
  }
  return a;
}

void aggr_solver::
adjust_prop_for_sub( aggr* a, exprs& sub_prop ) {
  z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );
  if(a->isPeelLast())
    if(fn.size() == ex.size() && !fn.empty())
      inplace_substitute( sub_prop, ex, fn );
  if(a->isPeelFirst())
    if(in.size() == en.size() && !in.empty())
      inplace_substitute( sub_prop, en, in );
}

void aggr_solver::
substitute_aggr_names( aggr* a, aggr* sub_a, exprs& prop ) {
  z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );
  z3::expr_vector sub_en(z3_ctx), sub_ex(z3_ctx), sub_in(z3_ctx), sub_fn(z3_ctx);
  sub_a->getInitVars( sub_in );
  sub_a->getEntryVars( sub_en );
  sub_a->getExitVars( sub_ex );
  sub_a->getFinalVars( sub_fn );

  //  if(en.size() == sub_en.size() && !en.empty())
  //    inplace_substitute( prop, en, sub_en );
  //  if(ex.size() == sub_ex.size() && !ex.empty())
  //    inplace_substitute( prop, ex, sub_ex );
  if(in.size() == sub_in.size() && !in.empty())
    inplace_substitute( prop, in, sub_in );
  if(fn.size() == sub_fn.size() && !fn.empty())
    inplace_substitute( prop, fn, sub_fn );
}

void aggr_solver::mk_hypothesis( aggr* a, peel_ctx cntr_ctx, exprs& prop, exprs& hyp) {
  hyp = prop;
  z3::expr_vector in(z3_ctx), en(z3_ctx), ex(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );
  if( a->isPeelLast() ) {
    if( a->getStepCnt() > 0 ) {
      z3::expr N_ = (a->getLastCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      inplace_substitute( hyp, N_, N_minus_TS);
    } else {
      z3::expr INIT = a->getLastCounterExpr();
      cntr_ctx.apply(INIT);
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      inplace_substitute( hyp, INIT, INIT_plus_TS );
    }
    // make hyp over init and entry_vars variables
    inplace_substitute( hyp, fn, en );
    inplace_substitute( prop, fn, ex );
  }else if( a->isPeelFirst() ) {
    if( a->getStepCnt() < 0 ) {
      z3::expr N_ = (a->getFirstCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      inplace_substitute( hyp, N_, N_minus_TS);
    } else {
      z3::expr INIT = a->getFirstCounterExpr();
      cntr_ctx.apply(INIT);
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      inplace_substitute( hyp, INIT, INIT_plus_TS );
    }
    // hyp over exit and final variables
    inplace_substitute( hyp, in, ex );
    inplace_substitute( prop, in, en );
  }else{
    tiler_error( "aggregation::","only first and last peeling supported!" );
  }
}

bool aggr_solver::check_induct_case( aggr* a, peel_ctx cntr_ctx, exprs hyp, exprs path, exprs prop) {

  if( o.verbosity > 1 )
    std::cout << "\nChecking Inductiveness\n";

  z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );

  if( a->isPeelLast() ) {
    inplace_substitute( hyp, en, ex );
    inplace_substitute( hyp, in, en );
    inplace_substitute( prop, in, en );
  }else if( a->isPeelFirst() ) {
    inplace_substitute( hyp, ex, en );
    inplace_substitute( hyp, fn, ex );
    inplace_substitute( prop, fn, ex );
  }else{
    tiler_error( "aggregation::","only first and last peeling supported!" );
  }

  exprs hyp_aid;
  if( ex.size() == en.size() ) {
    z3::expr index(z3_ctx);
    if(a->isPeelFirst()) {
      index = a->getFirstCounterExpr();
      cntr_ctx.apply(index);
    } else {
      index = a->getLastCounterExpr();
      cntr_ctx.apply(index);
    }
    for(unsigned i=0; i<ex.size(); i++) {
      hyp_aid.push_back(select(ex[i], index) == select(en[i], index));
    }
  }
  z3::expr formula(z3_ctx);
  if(hyp_aid.empty()) {
    formula = _and(hyp) && _and(path) && !_and(prop);
  } else {
    formula = _and(hyp) && _and(hyp_aid) && _and(path) && !_and(prop);
  }
  if( check_sat( z3_ctx, formula ) ) {
    return true;
  } else {
    return false;
  }
}

void aggr_solver::check_base_case( aggr* a, peel_ctx cntr_ctx,  exprs base_hyp, exprs path) {

  if( o.verbosity > 1 )
    std::cout << "\nChecking Base Case\n";

  z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );

  if( a->isPeelLast() ) {
    if( a->getStepCnt() > 0 ) {
      z3::expr N_ = (a->getLastCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      inplace_substitute( base_hyp, N_minus_TS, N_ );
    } else {
      z3::expr INIT = a->getLastCounterExpr();
      cntr_ctx.apply(INIT);
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      inplace_substitute( base_hyp, INIT_plus_TS, INIT );
    }
    inplace_substitute( base_hyp, en, ex );
    inplace_substitute( base_hyp, in, en );
  }else if( a->isPeelFirst() ) {
    if( a->getStepCnt() < 0 ) {
      z3::expr N_ = (a->getFirstCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      inplace_substitute( base_hyp, N_minus_TS, N_ );
    } else {
      z3::expr INIT = a->getFirstCounterExpr();
      cntr_ctx.apply(INIT);
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      inplace_substitute( base_hyp, INIT_plus_TS, INIT );
    }
    inplace_substitute( base_hyp, ex, en );
    inplace_substitute( base_hyp, fn, ex );
  }else{
    tiler_error( "aggregation::","only first and last peeling supported!" );
  }

  z3::expr N_(z3_ctx);
  z3::expr N_base = z3_ctx.int_val(a->getStepCnt());
  if( a->getStepCnt() < 0 ) {
    N_ = (a->getFirstCounterExpr() + a->getStepCnt()).simplify();
    cntr_ctx.apply(N_);
    N_ = N_.simplify();
  } else {
    N_ = (a->getLastCounterExpr() + a->getStepCnt()).simplify();
    cntr_ctx.apply(N_);
    N_ = N_.simplify();
  }
  inplace_substitute(base_hyp, N_, N_base );
  inplace_substitute(path, N_, N_base );

  if( check_sat( z3_ctx, _and(path) && !_and(base_hyp) ) ) {
    tiler_error("aggregation::","Base case check failed");
  }
}

z3::expr aggr_solver::property_subtraction( z3::expr h, z3::expr p ) {
  if( isForall(h) && isForall(p) ) {
    z3::expr h_left = get_forall_lhs(h);
    z3::expr p_left = get_forall_lhs(p);
    z3::expr h_rhs = get_forall_rhs(h);
    z3::expr p_rhs = get_forall_rhs(p);
    if( z3::eq( h_rhs, p_rhs ) ) {
      expr_set p_quant_set;
      get_annon_variables( p_left, p_quant_set );
      z3::expr sub_left = subtract_polyhedran(p_quant_set, p_left, h_left);
      if( isAnd(sub_left) ) {
        for( unsigned i = 0; i < sub_left.num_args(); i++ ) {
          z3::expr face = sub_left.arg(i);
          if( face.is_eq() ) {
            z3::expr var(z3_ctx),exp(z3_ctx);
            if( face.arg(0).is_var() ) {
               var = face.arg(0);
               exp = face.arg(1);
            } if( face.arg(1).is_var() ) {
               var = face.arg(1);
               exp = face.arg(0);
            }
            if( var ) {
              p_quant_set.erase(var);
              inplace_substitute( p_rhs, var, exp);
              inplace_substitute( sub_left, var, exp);
            }
          }
        }
        sub_left = sub_left.simplify();
      }
      if( !p_quant_set.empty() ) {
        z3::expr_vector p_quants(z3_ctx);
        to_z3_vec(p_quant_set, p_quants);
        z3::expr body = implies( sub_left, p_rhs );
        return _forall( p_quants, body );
      }else{
        // return implies( sub_left, p_rhs );
        return p_rhs;
      }
    }
  }
  return p;
  // z3::expr empty(z3_ctx);
  // return empty;
}

void aggr_solver::
property_simplification( aggr* a, exprs hyp, exprs& trail, exprs& prop, exprs& pre_prop) {
  assert( hyp.size() == prop.size() );
  //  mk_hyp_for_diff(a, hyp, prop);
  bool diff_worked = true;
  z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );
  a->getFinalVars( fn );
  exprs diff;
  for(unsigned i = 0; i < hyp.size(); i++) {
    z3::expr h = hyp[i];
    z3::expr p = prop[i];
    // en->ex
    z3::expr p_simple(z3_ctx);
    //p_simple = property_subtraction( h, p);
    if( a->isPeelLast() ) {
      h = h.substitute( en, ex );
      h = h.substitute( in, en );
      p = p.substitute( in, en );
      p_simple = property_subtraction( h, p);
    }if( a->isPeelFirst() ) {
      h = h.substitute( ex, en );
      h = h.substitute( fn, ex );
      p = p.substitute( fn, ex );
      p_simple = property_subtraction( h, p);
    }
    if( p_simple ) {
      diff.push_back( p_simple);
    }else{
      diff_worked = false;
      break;
    }
  }
  if( diff_worked ) {
    // check if diff is sound
    exprs exit_hyp = hyp;
    inplace_substitute( exit_hyp, en, ex );
    exprs hyp_aid;
    if( ex.size() == fn.size() ) {
      z3::expr index(z3_ctx);
      if(a->isPeelFirst()) {
        index = a->getFirstCounterExpr();
      } else {
        index = a->getLastCounterExpr();
      }
      //todo: add equality for the full range of the tile.
      for(unsigned i=0; i<ex.size(); i++) {
        if( ex[i].is_array() )
          hyp_aid.push_back( select(fn[i], index) == select(ex[i], index) );
      }
    }
    z3::expr no_hyp_change = z3_ctx.bool_val(true);
    z3::expr no_diff_change = z3_ctx.bool_val(true);
    z3::expr hyp_cons = _and(exit_hyp) && no_hyp_change;
    z3::expr diff_cons =  _and(diff) && no_diff_change;
    z3::expr diff_check_expr = hyp_cons && diff_cons && !_and(prop);
    if(!hyp_aid.empty()) {
      z3::expr no_aid_change = z3_ctx.bool_val(true);
      z3::expr hyp_aid_cons = _and(hyp_aid) && no_aid_change;
      diff_check_expr = hyp_aid_cons && diff_check_expr;
    }

    if( o.verbosity > 1 )
      std::cout << "\nChecking if Diff worked\n";

  if( check_sat( z3_ctx, diff_check_expr ) ) {
      diff_worked = false;
      tiler_error("aggregation::", "Diff check failed");
    }
  }
  if(!diff_worked) {
    z3::expr e = implies( _and(trail), implies(_and( hyp ), _and( prop ) ) );
    diff.clear();
    diff.push_back( e );
  }
  prop = diff;
}

void aggr_solver::mk_hyp_for_diff(aggr* a, exprs& hyp, exprs prop) {
  hyp = prop;
  if( a->isPeelLast() ) {
    if( a->getStepCnt() > 0 ) {
      z3::expr N_ = (a->getLastCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      hyp = substitute_in_forall_lhs( hyp, N_, N_minus_TS);
    } else {
      z3::expr INIT = a->getLastCounterExpr();
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      hyp = substitute_in_forall_lhs( hyp, INIT, INIT_plus_TS );
    }
  }else if( a->isPeelFirst() ) {
    if( a->getStepCnt() < 0 ) {
      z3::expr N_ = (a->getFirstCounterExpr() + a->getTileSize()).simplify();
      z3::expr N_minus_TS = N_ - a->getTileSize();
      hyp = substitute_in_forall_lhs( hyp, N_, N_minus_TS);
    } else {
      z3::expr INIT = a->getFirstCounterExpr();
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      hyp = substitute_in_forall_lhs( hyp, INIT, INIT_plus_TS );
    }
  }else{
    tiler_error( "aggregation::","only first and last peeling supported!" );
  }
}

exprs aggr_solver::elim_quant_hyp(aggr* a, exprs& hyp) {
  std::list<z3::expr> read_indices;
  std::map<llvm::Value*,std::list<z3::expr>>::iterator bit = a->getReadExprMap().begin();
  std::map<llvm::Value*,std::list<z3::expr>>::iterator eit = a->getReadExprMap().end();

  for (; bit!=eit; bit++) {
    std::list<z3::expr>& el = bit->second;
    for(auto e : el) {
      read_indices.push_back(e);
    }
  }
  read_indices.sort(z3::eq);
  read_indices.unique(z3::eq);

  z3::expr cntr = a->getLoopCounter();
  z3::expr bound(z3_ctx);
  if( a->isPeelFirst() ) {
    bound = a->getFirstCounterExpr();
  } else {
    bound = a->getLastCounterExpr();
  }
  for( z3::expr& re : read_indices ) {
    inplace_substitute(re, cntr, bound);
  }

  exprs qe_hyp;
  expr_set hyp_quant_set;

  for( z3::expr& h : hyp ) {
    if( !isForall(h) ) {
      qe_hyp.push_back(h);
      continue;
    }
    hyp_quant_set.clear();
    auto body = h.body();
    get_annon_variables( body, hyp_quant_set );
    for(auto annon : hyp_quant_set) {
      for( z3::expr& sub_re : read_indices ) {
        z3::expr_vector outs(h.ctx()), ins(h.ctx());
        outs.push_back( annon );
        ins.push_back( sub_re );
        z3::expr e = h.body().substitute( outs, ins );
        if( isImplies(e) ) {
          qe_hyp.push_back(e.arg(1).simplify());
        } else {
          tiler_error("aggregation","Formula not an implication");
        }
      }
    }
  }
  return qe_hyp;
}

void aggr_solver::non_interference( aggr* a, peel_ctx cntr_ctx, exprs hyp, exprs body, exprs pre_prop ) {
  if(a->isWriteOverLapping()) return;
  if(a->isReadOverLappingWrite()) return;
  if(a->isPeelLast() && hyp.empty()) return;
  if(a->isPeelFirst() && pre_prop.empty()) return;

  if( o.verbosity > 1 )
    std::cout << "\nChecking Non-interference\n";

  z3::expr_vector in(z3_ctx), en(z3_ctx), ex(z3_ctx);
  a->getInitVars( in );
  a->getEntryVars( en );
  a->getExitVars( ex );

  if( a->isPeelLast() ) {
    if( a->getStepCnt() < 0 ) {
      z3::expr INIT = a->getLastCounterExpr();
      cntr_ctx.apply(INIT);
      z3::expr INIT_plus_TS = (INIT + a->getTileSize()).simplify();
      inplace_substitute( hyp, INIT_plus_TS, INIT );
      z3::expr INIT_plus_NUI = (INIT + a->getNumUpdInd()).simplify();
      inplace_substitute( hyp, INIT, INIT_plus_NUI );
    }
    exprs final_hyp = hyp;
    // make final_hyp over entry_vars and exit_vars
    inplace_substitute( final_hyp, en, ex );
    if( check_sat( z3_ctx, _and(hyp) && _and(body) && !_and(final_hyp) ) ) {
      tiler_error("aggregation::", "non_interference failed while peeling the last iteration");
    }
  }else if( a->isPeelFirst() ) {
    exprs final_pre_prop = pre_prop;
    // make pre_prop over exit and final variables
    inplace_substitute( final_pre_prop, in, ex );
    if( check_sat( z3_ctx, _and(pre_prop) && _and(body) && !_and(final_pre_prop) ) ) {
      tiler_error("aggregation::", "non_interference failed while peeling the first iteration");
    }
  }else{
    tiler_error( "aggregation::","non_interference : only first and last peeling supported!" );
  }
}

bool aggr_solver::
expand_context( peel_ctx& p_ctx, exprs& trail ) {
  bool any_change = false;
  for( z3::expr eq : trail  ) {
    if( eq.is_eq() ) {
      auto a1 = eq.arg(0);
      auto a2 = eq.arg(1);
      if( a1.num_args() == 0 && a2.num_args() == 0 ) {
        p_ctx.add_context( a1, a2);
        inplace_substitute( trail, a1, a2 );
        any_change = true;
      }// else if( a2.num_args() == 0 ) {
      //   p_ctx.add_context( a2, a1);
      //   inplace_substitute( trail, a2, a1 );
      //   any_change = true;
      // }
    }
  }
  if(!any_change) return false;
  auto it = trail.begin();
  while( it !=trail.end() ) {
    z3::expr eq = *it;
    if( eq.is_eq() && z3::eq( eq.arg(0), eq.arg(1) ) ) {
      it = trail.erase(it);
    }else{
      it++;
    }
  }
  return true;
}

// proof obligation:  pre_prop /\ a /\ trail => prop
// where pre_prop is unknown
bool aggr_solver::
verify_aggr( aggr* a, exprs path, exprs trail, peel_ctx& p_ctx, peel_ctx& cntr_ctx, exprs& prop, exprs pre_prop ) {
  // find aggr
  // hyp will be over init and final variables
  bool any_change = expand_context( p_ctx, trail );
  if(any_change) p_ctx.apply(prop);
  if( trail.size() > 0 ) {
    compute_swap_pre_over_trail( a, trail, prop );
  }

  exprs hyp;
  mk_hypothesis(a, cntr_ctx, prop, hyp);
  property_simplification( a, hyp, trail, prop, pre_prop );
  std::vector<exprs> flattened_peeled_body;
  exprs path_conds;
  peel( a, path_conds, flattened_peeled_body );
  std::vector<exprs> sub_pre_props;
  for( auto peeled_body : flattened_peeled_body ) {
    /*
    a->change_nonaggr_arr_name(peeled_body, hyp);
    peeled_body.insert(peeled_body.end(), trail.begin(), trail.end());
    exprs linked_path = path;
    bool res = is_body_N_independent(a, linked_path, peeled_body);
    append_linked_bodies(a, linked_path, peeled_body, hyp);
    cntr_ctx.apply(peeled_body);
    exprs peeled_body_base = peeled_body;
    peeled_body_base.insert(peeled_body_base.end(), linked_path.begin(), linked_path.end());
    check_base_case(a, cntr_ctx, prop, peeled_body_base);
    */
    check_base_case(a, cntr_ctx, hyp, peeled_body);
    non_interference(a, cntr_ctx, hyp, peeled_body, pre_prop);
    exprs sub_pre_prop;
    if( !verify_body( a, peeled_body, prop, hyp, p_ctx, cntr_ctx, sub_pre_prop ) )
      return false;
    if(!sub_pre_prop.empty())
      sub_pre_props.push_back( sub_pre_prop );
  }
  // exprs pre_prop;
  // code for joining and generalizing
  // sound approach: take conjunction and generalize
  //
  // pre_prop.clear();
  // write to prop
  if(!sub_pre_props.empty()) {
    assert(sub_pre_props.size() == 1);
    prop = sub_pre_props[0];
  }
  return true;
}

bool aggr_solver::is_body_N_independent(aggr* a, exprs linked_path, exprs peeled_body) {
  std::map<llvm::Value*, std::list<llvm::Value*>> readMap = a->getReadMap();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator bit;
  for(bit=readMap.begin(); bit!=readMap.end(); bit++) {
    if(bit->second.empty()) continue;
    for(llvm::Value *v : bit->second) {
      exprs linked_read;
      z3::expr e = a->m.get_term(v);
      linked_read.push_back(e);
      exprs linked_trail;
      aggr* linked_a = find_aggr_to_peel( linked_read, linked_path, linked_trail );
      if( linked_a ) {
        std::map<llvm::Value*, std::list<z3::expr>> writeMap = linked_a->getWriteExprMap();
        if(writeMap[bit->first].empty())
          continue;
        z3::expr writeTile = linked_a->getWriteTile(bit->first);
        z3::expr readTile = a->getReadTile(bit->first);

        z3::expr_vector wr_cntr_src(z3_ctx);
        z3::expr_vector wr_cntr_dst(z3_ctx);
        wr_cntr_src.push_back(linked_a->getLoopCounter());
        wr_cntr_dst.push_back(linked_a->getLastCounterExpr());
        z3::expr wrTile = writeTile.substitute(wr_cntr_src, wr_cntr_dst);

        z3::expr_vector rd_cntr_src(z3_ctx);
        z3::expr_vector rd_cntr_dst(z3_ctx);
        rd_cntr_src.push_back(a->getLoopCounter());
        rd_cntr_dst.push_back(a->getFirstCounterExpr());
        z3::expr rdTile = readTile.substitute(rd_cntr_src, rd_cntr_dst);

        z3::expr_vector ipsrc(z3_ctx);
        z3::expr_vector ipdst(z3_ctx);

        std::string lbName = "__lb";
        std::string ubName = "__ub";
        z3::expr lb = z3_ctx.int_const(lbName.c_str());
        z3::expr ub = z3_ctx.int_const(ubName.c_str());

        std::string lbpName = lbName+"_p";
        std::string ubpName = ubName+"_p";
        z3::expr lbp = z3_ctx.int_const(lbpName.c_str());
        z3::expr ubp = z3_ctx.int_const(ubpName.c_str());

        ipsrc.push_back(ub);
        ipsrc.push_back(lb);
        ipdst.push_back(ubp);
        ipdst.push_back(lbp);

        z3::expr sub_rdTile = rdTile.substitute(ipsrc, ipdst);

        z3::solver s(z3_ctx);
        s.add(wrTile);
        s.add(sub_rdTile);
        if (s.check() == z3::sat) {
          return false;             // reading from peeled write; body is not N independent
        } else {}
      } else {}
    }
  }
  return true;                     // body is N independent
}

void aggr_solver::append_linked_bodies(aggr* a, exprs& linked_path, exprs& peeled_body, exprs& hyp) {
  exprs reads = a->getInterferingReadExprList();
  while(!reads.empty()) {
    exprs linked_read;
    linked_read.push_back(reads.front());
    exprs linked_trail;
    aggr* linked_a = find_aggr_to_peel( linked_read, linked_path, linked_trail );
    if( linked_a ) {
      z3::expr_vector ex(z3_ctx), fn(z3_ctx);
      linked_a->getExitVars( ex );
      linked_a->getFinalVars( fn );

      peel_ctx p_ctx(z3_ctx);
      bool any_change = expand_context( p_ctx, linked_trail );
      if(any_change) {
        p_ctx.apply(peeled_body);
        p_ctx.apply(linked_read);
        p_ctx.apply(hyp);
      }
      if(ex.size() == fn.size() && !ex.empty()) {
        inplace_substitute( peeled_body, fn, ex );
        inplace_substitute( linked_read, fn, ex );
        inplace_substitute( hyp, fn, ex );
      }

      std::vector<exprs> flattened_linked_body;
      exprs p_conds;
      peel( linked_a, p_conds, flattened_linked_body );
      if(flattened_linked_body.size() != 1)
        tiler_error("aggregation::", "Multi path linkage not supported yet!");
      for( auto pb : flattened_linked_body ) {
        z3::expr_vector outs(z3_ctx);
        z3::expr_vector ins(z3_ctx);
        auto it = pb.begin();
        while( it != pb.end() ) {
          z3::expr e = *it;
          if(isEQ(e)) {
            if(e.arg(0).is_array() && isStore(e.arg(1)) && !isStore(e.arg(0)) ) {
              outs.push_back(linked_read.front());
              ins.push_back(e.arg(1).arg(2));
            } else if(e.arg(1).is_array() && isStore(e.arg(0)) && !isStore(e.arg(1)) ) {
              outs.push_back(linked_read.front());
              ins.push_back(e.arg(0).arg(2));
            } else {}
          }
          it++;
        }
        exprs old_pb = peeled_body;
        peeled_body.clear();
        for(z3::expr e : old_pb) {
          e = e.simplify();
          peeled_body.push_back(e.substitute(outs, ins));
        }
      }
      linked_a->change_nonaggr_arr_name(peeled_body, hyp);
      exprs linked_reads = linked_a->getInterferingReadExprList();
      reads.insert(reads.end(), linked_reads.begin(), linked_reads.end());
    } else {
      linked_path.insert(linked_path.end(), linked_trail.begin(), linked_trail.end());
    }
    reads.erase(reads.begin());
  }
}

void rm_exprs( z3::expr e, exprs& exs ) {
  auto it=exs.begin();
  while (it != exs.end()) {
    z3::expr ep = *it;
    if( z3::eq( ep, e ) )
      exs.erase(it);
    else
      it++;
  }
}

z3::expr is_store( z3::expr term, exprs& trail, exprs& consumed_trail) {
  z3::expr dummy(term.ctx());
  if( !term.is_array() )   return dummy;
  if(isStore( term ) ) {
    return term;
  }
  if( !term.is_app() || term.num_args() != 0 ) return dummy;
  auto it=trail.begin();
  while (it != trail.end()) {
    z3::expr e = *it;
    if( isEQ( e ) ) {
      if( z3::eq( e.arg(0), term )   ) {
        if( z3::expr str = is_store( e.arg(1), trail, consumed_trail ) ) {
          consumed_trail.push_back(e);
          rm_exprs( e, trail);
          return str;
        }
      }
      if( z3::eq( e.arg(1), term )   ) {
        if( z3::expr str = is_store( e.arg(0), trail, consumed_trail ) ) {
          consumed_trail.push_back(e);
          rm_exprs( e, trail);
          return str;
        }
      }
    }
    it++;
  }
  return dummy;
}

z3::expr is_select( z3::expr term, exprs& trail, exprs& consumed_trail ) {
  z3::expr dummy(term.ctx());
  if( isSelect( term ) ) {
    return term;
  }
  if( !term.is_app() || term.num_args() != 0 ) return dummy;
  auto it=trail.begin();
  while (it != trail.end()) {
    z3::expr e = *it;
    if( isEQ( e ) ) {
      if( z3::eq( e.arg(0), term )   ) {
        if( z3::expr str = is_select( e.arg(1), trail, consumed_trail ) ) {
          consumed_trail.push_back( e );
          rm_exprs( e, trail);
          return str;
        }
      }
      if( z3::eq( e.arg(1), term )   ) {
        if( z3::expr str = is_select( e.arg(0), trail, consumed_trail ) ) {
          consumed_trail.push_back(e);
          rm_exprs( e, trail);
          return str;
        }
      }
    }
    it++;
  }
  return dummy;
}

void aggr_solver::
detect_swap( z3::expr ar, exprs& o_trail, exprs& found, exprs& cnames ) {
  found.clear();
  // z3::expr dummy( ar.ctx() );
  exprs trail = o_trail;
  if( auto arp = is_store( ar, trail, cnames ) ) {
    auto mod_ar  = arp.arg(0);
    auto fst_idx = arp.arg(1);
    auto snd_val = arp.arg(2);
    if( auto mod_ar_p = is_store( mod_ar, trail, cnames ) ) {
      auto init_ar = mod_ar_p.arg(0);
      auto snd_idx = mod_ar_p.arg(1);
      auto fst_val = mod_ar_p.arg(2);
      if( auto snd_val_p = is_select( snd_val, trail, cnames ) ) {
        auto init_ar_1  = snd_val_p.arg(0);
        auto snd_idx_cp = snd_val_p.arg(1);
        if( auto fst_val_p = is_select( fst_val, trail, cnames ) ) {
          auto init_ar_2  = fst_val_p.arg(0);
          auto fst_idx_cp = fst_val_p.arg(1);
          //
          if( z3::eq( snd_idx_cp, snd_idx ) &&  z3::eq( fst_idx_cp, fst_idx ) &&
              z3::eq( init_ar, init_ar_1 ) &&  z3::eq( init_ar, init_ar_2 ) ) {
            o_trail = trail;
            found.push_back( init_ar );
            found.push_back( fst_idx );
            found.push_back( snd_idx );
            // eqvialence name found
            // cnames.push_back( cnames1 );
            // cnames.push_back( cnames2 );
            // cnames.push_back( cnames3 );
            // cnames.push_back( cnames4 );
          }
        }
      }
    }
  }
}

void seen_array_indexes( z3::expr f, expr_set& ts ) {
  switch(f.kind()) {
  case Z3_APP_AST: {
    if( isSelect( f ) ) {
      ts.insert( f.arg(1) );
    }else{
    // z3::func_decl d = f.decl();
    // Z3_decl_kind dk = d.decl_kind();
    // switch(dk) {
    // case Z3_OP_UNINTERPRETED : {
    //   vars.insert(expr);
    // } break;
    // default: {
    //   } break;
    // }
      unsigned args = f.num_args();
      for(unsigned i = 0; i<args; i++) {
        z3::expr arg = f.arg(i);
        seen_array_indexes(arg, ts);
      }
    }
  } break;
  case Z3_VAR_AST: break; // does not collect quantified variables
  case Z3_NUMERAL_AST: break;
  case Z3_QUANTIFIER_AST: {
    z3::expr body = f.body();
    seen_array_indexes( body, ts);
  } break;
  default: throw "unsupported"; break;
  }
}

z3::expr  inline equivalent_contains( z3::expr e, expr_set s2 ) {
  z3::expr dummy(e.ctx());
  for( z3::expr e1 : s2 ) {
    z3::expr eq_es = (e == e1);
    z3::expr simpl = eq_es.simplify();
    if( is_true(simpl) ) return e1;
  }
  return dummy;
}

void aggr_solver::
compute_swap_pre_over_trail( aggr* a, exprs& trail, exprs& prop ) {
  z3::expr_vector ex(z3_ctx);
  if(a->parent)
    a->parent->getExitArrays( ex );
  exprs new_prop = prop;
  for( unsigned i = 0; i < ex.size(); i ++ ) {
    z3::expr ar = ex[i];
  // for( auto ar : ex ) {
    exprs found;
    exprs c_path;
    detect_swap( ar, trail, found, c_path );
    // for( auto& cns : cnames ) { assert( cns.size() <= 1 ); }
    if( found.size() == 3 ) {
      z3::expr dst = found[0];
      z3::expr idx1 = found[1];
      z3::expr idx2 = found[2];
      for( auto& p : new_prop ) {
        inplace_substitute( p, ar, dst );
        expr_set idxs;
        seen_array_indexes( p, idxs );
        if( z3::expr occr =
            equivalent_contains( idx1, idxs) ) {
          p = substitute_in_forall_rhs( p, occr, idx2 );
          // inplace_substitute( p, occr, idx2 );
        }else if( z3::expr occr =
                  equivalent_contains( idx2, idxs) ) {
          p = substitute_in_forall_rhs( p, occr, idx2 );
          // inplace_substitute( p, occr, idx1 );
        }
      }
      if( check_sat( z3_ctx, _and(new_prop) && _and(c_path) && _and(trail)
                     && !_and(prop) ) ) {
        // // pre_prop.clear();
        // return true;
        tiler_error("aggregation::","pre computing over swap failed!");
      }
    }
  }
  prop = new_prop;
}


#define DISABLE_ADJUST_ true

bool aggr_solver::check_pre_path_prop( exprs path, exprs prop, exprs pre_prop ) {
  if(pre_prop.empty()) {
    if( o.verbosity > 5 )
      std::cout << "\nChecking if Path and Negation of Property is Unsat\n";
    if( !check_sat( z3_ctx, _and(path) && !_and(prop) ) ) {
      if( o.verbosity > 5 )
        std::cout << "\n Path and Negation of Property is UNSAT\n";
      // pre_prop.clear();
      return true;
    } else { // Continue verification process
      if( o.verbosity > 5 )
        std::cout << "\n Path and Negation of Property is SAT\n";
      return false;
    }
  } else {
    if( !check_sat( z3_ctx, _and(pre_prop) && _and(path) && !_and(prop) ) ) {
      if( o.verbosity > 5 )
        std::cout << "\n PRE and Path and Negation of Property is UNSAT\n";
      return true;
    } else { // Continue verification process
      if( o.verbosity > 5 )
        std::cout << "\n Path and Negation of Property is SAT\n";
      return false;
    }
  }
}

bool aggr_solver::verify_body( aggr* a, exprs path, exprs prop, exprs hyp, peel_ctx p_ctx,
                               peel_ctx cntr_ctx, exprs& pre_prop ) {
  bool check_ppp = check_pre_path_prop(path, prop, pre_prop);
  if(check_ppp) return true;
  // glue_gen( path, prop );
  while( !path.empty() && !prop.empty() ) {
    // Initially: rest = prefix /\ a /\ trail
    // Returns: rest = prefix
    exprs trail;
    aggr* sub_a = find_aggr_to_peel( prop, path, trail );
    if( sub_a ) {
      // exprs left_over_prop;
      exprs sub_prop = prop;
      if( DISABLE_ADJUST_ ) {
        adjust_prop_for_sub(a, sub_prop);
        substitute_aggr_names(a, sub_a, sub_prop);
      }
      z3::expr a_counter = a->getLoopCounter();
      if( a_counter ) {
        if( a->isPeelLast() ) {
          z3::expr last = a->getLastCounterExpr();
          cntr_ctx.add_context(a_counter, last);
        }else if( a->isPeelFirst() ) {
          z3::expr first = a->getFirstCounterExpr();
          cntr_ctx.add_context(a_counter, first);
        }else{assert(false);}
      }
      if( !verify_aggr( sub_a, path, trail, p_ctx, cntr_ctx, sub_prop, pre_prop ) ) return false;
      if(!path.empty()) prop = sub_prop;
    }else{
      // compute_pre_prop_qe(a, trail, prop, pre_prop); // Quantifier elimination of arrays did not work
      //      if(!check_sat( z3_ctx, _and(hyp) && _and(trail) && !_and(prop) )) {
      if(!trail.empty()) {
        if(!check_induct_case(a, cntr_ctx, hyp, trail, prop)) {
          return true;
        } else {
          if(pre_prop.empty()) {
            bool isPropQuantified = has_quantified_formula(prop);
            if(!isPropQuantified) {  // If property is not quantified then do this
              auto qe_hyp = elim_quant_hyp(a, hyp);
              compute_pre_prop(a, trail, qe_hyp, prop, pre_prop);
            }
          }
          if(!pre_prop.empty()) prop = pre_prop;
          // else tiler_error("aggregation::", "No pre computed");
        }
      } else {
        return true;
      }
    }
  }
  return true;
}

bool aggr_solver::verify() {
  aggr* top_aggr = aggrs.at(NULL);
  if( top_aggr->spec_vec.empty() ) {
    tiler_error("aggregation::", "No Assertion Specified!");
  }
  std::vector<exprs> flatten_paths;
  exprs path_conds;
  flatten_path( top_aggr->bmc_vec, path_conds, flatten_paths );
  exprs pre_prop;
  exprs hyp;
  peel_ctx p_ctx(z3_ctx);
  peel_ctx cntr_ctx(z3_ctx);
  for( auto& fpath: flatten_paths ) {
    if( !verify_body( top_aggr, fpath, top_aggr->spec_vec, hyp, p_ctx, cntr_ctx, pre_prop  ) ) return false;
  }
  return true;
}

void aggr_solver::compute_pre_prop(aggr* a, exprs trail, exprs qe_hyp, exprs prop, exprs& pre_prop) {
  if(prop.empty() || qe_hyp.empty()) return;
  extract_expr(trail, pre_prop);
  extract_expr(qe_hyp, pre_prop);
  extract_expr(prop, pre_prop);
  propogate_array_equalities(pre_prop);
  quantify_pre(a, pre_prop);
}

// Removes top level conjunction from trail, hypothesis, prop
void aggr_solver::extract_expr(exprs expr_list, exprs& l) {
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

void aggr_solver::propogate_array_equalities(exprs& list) {
  propogate_store_eq(list, z3_ctx);
  simplify_select_store_nest(list, z3_ctx);
  propogate_select_eq(list, z3_ctx);
  simplify_select_eq(list, z3_ctx);
}

void aggr_solver::quantify_pre(aggr* a, exprs& list) {
  exprs old_list = list;
  z3::expr cntr = a->getLoopCounter();
  z3::expr cntr_plus_1 = cntr + 1;
  z3::expr bound(z3_ctx);
  if( a->isPeelFirst() ) {
    bound = a->getFirstCounterExpr() - 1;
  } else {
    bound = a->getLastCounterExpr() + 1;
  }
  z3::expr bnd = bound.simplify();
  inplace_substitute(list, bnd, cntr_plus_1);
  inplace_substitute(list, cntr, cntr_plus_1);

  exprs new_list;
  bool replace = false;
  auto it = list.begin();
  while( it !=list.end() ) {
    replace = false;
    z3::expr e = *it;
    e = e.simplify();
    if(isEQ(e)) {
      if(isSelect(e.arg(0)) && !isSelect(e.arg(1))) {
        replace = true;
      } else if (isSelect(e.arg(1)) && !isSelect(e.arg(0))) {
        replace = true;
      } else {}
    } else {}
    if(replace) {
      z3::expr impl_expr(z3_ctx);
      if(a->getStepCnt() > 0) {
        impl_expr = a->getFirstCounterExpr() <= cntr && cntr <= a->getLastCounterExpr();
      } else {
        impl_expr = a->getFirstCounterExpr() >= cntr && cntr >= a->getLastCounterExpr();
      }
      z3::expr replace_eq = forall(cntr, implies(impl_expr, e));
      new_list.push_back(replace_eq);
    }
    list.erase(it);
  }
  list.insert(list.end(), new_list.begin(), new_list.end());
  if(list.empty()) {
    if( o.verbosity > 1 )
      std::cout << "\nChecking if Negation of Pre-condition is Unsat\n";
    if( check_sat( z3_ctx, neg_and(old_list) ) ) {
      tiler_error("aggregation::","Unable to quantify the precondition");
    } else {
      z3::expr top = z3_ctx.bool_val(true);
      list.push_back(top);
    }
  }
}

// void aggr_solver::applyAbduction(exprs& path, z3::expr post,
//          std::vector<std::pair<aggr*,unsigned>>& aggrs,
//   std::map<aggr*, z3::expr>& prop_map ) {
  
// }



// bool aggr_solver::aggr_prove( exprs& path, z3::expr post ) {
//   if( !check_sat( z3_ctx, _and(path) && !post ) ) {
//       return true; // proven safe
//   }
//   std::vector< std::pair<aggr*,unsigned> > aggrs_with_position;
//   getAggragates( path, aggrs_with_position );
//   if( aggrs.empty() ) {
//     return false; // failed to to prove safety
//   }
//   std::map<aggr*, z3::expr > to_be_proven_posts;
//   applyAbduction( path, post,  aggrs_with_position, to_be_proven_posts );

//   for( auto aggr_pair : aggrs_with_position ) {
//     aggr* a = aggr_pair.first;
//     auto a_post = to_be_proven_posts.at(a);
//     exprs peeled_body;
//     // hyp will be over init and final variables
//     z3::expr hyp = mkHypothesis(a, a_post);
//     if( a->isPeelLast() ) {
//       // make hyp over init and entry_vars variables
//       z3::expr_vector final_vars(z3_ctx), entry_vars(z3_ctx);
//       a->getFinalVars( final_vars );
//       a->getEntryVars( entry_vars );
//       hyp = hyp.substitute( final_vars, entry_vars );
//       peeled_body.push_back(hyp);
//       peel( a, peeled_body );
//     }else if( a->isPeelFirst() ) {
//       // hyp over exit and final variables
//       z3::expr_vector init_vars(z3_ctx), exit_vars(z3_ctx);
//       a->getFinalVars( init_vars );
//       a->getExitVars( exit_vars );
//       hyp = hyp.substitute( init_vars, exit_vars );
//       peel( a, peeled_body );
//       peeled_body.push_back( hyp );
//     }else{
//       tiler_error( "aggregation::","only first and last peeling supported!" );
//     }
//     if( !aggr_prove( peeled_body, a_post ) ) return false;
//   }
//   return true;
// }

// bool
// aggr_solver::verify() {
//   aggr* top_aggr = aggrs.at(NULL);
//   if( top_aggr->spec_vec.empty() ) return true;
//   z3::expr spec = _and( top_aggr->spec_vec, z3_ctx );
//   exprs path;
//   mk_dependency_path( top_aggr->bmc_vec, spec, path);
//   return aggr_prove( path, spec );
// }


//-----------------------------------------------------------------------------
// old plan


// For each loop, loopdata object will hold the following information:
// Read tile for the arrays being read
// Write tile for the arrays being updated
// Loop counter
// Upper and lower bounds of the range in which loop counter operates
// SMT formula corresponding to the inductive part of the loop body
// SMT formula corresponding to the base case in the loop body
//
// Flag indicating if the covers-range check has passed for tile of the arrays being updated
// Flag indicating if the loopdata object corresponds to the property loop
//

// Aggregation Class
// Ordered List of Loopdata objects
// Property Loopdata object
//
// Functionalities:
// genAggrFormula - generate the aggregation formula for the program using the loop data objects
// doInduction - checks for the presence of aggregators in the formula for applying induction
// normalize - converts the SMT formula into a peelable form by moving the term with aggregation on one side of the (in)equality and the terms without aggregation on the other
// peel - applies induction to the outer most aggregator in the formula
// solveByAggr - prove the property using the aggregation algorithm

//Arguments to peeling
//Assert smt formula
//Smt formula for each loop
//aggregation operators in smt formulas
//ranges of the aggregation operators
//data flow over arrays to identify the replacement aggregation formula for an array
//induction variable expression
