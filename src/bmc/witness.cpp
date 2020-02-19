// file to prdocue witness from a run of failed bmc
#include "witness.h"
#include <fstream>
#include <boost/filesystem.hpp>

//HTML strings
const std::string pre_html =
"\
<!doctype html>\n\
<html>\n\
<head>\
<script src=\"http://code.jquery.com/jquery-1.9.1.min.js\"></script>\
<meta charset=utf-8 />\
<title> Error witness </title>\
</head>\
\n";

const std::string post_html = "</html>";

const std::string css= "\
<style type=\"text/css\"> <!--\n               \
    div#coded {\n                              \
       width:750px;                            \
       left:0px;                                \
       top: 0px;                                \
       background-color: #98FB98;               \
     } \n                                       \
    .line {\n                                   \
       width:200px;                            \
       word-wrap: normal                       \
     } \n                                       \
    .line:hover {\n                             \
        background-color: #dddddd;\n            \
     } \n                                       \
    .line:focus {\n                             \
        background-color: #bbbbbb;\n            \
     } \n                                       \
     table, th, td {                                     \
        border: 1px solid black;                         \
        background-color: #F5F5DC;\n            \
     }                                               \
     table {                                         \
       postion: fixed;                               \
       float: right;                                 \
       right: 10;                               \
       top: 10;                                 \
     }                                          \
    .hoverinfo {\n                              \
       cur_sor: pointer; \n                     \
       background-color: #FF0000;\n             \
       display: inline;\n                       \
     } \n                                       \
    .hoverinfo p {\n                            \
       display: none;\n                         \
       color: #000000;\n                        \
     } \n                                       \
    .hoverinfo:hover p {  \n                    \
        font-size: 28px;  \n                    \
        display: inline;  \n                            \
        background-color: rgba(255, 255, 255, 0.7);\n   \
        display: block; } \n                            \
   -->\n\
</style>\n";

const std::string pre_js=
"\
<script>\n                                                              \
function loaded() {                                                     \
window.idx = 0;                                                         \
";

const std::string post_js=
"\
 ns=document.getElementById(locs[0]);                                   \
 window.ocolor = ns.style.backgroundColor;                              \
 ns.style.background='red';                                             \
tbl = document.getElementById(\"tableState\");                          \
var row = tbl.insertRow(0);                                             \
var cell1 = row.insertCell(0);                                          \
cell1.innerHTML = \"Current state\";                                    \
fillState(states[0]);                                                   \
};\n                                                                    \
function fillState(s) {                                                 \
    tbl = document.getElementById(\"tableState\");                      \
    while( tbl.rows[1] ) tbl.deleteRow(1);                              \
    var arrayLength = s.length;                                         \
    for (var i = 0; i < arrayLength; i++) {                             \
      var row = tbl.insertRow(1);                                       \
      var cell1 = row.insertCell(0);                                    \
      cell1.innerHTML = s[i];                                           \
    }                                                                   \
};                                                                      \
document.onkeypress = function( e ) {\n                                 \
    if ( e.keyCode === 39 ) {\n                                         \
     if( idx < locs.length )                                            \
        document.getElementById(locs[idx]).style.background=ocolor;     \
      while( idx < locs.length-1 ) {                                    \
         idx++;                                                         \
         ns = null;                                                     \
         if( idx == locs.length ) break;                                \
         ns = document.getElementById(locs[idx]);                       \
         if( ns != null ) break;                                        \
      }                                                                 \
      if( ns != null ) {                                                \
         ocolor=ns.style.backgroundColor;                               \
         ns.style.background='red';                                     \
         ns.scrollIntoView();                                           \
         fillState( states[idx] );                                      \
      }                                                                 \
    }\n                                                                 \
    if ( e.keyCode === 37 ) {\n                                         \
     if( idx >= 0 )                                                     \
        document.getElementById(locs[idx]).style.background=ocolor;     \
      while( idx > 0 ) {                                                \
         idx--;                                                         \
         ns = null;                                                     \
         if( idx == 0 ) break;                                          \
         ns = document.getElementById(locs[idx]);                       \
         if( ns != null ) break;                                        \
      }                                                                 \
      if( ns != null ) {                                                \
         ocolor=ns.style.backgroundColor;                               \
         ns.style.background='red';                                     \
         ns.scrollIntoView();                                           \
         fillState( states[idx] );                                      \
      }                                                                 \
    }\n                                                                 \
};\n                                                                  \n\
</script>                                                               \
";

std::string js_insert( std::string& locs, std::string& states ) {
  return pre_js
    + "window.locs=[ " + locs+ " ];\n"
    + "window.states=[ " + states + " ];\n"
    + post_js;
}

std::string h1( std::string headline ) {
  return "<h1>" + headline + "</h1>\n";
}

std::string h2( std::string headline ) {
  return "<h2>" + headline + "</h2>";
}

const std::string pre_body = "<body onload=\"loaded()\">";
const std::string post_body = "</body>";
const std::string pre_code = "<div id=\"coded\"><pre><code style=\"font-size: 200%\">";
const std::string post_code = "</code></pre></div>";
const std::string pre_hover ="<div class=\"hoverinfo\">";
const std::string post_hover="</div>";
const std::string pre_p = "<p>";
const std::string post_p = "</p>";

// const std::string pre_line ="<div class=\"line\">";
const std::string post_line="</div>";

inline std::string pre_line( unsigned line ) {
  return "<div class=\"line\" id=\"l" + std::to_string(line) + "\">";
}

inline std::string create_span( std::string txt, std::string pop_up,
                                std::string id ) {
  std::string id_str = "id=\""+id+"\" ";
  std::string color;
  if( pop_up == "" ) {
    color = "style=\"background-color: #FF00FF\"";
    pop_up = "";
  } else {
    color = "style=\"background-color: #FFFF00\"";
    pop_up = " title=\"" + pop_up + "\"";
  }
  return "<span " + id_str + color + pop_up +">" + txt + "</span>";
}

inline std::string span( std::string id, std::string txt ) {
  std::string id_str = "id=\""+id+"\" ";
  return "<span " + id_str +">" + txt + "</span>";
}

inline std::string mk_table( std::string id, std::string txt ) {
  std::string id_str = "id=\""+id+"\" ";
  return "<table " + id_str +">" + txt + "</table>";
}

inline std::string mk_p( std::string txt ) {
  return "<p>" + txt + "</p>";
}

void witness::add( unsigned l, unsigned c, std::string f, std::string v,
                   std::string s, unsigned bc, unsigned p_num) {
  witness_val w(l, c, f, v, s, vals.size(), bc, p_num);
  vals.push_back( w );
}

void witness::update_files() {
  files.clear();
  for(auto& w : vals ) {
    if( w.file != "" )
      files.insert( w.file );
  }
  //todo: support multifile
  assert( files.size() < 2 );
}

void witness::add( src_loc& tpl,
                   std::string v, std::string s, unsigned bc, unsigned p_num) {
  add( tpl.line, tpl.col, tpl.file, v, s, bc, p_num );
}

void witness::generate_html() {
  update_files();
  // no file means empty trace
  assert( files.size() > 0 );
  std::string locs;
  std::string states;
  for( auto file : files ) {
    std::vector<witness_val> sorted_vals;
    bool first=true;
    for(auto& w : vals ) {
      if( w.file == file && w.line != 0 && w.col != 0 ) {
        std::string id = "l"+std::to_string(w.line) + "c"+std::to_string(w.col);
        locs = locs + (first?"":",") + "\""+ id + "\"";
        states = states + (first?"":",") + w.state ;
        if(first) first = false;
        sorted_vals.push_back( w );
      }
    }

    std::sort( sorted_vals.begin(), sorted_vals.end(),
               [&](const witness_val& x, const witness_val& y) {
                 return (x.line < y.line)
                   || (x.line == y.line && (x.col < y.col)); }  );

    boost::filesystem::path p(file);
    p.replace_extension(".html");
    std::string nf = o.outDirPath+"/"+p.filename().string();
    std::cout << "dumping fail witness at :" << nf << "\n";
    char ch;
    std::fstream fin(file, std::fstream::in);
    std::fstream fout( nf, std::fstream::out);
    unsigned val_idx=0;
    unsigned line = 1;
    unsigned col = 1;
    fout << pre_html << css << js_insert( locs, states ) << pre_body << "\n";
    fout << h1("Error trace found:");
    fout << mk_table( "tableState", "" );
    fout << pre_code << pre_line(line);
    std::string val = "";
    std::string state = "";
    while (fin >> std::noskipws >> ch) {
      std::string s(1,ch);
      if( s == "<") s = "&lt;";
      if( s == ">") s = "&gt;";
      if( s == "&") s = "&amp;";
      bool highlight = false;
      val = "";
      // unsigned inst_count;// = 0;
      while( val_idx < sorted_vals.size() &&
             sorted_vals[val_idx].line == line &&
             sorted_vals[val_idx].col == col) {
        if( sorted_vals[val_idx].val != "" ) {
          val = sorted_vals[val_idx].val;
        }
        // inst_count = sorted_vals[val_idx].inst_count;
        highlight = true;
        val_idx++;
      }
      if(highlight) {
        std::string loc = "l"+std::to_string(line) + "c" + std::to_string(col);
        s = create_span( s, val, loc );
        // s = pre_span + s + post_span;
        // std::string pop;
        // if( val != "" )
        //   pop = pre_p + val + post_p;
        // s = pre_hover + s + pop + post_hover;
        // s= "<span style=\"background-color: #FFFF00\">"+s+"</span>";
      }
      if( ch == '\n' ) {
        line++;
        if( col == 1 )
          fout << post_line << "\n" << pre_line(line);
        else
          fout << post_line <<  pre_line(line);
        col=1;
      }else{
        fout << s;
        col++;
      }
    }
    fout << post_code << post_body << post_html;
  }
}

void witness::show_path( std::vector<witness_val>& l_vals) {
  unsigned last_bc = 0;
  std::cout << "-------------------------------------------\n";
  std::cout << "Observed witness path\n";
  std::cout << "-------------------------------------------\n";
  for(auto& w : l_vals ) {
    if( last_bc != w.block_count ) {
      std::cout << "-------------------------------------------\n";
      last_bc = w.block_count;
    }
    std::cout << w.file << ":"<< w.line << ":"<< w.col
              << " <-- " << w.val << "\n";
  }
}

void witness::show_path() {
  show_path( vals );
}
