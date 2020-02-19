#ifndef Z3UTILS_H
#define Z3UTILS_H

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#include <z3.h>
#include <z3++.h>
#pragma GCC diagnostic push

#include "utils.h"
#include <vector>
#include <unordered_set>

struct expr_hash {
  size_t operator () (const z3::expr& a) const {
    Z3_ast ap = a;
    size_t hash = std::hash<Z3_ast>()(ap);
    return hash;
  }
};

struct expr_equal :
  std::binary_function <z3::expr,z3::expr,bool> {
    bool operator() (const z3::expr& x, const z3::expr& y) const {
      return z3::eq( x, y );
    }
  };

typedef std::unordered_set<z3::expr,  expr_hash, expr_equal> expr_set;
typedef std::vector<z3::expr> exprs;

void expr_set_to_exprs( expr_set&, exprs&);

void inplace_substitute( z3::expr&, z3::expr& src_vs, z3::expr& dst_vs );

void inplace_substitute( z3::expr&, z3::expr_vector& src_vs,
                         z3::expr_vector& dst_vs );

void inplace_substitute( exprs& vec, z3::expr_vector& src_vs,
                         z3::expr_vector& dst_vs );

void inplace_substitute( exprs& vec, z3::expr& src_v, z3::expr& dst_v);

exprs substitute_in_forall_lhs(exprs list, z3::expr e1, z3::expr e2);
exprs substitute_in_forall_rhs(exprs list, z3::expr e1, z3::expr e2);

z3::expr substitute_in_forall_lhs(z3::expr list, z3::expr e1, z3::expr e2);
z3::expr substitute_in_forall_rhs(z3::expr list, z3::expr e1, z3::expr e2);

std::string to_string(z3::sort);
std::string to_string(z3::expr e);
std::string to_string( std::vector<z3::expr> es);
std::string display(z3::expr e);
std::string display_app(z3::expr e);
void print_expr_set( std::ostream& o, expr_set& es);
void print_exprs( std::ostream& o, exprs& es);
void print_expr_vec( std::ostream& o, z3::expr_vector& es);
void print_expr( std::ostream& o, z3::expr e);
void print_expr( std::ostream& o, z3::sort s);
void print_solver( std::ostream& o, z3::solver s);
void dump( z3::solver s);
void dump( z3::sort s);
void dump( z3::expr e );
void dump( expr_set e );
void dump( exprs e );
void dump( z3::expr_vector e );

// other is_.. can be found in z3++.h
bool reportErrNThrow(std::string s, bool th);
bool has_rem(z3::expr e);
bool has_rem_app(z3::expr e);
bool has_select(z3::expr e);
bool has_select_app(z3::expr e);
bool has_store(z3::expr e);
bool has_store_app(z3::expr e);
int count_select(z3::expr e);
int count_select_app(z3::expr e);
bool has_quantified_formula(exprs es);
bool isQuant(z3::expr e, std::string s="", bool th=false);
bool isForall(z3::expr e, std::string s="", bool th=false);
bool isExists(z3::expr e, std::string s="", bool th=false);
bool isSelect(z3::expr e, std::string s="", bool th=false);
bool isStore(z3::expr e, std::string s="", bool th=false);
bool isApp( z3::expr e, std::string s="", bool th=false);
bool isImplies(z3::expr e, std::string s="", bool th=false);
bool isAnd( z3::expr e, std::string s="", bool th=false);
bool isLE ( z3::expr e, std::string s="", bool th=false);
bool isLT ( z3::expr e, std::string s="", bool th=false);
bool isGE ( z3::expr e, std::string s="", bool th=false);
bool isGT ( z3::expr e, std::string s="", bool th=false);
bool isEQ ( z3::expr e, std::string s="", bool th=false);
bool isNot( z3::expr e, std::string s="", bool th=false);
bool isRel( z3::expr e, std::string s="", bool th=false);
bool isAdd( z3::expr e, std::string s="", bool th=false);
bool isSub( z3::expr e, std::string s="", bool th=false);
bool isUMinus( z3::expr e, std::string s="", bool th=false);
bool isMul( z3::expr e, std::string s="", bool th=false);
bool isRem( z3::expr e, std::string s="", bool th=false);
bool is_const( z3::expr& b );
bool is_false( z3::expr );
bool is_true( z3::expr );
z3::expr get_fresh_bool( z3::context&, std::string, bool);
z3::expr get_fresh_bool( z3::context&, std::string = "");
z3::expr get_fresh_int( z3::context&, std::string, bool);
z3::expr get_fresh_int( z3::context&, std::string = "");
z3::expr get_fresh_const( z3::context&, z3::sort , std::string = "");
z3::expr get_array_var(z3::expr);
std::vector<z3::expr> get_array_var_vec(z3::expr);

z3::expr _or( std::vector<z3::expr>&, z3::context& );
z3::expr _or( std::vector<z3::expr> &);
z3::expr _and( std::vector<z3::expr> &, z3::context& );
z3::expr _and( std::vector<z3::expr> &);
z3::expr _xor( z3::expr const &, z3::expr const &);
z3::expr neg_and( std::vector<z3::expr> &vec, z3::context& z3_ctx );
z3::expr neg_and( std::vector<z3::expr> &vec);
z3::expr _forall( z3::expr_vector&, z3::expr& );

bool matched_sort( const z3::expr& l, const z3::expr& r );
z3::expr switch_sort( z3::expr& b, z3::sort& s);
int get_numeral_int(const z3::expr& i);

bool is_true( z3::expr, z3::model );

void to_std_vec( z3::expr_vector& vec, std::vector<z3::expr>& o_vec );
void to_z3_vec( std::vector<z3::expr>& vec, z3::expr_vector& o_vec );
void to_z3_vec( expr_set& set, z3::expr_vector& o_vec );

void get_variables( z3::expr& expr, expr_set& vars );
void get_variables( exprs& expr, expr_set& vars );
void get_annon_variables( z3::expr& expr, expr_set& vars );

bool inline contains( z3::expr e, expr_set s2 ) {
  return s2.find( e ) != s2.end();
}

bool inline are_intersecting( expr_set s1, expr_set s2 ) {
  for( auto& e : s2 ) {
    if( contains( e, s1 ) ) return true;
  }
  return false;
}

// bool run_solver(z3::context z3_ctx, z3::expr e );
bool check_sat(z3::context& z3_ctx, z3::expr e);
bool check_sat_with_select_scrubber(z3::expr e);

z3::expr expr_to_linear_term( z3::expr term, exprs& vs, std::vector<int>& l );

z3::expr subtract_polyhedran( exprs& dims, z3::expr x, z3::expr y );
z3::expr subtract_polyhedran( expr_set& dims, z3::expr x, z3::expr y );

z3::expr get_forall_lhs( z3::expr h );
z3::expr get_forall_rhs( z3::expr h );

void propogate_array_eq(exprs& list, z3::context& z3_ctx);
void propogate_store_eq(exprs& list, z3::context& z3_ctx);
void propogate_select_eq(exprs& list, z3::context& z3_ctx);
void simplify_select_store_nest(exprs& list, z3::context& z3_ctx);
void simplify_select_eq(exprs& list, z3::context& z3_ctx);
void eliminate_vars(z3::context&, std::vector<z3::expr>, std::vector<z3::expr>&);
#endif  // Z3UTILS_H
