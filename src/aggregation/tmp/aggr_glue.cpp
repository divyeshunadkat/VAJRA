#include "aggregate.h"

void aggr_solver::mk_dependency_path( exprs fs, exprs prop, peel_ctx& p_ctx,
                                      exprs& loops, exprs& rest ) {
  // aggr* a = NULL;
  expr_set involved;
  get_variables( prop, involved);
  bool found = true;
  while( found ) {
    found = false;
    auto it = fs.end();
    while( it > fs.begin() ) {
      it--;
      z3::expr f = *it;
      expr_set f_involved;
      get_variables( f, f_involved);
      if( aggr* b =  find_aggr(f) ) {
        for( auto var : b->aggr_reads ) f_involved.insert( var );
      }
      if( are_intersecting( involved, f_involved ) ) {
        if(  find_aggr(f) ) {
          loops.push_back(f);
        }else if( f.is_eq() && f.arg(0).num_args() == 0 &&
              f.arg(1).num_args() == 0 ) {
          z3::expr a1 = f.arg(0), a2 = f.arg(1);
          p_ctx.add_context( a1, a2 );
        }else{
          rest.push_back( f );
        }
        it = fs.erase(it);
        found = true;
        set_insert( f_involved, involved );
      }
    }
  }
  std::reverse(loops.begin(), loops.end());
  std::reverse(rest.begin(), rest.end());

  // expr_set involved;
  // get_variables( prop, involved);
  // for( unsigned i=fs.size(); i != 0; i-- ) {
  //   z3::expr f = fs[i-1];
  //   expr_set f_involved;
  //   get_variables( prop, f_involved);
  //   if( are_intersecting(involved, f_involved) ) {
  //     path.push_back(f);
  //     set_union( f_involved, involved );
  //   }
  // }
  // std::reverse(path.begin(), path.end());
}

void aggr_solver::glue_gen( exprs path, exprs prop ) {
  // order along the flow from properties backward
  exprs loops, rest;
  peel_ctx pctx(z3_ctx);
  mk_dependency_path( path, prop, pctx, loops, rest );
  // dump( rest );
  for( z3::expr& loop : loops ) {
    aggr* l = find_aggr(loop);
    z3::expr_vector en(z3_ctx), ex(z3_ctx), in(z3_ctx), fn(z3_ctx);
    l->getInitVars ( in );
    l->getEntryVars( en );
    l->getExitVars ( ex );
    l->getFinalVars( fn );
    // for( auto updt : l->bmc_vec ) {
    //   for( ) {        
    //   }
    // }
    // if( ) {
      
    // }else if( ) {
      
    // }else if( ) {
      
    // }
    l->dump();
  }
  
  
}


