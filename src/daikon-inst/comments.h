#ifndef TILER_COMMENTS_H
#define TILER_COMMENTS_H

#include <utils/llvmUtils.h>

#define COMMENT_PREFIX_LEN 3
#define COMMENT_PREFIX "//!"

// Enable test of the first token
// #define COMMENT_FIRST_TOKEN "(assert"

class src_loc {
public:
  src_loc( unsigned line_, unsigned col_, std::string file_ ) :
    line(line_), col(col_), file(file_) {};
  src_loc() : line(0), col(0), file("") {};
  unsigned line;
  unsigned col;
  std::string file;

  void dump();
  void print(std::ostream&);

  bool operator==(const src_loc &other) const {
    return other.line == line && other.col == col && other.file == file;
  }
};

class comment{
public:
  // comment( std::string text_, src_loc start_, src_loc end_ ) :
  //   text(text_), start(start_), end(end_) {};
  std::string text;
  src_loc start;
  src_loc end;
  const bb* b = NULL;
  z3::expr to_z3_expr( z3::context z3_ctx, rev_name_map& n_map );

  void dump();
  void print(std::ostream& );
};

class comments{
  std::map< const bb*, std::vector< comment > > start_comments;
  std::map< const bb*, std::vector< comment > > end_comments;
};


#endif
