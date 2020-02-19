#ifndef ARRAY_SSA_H
#define ARRAY_SSA_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"
#include "utils/options.h"
#include "daikon-inst/loopdata.h"
#include "irtoz3expr/irtoz3expr_index.h"

class array_ssa : public llvm::FunctionPass
{
  public:
  static char ID;

  z3::context& z3_ctx;
  options& o;
  std::map<llvm::Loop*, loopdata*>& ld_map;
  irtoz3expr_index* ir2e;
  std::unique_ptr<llvm::Module>& module;
  glb_model g_model;

  array_ssa( z3::context& ,
             options&,
             value_expr_map&,
             std::map<llvm::Loop*, loopdata*>& ,
             name_map& ,
             std::map<std::string, llvm::Value*>&,
             std::unique_ptr<llvm::Module>&,
             glb_model&);
  ~array_ssa();

  std::set< llvm::AllocaInst* > arr_alloca_set;
  std::map< llvm::AllocaInst*, llvm::AllocaInst* > prev_arr_map;
  std::map< llvm::AllocaInst*, llvm::AllocaInst* > curr_arr_map;
  std::map< llvm::AllocaInst*, bool > arr_updflag_map;

  void convert_to_ssa();
  void process_outer_block(llvm::BasicBlock*);
  void process_loop(loopdata* );
  void rename_arr_in_block(llvm::BasicBlock*, loopdata*);
  void create_new_names(loopdata*,
                        std::map<llvm::Value*, std::list<llvm::Value*>>&);

  void init_maps();
  bool is_updated_once(llvm::AllocaInst*);
  void set_updated(llvm::AllocaInst*);
  void unset_updated(llvm::AllocaInst*);
  void update_prev_curr_maps(llvm::AllocaInst*, llvm::AllocaInst*);

  virtual bool runOnFunction(llvm::Function &f);
  llvm::StringRef getPassName() const;
  void getAnalysisUsage(llvm::AnalysisUsage &au) const;

};

#endif
