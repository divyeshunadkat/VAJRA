#include "utils/options.h"
#include "daikon-inst/cinput.h"

int main(int argc, char** argv) {
  options o;
  boost::filesystem::path def_config("default.conf");
  if ( boost::filesystem::exists( def_config ) ) {
    o.parse_config(def_config);
  }

  if (!o.parse_cmdline(argc, argv)) return 0; // help was called

  std::unique_ptr<llvm::Module> module;
  std::vector< comment > comments;
  parse_cpp_file(module, o, comments );
  if( o.verbosity > 8 ) {
    module->print( llvm::outs(), nullptr );
  }

  z3::context z3_ctx;
  std::map<llvm::Loop*, loopdata*> ld_map;
  name_map local_name_map;
  std::map<std::string, llvm::Value*> expr_val_map;
  value_expr_map def_map(z3_ctx);
  std::map<llvm::Function*,
           std::map<const llvm::Value*,
                    const llvm::Value*>> func_v2v_map;

  run_FPI( module, comments, o, z3_ctx, def_map, ld_map, local_name_map,
           expr_val_map, func_v2v_map);
  if( o.dump_cfg ) {
    printCfgDot(module);
  }

  return 0;
}
