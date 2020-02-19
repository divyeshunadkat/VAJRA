#include "array_ssa.h"

char array_ssa::ID = 0;

array_ssa::array_ssa(z3::context& z3_,
                     options& o_,
                     value_expr_map& def_map_,
                     std::map<llvm::Loop*, loopdata*>& ldm,
                     name_map& lMap,
                     std::map<std::string, llvm::Value*>& evMap,
                     std::unique_ptr<llvm::Module>& m,
                     glb_model& g_model_)
  : llvm::FunctionPass(ID)
  , z3_ctx(z3_)
  , o(o_)
  , ld_map(ldm)
  , module(m)
  , g_model(g_model_)
{
  ir2e = new irtoz3expr_index(z3_ctx, def_map_, lMap, evMap, g_model);
}

array_ssa::~array_ssa() {}

bool array_ssa::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }
  //  get_topologically_sorted_bb(&f, fun_bb_vec);
  collect_arr(f, arr_alloca_set);
  init_maps();
  convert_to_ssa();
  return true;
}

void array_ssa::convert_to_ssa() {
  auto ld = ld_map.at(NULL);
  std::vector< loopdata* >& sub_loops = ld->childHeads;
  unsigned gap_num = 0;
  for( auto b : ld->getCurrentBlocks() ) {
    if( b == NULL ) {
      //processing sub loops
      auto sub_loop_ld = sub_loops[gap_num++];
      if(sub_loop_ld->childHeads.size() > 0)
        tiler_error("array_ssa::",
                    "Nested loops are currently not supported");
      process_loop( sub_loop_ld );
    }else{
      process_outer_block(b);
    }
  }
  assert( gap_num == ld->childHeads.size() );
}

// If multiple updates happen to an array within the loop,
// they all will get the same fresh name as we only need
// to know the value of the array at the end of the loop
// TODO : Ensure array updated do not happen along single
// conditional branch otherwise multiple names will reach
// at the end of the loop
void array_ssa::process_loop(loopdata* ld) {
  create_new_names(ld, ld->arrWrite);

  for( auto bb : ld->getCurrentBlocks() ) {
    if(bb != NULL) {
      rename_arr_in_block(bb, ld);
    }
    else { assert(false); } // Nested loops are currently not supported
  }

  auto wbit = ld->arrWrite.begin();
  for (; wbit!=ld->arrWrite.end(); wbit++) {
    auto arry = wbit->first;
    auto arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(arry);
    update_prev_curr_maps(arry_alloca, curr_arr_map.at(arry_alloca));
  }
}

void array_ssa::process_outer_block(llvm::BasicBlock* bb) {
  // Array reads and writes in the block not inside loops
  std::map<llvm::Value*, std::list<llvm::Value*>> arrRead;
  std::map<llvm::Value*, std::list<llvm::Value*>> arrWrite;
  populate_arr_rd_wr(bb, arrRead, arrWrite);

  create_new_names(NULL, arrWrite);
  rename_arr_in_block(bb, NULL);
}

// Function : create _new_names
// Creates new names for arrays that have been updated once before;
// otherwise it does not create a new name
// New names are not created for arrays of size N written in outer blocks
void array_ssa::create_new_names(loopdata* ld,
                                 std::map<llvm::Value*,
                                 std::list<llvm::Value*>>& arrWrite) {
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator wbit = arrWrite.begin();
  for (; wbit!=arrWrite.end(); wbit++) {
    auto arry = wbit->first;
    llvm::AllocaInst *arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(arry);
    if(ld == NULL && !arry_alloca->isStaticAlloca()) continue;
    if(!is_updated_once(arry_alloca)) {
      set_updated(arry_alloca);
      continue;
    } else {
      llvm::AllocaInst* new_arry_alloca = create_new_alloca(arry_alloca);
      set_updated(new_arry_alloca);
      update_prev_curr_maps(arry_alloca, new_arry_alloca);
    }
  }
}

void array_ssa::rename_arr_in_block(llvm::BasicBlock* bb, loopdata* ld) {
  for( auto it = bb->begin(), e = bb->end(); it != e; ++it) {
    llvm::Instruction *I = &(*it);
    if(llvm::StoreInst* store = llvm::dyn_cast<llvm::StoreInst>(I)) {
      auto val = store->getOperand(0);
      auto addr = store->getOperand(1);
      llvm::BitCastInst* addr_bc = NULL;
      if( (addr_bc = llvm::dyn_cast<llvm::BitCastInst>(addr)) )
        addr = addr_bc->getOperand(0);
      if( auto gep = llvm::dyn_cast<llvm::GetElementPtrInst>(addr) ) {
        llvm::AllocaInst *st_arry_alloca = getAlloca(store);
        auto st_prev_arry_alloca = prev_arr_map.at(st_arry_alloca);
        auto st_new_arry_alloca = curr_arr_map.at(st_arry_alloca);
        remap_store(store, st_arry_alloca, st_new_arry_alloca);
        if(ld!=NULL && st_arry_alloca->isStaticAlloca()) {
          llvm::BasicBlock* pre_header = ld->loop->getLoopPreheader();
          if(!pre_header) tiler_error("array_ssa::",
                                      "Unique preheader block not found");
          add_equality_stmt(pre_header, st_prev_arry_alloca,
                            st_new_arry_alloca, o.globalContext);
        }
      } else {}
    } else if(llvm::LoadInst* load = llvm::dyn_cast<llvm::LoadInst>(I)) {
      auto addr = load->getOperand(0);
      llvm::BitCastInst* addr_bc = NULL;
      if( (addr_bc = llvm::dyn_cast<llvm::BitCastInst>(addr)) )
        addr = addr_bc->getOperand(0);
      if( auto gep = llvm::dyn_cast<llvm::GetElementPtrInst>(addr) ) {
        auto idx = getIdx(load);
        std::list<z3::expr> le = ir2e->getZ3Expr(idx);
        if(le.size() <= 0) tiler_error("array_ssa", "Index expr not found");
        z3::expr idx_e = le.front();
        llvm::AllocaInst *arry_alloca = getAlloca(load);
        if(ld != NULL && !check_sat(idx_e.ctx(), ld->ctrZ3Expr > idx_e))  {
          auto prev_arry_alloca = prev_arr_map.at(arry_alloca);
          remap_load(load, arry_alloca, prev_arry_alloca);
        } else {
          auto new_arry_alloca = curr_arr_map.at(arry_alloca);
          remap_load(load, arry_alloca, new_arry_alloca);
        }
      } else {}
    } else {}
  }
}

void array_ssa::init_maps() {
  std::set<llvm::AllocaInst*>::iterator it;
  for (it=arr_alloca_set.begin(); it!=arr_alloca_set.end(); it++) {
    prev_arr_map[*it] = *it;
    curr_arr_map[*it] = *it;
    unset_updated(*it);
  }
}

bool array_ssa::is_updated_once(llvm::AllocaInst* arry_alloca) {
  bool b = arr_updflag_map.at(arry_alloca);
  return b;
}

void array_ssa::set_updated(llvm::AllocaInst* arry_alloca) {
  arr_updflag_map[arry_alloca] = true;
}

void array_ssa::unset_updated(llvm::AllocaInst* arry_alloca) {
  arr_updflag_map[arry_alloca] = false;
}

void array_ssa::update_prev_curr_maps(llvm::AllocaInst* arry_alloca,
                                      llvm::AllocaInst* new_arry_alloca) {
  prev_arr_map[arry_alloca] = curr_arr_map.at(arry_alloca);
  curr_arr_map[arry_alloca] = new_arry_alloca;
}

llvm::StringRef array_ssa::getPassName() const {
  return "Gives new names to arrays at store points by creating new allocas";
}

void array_ssa::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
