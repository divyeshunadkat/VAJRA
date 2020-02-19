#include <iostream>
#include <boost/filesystem.hpp>

#include "utils/llvmUtils.h"
#include "loopdata.h"
#include "collect_loopdata.h"
#include "collect_fun_blocks.h"
#include "build_name_map.h"
#include "transform.h"
#include "insert_main.h"
#include "slicedpost_check.h"
#include "bmc/bmc.h"
#include "bmc/bmc_llvm_aggr.h"
#include "daikon-inst/cinput.h"
#include "daikon-inst/comments.h"
#include "aggregation/aggregate.h"
#include "aggregation/aggr_llvm_diff.h"
#include "aggregation/array_ssa.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Analysis/CFGPrinter.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#pragma GCC diagnostic pop


void module2bc( std::unique_ptr<llvm::Module>& module, options& o)
{
  //  std::string llbmcFname = outputDir+cf.stem().string()+"_llbmc"+cf.extension().string();
  boost::filesystem::path cf(o.fileName);
  std::string llbmcFname = o.outDirPath+cf.stem().string()+"_llbmc"+cf.extension().string();
  std::error_code EC;
  llvm::raw_fd_ostream OS(llbmcFname, EC, llvm::sys::fs::F_None);
  WriteBitcodeToFile(module.get(), OS);
  //  WriteBitcodeToFile(*module.get(), OS);      // LLVM 8
  OS.flush();
  llvm::outs() << "Wrote the bitcode to" << llbmcFname << "\n";
}

void init_target_registry()
{
  llvm::InitializeAllTargetInfos();
  llvm::InitializeAllTargets();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllAsmParsers();
  llvm::InitializeAllAsmPrinters();
}

void dump_object_file( std::unique_ptr<llvm::Module>& module, options& o)
{
  init_target_registry();

  std::string TargetTriple = llvm::sys::getDefaultTargetTriple();
  module->setTargetTriple(TargetTriple);
  std::string Error;
  auto Target = llvm::TargetRegistry::lookupTarget(TargetTriple, Error);
  if (!Target)
  {
    llvm::errs() << Error;
    return;
  }

  llvm::StringRef CPU = "generic";
  llvm::StringRef Features = "";
  llvm::TargetOptions opt;
  auto rmodel = llvm::Optional<llvm::Reloc::Model>();
  auto TargetMachine =
    Target->createTargetMachine(TargetTriple, CPU, Features, opt, rmodel);
  module->setDataLayout(TargetMachine->createDataLayout());

  auto Filename = o.outDirPath + "/" + o.fileName + ".o";
  llvm::errs() << "\nDumping into file: " << Filename << "\n";
  std::error_code EC;
  llvm::raw_fd_ostream dest(Filename, EC, llvm::sys::fs::F_None);
  if (EC)
  {
    llvm::errs() << "Could not open file: " << EC.message();
    return;
  }

  llvm::legacy::PassManager pass;
  auto FileType = llvm::TargetMachine::CGFT_ObjectFile;
  if (TargetMachine->addPassesToEmitFile(pass, dest, FileType))
    //  if (TargetMachine->addPassesToEmitFile(pass, dest, &dest, FileType))      // LLVM 8
  {
    llvm::errs() << "TargetMachine can't emit a file of this type";
    return;
  }

  pass.run(*module.get());
  dest.flush();
  llvm::outs() << "Wrote " << Filename << "\n";
}

void parse_cpp_file( std::unique_ptr<llvm::Module>& module,
                     options& o ) {
  std::vector< comment > collected_comments;
  parse_cpp_file( module, o, collected_comments );
}

void parse_cpp_file( std::unique_ptr<llvm::Module>& module,
                     options& o,
                     std::vector< comment >& collected_comments )
{
  llvm::SMDiagnostic err;
  llvm::PassRegistry& reg = *llvm::PassRegistry::getPassRegistry();
  llvm::initializeAnalysis(reg);

  module = c2ir( o.filePath, o.globalContext, collected_comments );

  // module =  c2ir( o.filePath, o.globalContext );
  if( module.get() != 0 )
    return;

  // the following is called if direct module translation fails,
  // which may happen due to bugs in clang
  boost::filesystem::path cf( o.filePath );
  boost::filesystem::path bcFile( o.outDirPath );
  cf.replace_extension(".bc");
  bcFile /= cf.filename();

  c2bc( o.filePath, bcFile.string() );

  module = llvm::parseIRFile( bcFile.string(), err, o.globalContext);
  if( module.get() == 0 )
  {
    llvm::errs() << "Failed to parse the input file!\n";
    exit(1);
  }
}


void prepare_module( options& o,
                     std::unique_ptr<llvm::Module>& module,
                     std::vector<comment>& comments,
                     std::map< const bb*,
                     std::pair< std::vector<std::string>,std::vector<std::string> > >& block_comment_map
                     ) {
  llvm::legacy::PassManager passMan;
  passMan.add( llvm::createPromoteMemoryToRegisterPass() );
  passMan.add( llvm::createLoopRotatePass() ); // some params
  passMan.add( llvm::createAlwaysInlinerLegacyPass() );
  if( o.unwind && o.llvm_unroll && o.mode == 3 ) {
    // Work around due to a bug in interface since LLVM 4.0 =======
    // setting unroll count via commmand line parsing
    std::string ustr = "-unroll-count=" + std::to_string(o.loop_unroll_count);
    setLLVMConfigViaCommandLineOptions( ustr );
    // ============================================================
    passMan.add( llvm::createLoopUnrollPass( 0, 100, o.loop_unroll_count ) );
  }
  passMan.run( *module.get() );

  estimate_comment_location( module, comments, block_comment_map );
}

void prepare_module( options& o,
                     std::unique_ptr<llvm::Module>& module ) {
  std::vector<comment> comments;
  // std::map<llvm::Value*, std::string> lMap;
  std::map< const bb*,
            std::pair< std::vector<std::string>,std::vector<std::string> > >
    block_comment_map;
  prepare_module( o, module, comments,
                  block_comment_map );
}

void daikonInstNTileGen( std::unique_ptr<llvm::Module>& module,
                         options& o, z3::context& z3_,
                         value_expr_map& def_map_,
                         std::map<llvm::Loop*, loopdata*>& ld_map,
                         name_map& lMap,
                         std::map<std::string, llvm::Value*>& evMap)
{
  glb_model g_model(z3_); // Dummy glb_model to pass to collect_loopdata
  prepare_module( o, module);
  std::map< const bb*, rev_name_map > revlMap1, revlMap2; // dummies
  { // createing a new scope to run the distructor of transform
    llvm::legacy::PassManager passMan;
    passMan.add( llvm::createPromoteMemoryToRegisterPass() );
    passMan.add( new insert_main(o) );
    passMan.add( new build_name_map(o, def_map_, lMap, evMap, revlMap1, revlMap2) );
    passMan.add( new collect_fun_blocks(z3_, o, ld_map) );
    passMan.add( new collect_loopdata(z3_, o, def_map_, ld_map, lMap, evMap,
                                      module, g_model) );
    passMan.add( new transform(module, o, z3_, def_map_, ld_map, lMap, evMap) );
    passMan.run( *module.get() );
  }
  dump_object_file(module, o);
}

void slicedPostCondition( std::unique_ptr<llvm::Module>& module,
                          options& o,
                          z3::context& z3_)
{
  llvm::legacy::PassManager passMan;
  passMan.add( llvm::createPromoteMemoryToRegisterPass() );
  passMan.add( new slicedpost_check(o) );
  passMan.run( *module.get() );
  module2bc(module, o);
  //dump_object_file(module, o);
}

void nonInterference( std::unique_ptr<llvm::Module>& module,
                      options& o,
                      z3::context& z3_)
{
  llvm::legacy::PassManager passMan;
  passMan.add( llvm::createPromoteMemoryToRegisterPass() );
  //passMan.add( new noninterf_check(o) );
  passMan.run( *module.get() );
  //module2bc(module, ho);
}

void printCfgDot( std::unique_ptr<llvm::Module>& module)
{
  llvm::legacy::PassManager passMan;
  passMan.add( llvm::createPromoteMemoryToRegisterPass() );
  passMan.add( llvm::createCFGPrinterLegacyPassPass() );
  passMan.run( *module.get() );
}

void run_bmc( std::unique_ptr<llvm::Module>& module,
              std::vector<comment>& comments,
              options& o, z3::context& z3_ctx,
              value_expr_map& def_map_,
              std::map<llvm::Loop*, loopdata*>& ld_map,
              name_map& lMap,
              std::map<std::string, llvm::Value*>& evMap)
{
  std::map<const bb*,
           std::pair<std::vector<std::string>,std::vector<std::string> > >
    bb_cmt_map;
  prepare_module( o, module, comments, bb_cmt_map);
  bmc b(module, bb_cmt_map, o, z3_ctx, def_map_, ld_map, lMap, evMap);
  b.init_glb();
  b.run_bmc_pass();
}

void run_loop_peeling( std::unique_ptr<llvm::Module>& module,
                      std::vector<comment>& comments,
                      options& o, z3::context& z3_ctx,
                      value_expr_map& def_map_,
                      std::map<llvm::Loop*, loopdata*>& ld_map,
                      name_map& lMap,
                      std::map<std::string, llvm::Value*>& evMap)
{
  std::map<const bb*,
           std::pair<std::vector<std::string>,std::vector<std::string> > >
    bb_cmt_map;
  prepare_module( o, module, comments, bb_cmt_map);
  bmc b(module, bb_cmt_map, o, z3_ctx, def_map_, ld_map, lMap, evMap);
  b.init_glb();
  b.collect_aggr_pass();

  aggr_solver a_sol( o, z3_ctx, b.get_loop_aggr_map(), b.aggr_N );
  if(a_sol.verify()) {
    std::cout << "\n\nVAJRA_VERIFICATION_SUCCESSFUL\n\n";
  } else {
    std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
  }
}

void run_FPI( std::unique_ptr<llvm::Module>& module,
              std::vector<comment>& comments,
              options& o, z3::context& z3_ctx,
              value_expr_map& def_map_,
              std::map<llvm::Loop*, loopdata*>& ld_map,
              name_map& lMap,
              std::map<std::string, llvm::Value*>& evMap,
              std::map<llvm::Function*, std::map<const llvm::Value*,
              const llvm::Value*>>& fn_v2v_map
              )
{
  int unsupported_val = 0;
  std::map<const bb*,
           std::pair<std::vector<std::string>,std::vector<std::string> > >
    bb_cmt_map;
  prepare_module( o, module, comments, bb_cmt_map);
  std::map< const bb*, rev_name_map > revlMap1, revlMap2; // dummies

  // Create bmc object to hold the bmc_ds objects for all functions
  bmc b(module, bb_cmt_map, o, z3_ctx, def_map_, ld_map, lMap, evMap);
  b.init_glb();
  //  std::cout << "\n\nRUNNING PEELING IN LLVM IR\n\n";
  {
    llvm::legacy::PassManager passMan;
    // Cloned function becomes the new function under analysis
    passMan.add( new fun_clonner_mod_pass(o, o.SSA_SUFFIX, fn_v2v_map, bb_cmt_map));
    passMan.run( *module.get() );
  }
  {
    llvm::legacy::PassManager passMan;
    passMan.add( new build_name_map(o, def_map_, lMap, evMap, revlMap1, revlMap2) );
    passMan.add( new collect_fun_blocks(z3_ctx, o, ld_map) );
    passMan.add( new collect_loopdata(z3_ctx, o, def_map_, ld_map, lMap, evMap,
                                      module, b.g_model) );
    passMan.add( new array_ssa(z3_ctx, o, def_map_, ld_map, lMap, evMap, module,
                               b.g_model) );
    passMan.run( *module.get() );
  }

  {
    llvm::legacy::PassManager passMan;
    passMan.add( new fun_clonner_mod_pass(o, o.DIFF_SUFFIX, fn_v2v_map, bb_cmt_map));
    passMan.run( *module.get() );
  }
  ld_map.clear();
  lMap.clear();
  evMap.clear();
  {
    llvm::legacy::PassManager passMan;
    passMan.add( new build_name_map(o, def_map_, lMap, evMap, revlMap1, revlMap2) );
    passMan.add( new collect_fun_blocks(z3_ctx, o, ld_map) );
    passMan.add( new collect_loopdata(z3_ctx, o, def_map_, ld_map, lMap, evMap,
                                      module, b.g_model) );
    passMan.add( new aggr_llvm_diff(module, o, ld_map, fn_v2v_map, unsupported_val) );
    passMan.run( *module.get() );
  }

  b.collect_rev_name_map_pass();
  b.collect_bmc_ds_pass();
  //b.run_bmc_pass();
  //b.collect_aggr_pass();

  bmc_llvm_aggr* bla = new bmc_llvm_aggr(o, z3_ctx, b, def_map_, fn_v2v_map, unsupported_val);
  bla->generate_bmc();
  if(bla->verify()) {
    std::cout << "\n\nVAJRA_VERIFICATION_SUCCESSFUL\n\n";
  }
  delete bla;
}

