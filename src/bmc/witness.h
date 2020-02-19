#ifndef TILER_BMC_WITNESS_H
#define TILER_BMC_WITNESS_H

#include "utils/options.h"
#include "daikon-inst/comments.h" //todo: move to utils


class witness_val{
public:
  witness_val() {}
  witness_val( unsigned l, unsigned c, std::string f,
               std::string v, std::string s, unsigned ic,
               unsigned bc, unsigned p_num=0)
    : line(l) , col(c) , file(f), val(v), state(s), inst_count(ic),
      block_count(bc), pass_num(p_num) {}
  unsigned line=0;
  unsigned col=0;
  std::string file;
  std::string val;
  std::string state;
  unsigned inst_count=0;
  unsigned block_count=0;
  unsigned pass_num=0;
};

class witness{
public:
  witness( options& o_ )
    : o(o_) {}

  void generate_html();

  void add( src_loc& loc,
            std::string value, std::string state, unsigned bc,
            unsigned p_num=0);

  void add( unsigned l, unsigned c, std::string f,  std::string s,
            std::string v, unsigned bc, unsigned p_num=0);
  void update_files();
  void show_path();
  void show_path( std::vector<witness_val>& l_vals);
private:
  options& o;
  std::vector<witness_val> vals;
  std::set<std::string> files;
};

#endif // TILER_BMC_WITNESS_H
