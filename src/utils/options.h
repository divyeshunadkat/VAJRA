#ifndef OPTIONS_H
#define OPTIONS_H

#include<iostream>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/LLVMContext.h"
#pragma GCC diagnostic pop

#include "utils.h"
#include <boost/program_options.hpp>
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <string>


namespace po = boost::program_options;

enum array_model_t{
  NONE,
  FULL,        // full model using store and select
  FIXED_LEN,   // array has fixed number of 'symbolic' cells
  PARTITION    // vaphor like model
};

class options
{
public:
  //---------------------------------------
  //tiler options
  std::string fileName;
  std::string filePath;
  std::string funcName;
  std::string origFuncName;
  std::string outDirPath;
  int mode = 0;
  int loopNum = 0;
  int totalLoops = 0;
  bool loop_aggr = false;
  bool fpi = false;

  //----------------------------------------
  //module preprocess options
  bool dump_cfg = 0;

  //----------------------------------------
  //generic options
  int verbosity = 0;
  std::string vajra_version = "TACAS-2020";
  int loop_unroll_count = 1;
  bool unwind=false;
  bool llvm_unroll=false; // selects between llvm_unroll or native

  //----------------------------------------
  //bmc options
  bool includeOutOfBoundSpecs=false;
  bool includeOverUnderflowSpecs=false;
  array_model_t ar_model = FULL;
  //----------------------------------------

  //----------------------------------------
  //Constants
  std::string SSA_SUFFIX = "_ssa";
  std::string DIFF_SUFFIX = "_diff";
  //----------------------------------------

  llvm::LLVMContext globalContext;

  void parse_config(boost::filesystem::path);
  bool parse_cmdline(int, char**);

private:
  void get_description_cmd(po::options_description& , po::options_description& ,
                           po::options_description& , po::positional_options_description&);
  void interpret_options(po::variables_map&);
  void show_help(po::options_description&);
  void print_z3_license();
  void print_boost_license();
  void print_vajra_license();
};

#endif
