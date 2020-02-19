#ifndef AGGR_LLVM_DIFF_H
#define AGGR_LLVM_DIFF_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"
#include "utils/options.h"

#include "daikon-inst/loopdata.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/IRBuilder.h"
#pragma GCC diagnostic pop

class aggr_llvm_diff : public llvm::FunctionPass
{
  public:
  static char ID;
  std::unique_ptr<llvm::Module>& module;
  options& o;
  std::map<llvm::Loop*, loopdata*>& ld_map;
  std::map<llvm::Function*, std::map<const llvm::Value*,
                                     const llvm::Value*>>& fn_v2v_map;
  llvm::ValueToValueMapTy fn_vmap;
  int& unsupported;

  aggr_llvm_diff(std::unique_ptr<llvm::Module>&, options&, std::map<llvm::Loop*, loopdata*>&,
                 std::map<llvm::Function*, std::map<const llvm::Value*,const llvm::Value*>>&,
                 int&);
  ~aggr_llvm_diff();

  llvm::Function* diff_f = NULL;
  llvm::BasicBlock* entry_bb = NULL;
  llvm::Value* N = NULL;
  llvm::Instruction *NS = NULL;
  std::list<llvm::Loop*> loopList;

  // Array reads and values that are diff for a future aggregator
  // NULL values for aggregators that do not generate a diff value
  std::map<llvm::Value*, std::list<llvm::Value*>> local_diff_map;

  void peel_function(llvm::Function*);
  void remove_loop_back_edge(llvm::Loop *, loopdata *);
  void peel_loop(llvm::Loop* L, loopdata* ld);
  void generate_glue_for_loop(llvm::AllocaInst*, llvm::StoreInst*,
                              llvm::Loop*, loopdata*);
  void identify_prev_value(loopdata*, std::map<llvm::Value*, llvm::Value*>&);
  void gen_fpdiv_glue_loop(llvm::AllocaInst*, llvm::StoreInst*, loopdata*,
                            std::map<llvm::Value*, llvm::Value*>&);
  void build_fpdiv_glue(llvm::AllocaInst*, loopdata*,
                         llvm::IRBuilder<> &, llvm::PHINode *,
                         std::map<llvm::Value*, llvm::Value*>&);
  void build_div_glue(llvm::AllocaInst*, loopdata*,
                      llvm::IRBuilder<> &, llvm::PHINode *,
                      std::map<llvm::Value*, llvm::Value*>&);
  void compute_local_diff_n_add(llvm::AllocaInst*, loopdata*);
  void peel_outer_block(llvm::BasicBlock*);
  void add_to_local_diff(llvm::AllocaInst*, llvm::Value*);

  void peel_cloned_function(llvm::Function*);
  void remove_loop_back_edge_in_clone(llvm::Loop*, loopdata *);

  bool loop_cloning(llvm::Function &);
  llvm::Function* create_diff_function(llvm::Function &);
  void process(llvm::Loop*, loopdata*, llvm::Function*);
  void clone_loop_blocks(llvm::Loop*, loopdata*, llvm::Function*);
  void peel_and_remap_loop_inst(llvm::Loop*, loopdata*);
  void rewire_cloned_loop_blocks(llvm::Loop*, loopdata*);

  void identify_interfering_writes(llvm::Loop*, loopdata*);
  void compute_local_diff_value(llvm::Loop*, loopdata*);
  void update_cfg(llvm::AllocaInst*, llvm::StoreInst*,
                  llvm::AllocaInst*, llvm::LoadInst*,
                  loopdata*, loopdata*, llvm::Loop*);

  void find_ind_param_N();
  void check_conditional_in_loopbody();
  void check_indu_param_in_index(llvm::Function &);

  virtual bool runOnFunction(llvm::Function &f);
  llvm::StringRef getPassName() const;
  void getAnalysisUsage(llvm::AnalysisUsage &au) const;

};

#endif
