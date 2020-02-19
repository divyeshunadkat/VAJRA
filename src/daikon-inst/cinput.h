#ifndef TILER_CINPUT_H
#define TILER_CINPUT_H

#include "utils/options.h"
#include "utils/llvmUtils.h"
#include "daikon-inst/loopdata.h"
#include "daikon-inst/comments.h"
#include "z3++.h"

//todo: collected comments should be part of a class
//      to enable concurrent thread executions

void parse_cpp_file( std::unique_ptr<llvm::Module>& module,
                     options& o, std::vector< comment >& );

void parse_cpp_file( std::unique_ptr<llvm::Module>&, options& );

void daikonInstNTileGen( std::unique_ptr<llvm::Module>& module,
                         options& o, z3::context& z3_,
                         value_expr_map& m_,
                         std::map<llvm::Loop*, loopdata*>& ld_map,
                         name_map& lMap,
                         std::map<std::string, llvm::Value*>& evMap);

void printCfgDot( std::unique_ptr<llvm::Module>& module );

void run_bmc( std::unique_ptr<llvm::Module>& module,
              std::vector< comment >&,
              options& o, z3::context& z3_ctx,
              value_expr_map& m_,
              std::map<llvm::Loop*, loopdata*>& ld_map,
              name_map& lMap,
              std::map<std::string, llvm::Value*>& evMap);

void run_loop_peeling( std::unique_ptr<llvm::Module>& module,
                       std::vector<comment>& comments,
                       options& o, z3::context& z3_ctx,
                       value_expr_map& def_map_,
                       std::map<llvm::Loop*, loopdata*>& ld_map,
                       name_map& lMap,
                       std::map<std::string, llvm::Value*>& evMap);

void run_FPI( std::unique_ptr<llvm::Module>& module,
              std::vector<comment>& comments,
              options& o, z3::context& z3_ctx,
              value_expr_map& def_map_,
              std::map<llvm::Loop*, loopdata*>& ld_map,
              name_map& lMap,
              std::map<std::string, llvm::Value*>& evMap,
              std::map<llvm::Function*,
              std::map<const llvm::Value*, const llvm::Value*>>&);

void slicedPostCondition( std::unique_ptr<llvm::Module>& module,
                          options& o,
                          z3::context& z3_);

#endif // TILER_CINPUT_H
