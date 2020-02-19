#include "aggr_llvm_diff.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include "llvm/Transforms/Utils/Cloning.h"

char aggr_llvm_diff::ID = 0;

aggr_llvm_diff::aggr_llvm_diff(std::unique_ptr<llvm::Module>& m,
                               options& o_,
                               std::map<llvm::Loop*, loopdata*>& ldm,
                               std::map<llvm::Function*, std::map<const llvm::Value*,
                               const llvm::Value*>>& v2v_map,
                               int& unsup)
  : llvm::FunctionPass(ID)
  , module(m)
  , o(o_)
  , ld_map(ldm)
  , fn_v2v_map(v2v_map)
  , unsupported(unsup)
{}

aggr_llvm_diff::~aggr_llvm_diff() {}

bool aggr_llvm_diff::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }
  // We assume that arrays are of size N or 1
  // for array of size N, all entries are updated in the loop and not outside
  // for arrays of size 1, its entry can be updated in a block within or outside the loop
  //  peel_cloned_function(&f);
  peel_function(&f);
  return true;
}

void aggr_llvm_diff::
peel_function(llvm::Function* diff_fun) {

  diff_f = diff_fun;
  auto ld = ld_map.at(NULL);
  std::vector< loopdata* >& sub_loops = ld->childHeads;

  // Peel the function only if loops are present
  if(sub_loops.empty()) return;

  // Get entry block
  entry_bb = &diff_fun->getEntryBlock();

  // Identify the induction parameter N from the program
  find_ind_param_N();

  // Check if any conditional statement in any loop is dependent on N
  check_conditional_in_loopbody();

  // Check if induction parameter is present in the index expression
  check_indu_param_in_index(*diff_fun);

  // Create N-1 instruction and add before terminator of entry
  llvm::Instruction* term = entry_bb->getTerminator();
  if(!term) tiler_error("Difference::", "Entry block does not have unique term inst");
  llvm::Type *oneTy = N->getType();
  assert(oneTy);
  if(oneTy->isPointerTy()) {
    oneTy = oneTy->getPointerElementType();
    llvm::Value* one = llvm::ConstantInt::get(oneTy, 1);
    llvm::LoadInst* N_load = new llvm::LoadInst(N, "NLoad", term);
    NS = llvm::BinaryOperator::Create(llvm::Instruction::Sub, N_load, one, "NS");
  } else {
    llvm::Value* one = llvm::ConstantInt::get(oneTy, 1);
    NS = llvm::BinaryOperator::Create(llvm::Instruction::Sub, N, one, "NS");
  }
  NS->insertBefore(term);

  unsigned gap_num = 0;
  for( auto b : ld->getCurrentBlocks() ) {
    if( b == NULL ) {
      //processing sub loops
      auto sub_loop = sub_loops[gap_num++];
      peel_loop( sub_loop->loop, sub_loop );
    }else{
      peel_outer_block(b);
    }
  }
  assert( gap_num == ld->childHeads.size() );
}

// Peel an iteration of the loop
// Add glue loops/statements needed for the store
void aggr_llvm_diff::
peel_loop(llvm::Loop* L, loopdata* ld) {
  loopList.push_back(L);
  identify_interfering_writes(L, ld);

  // Remove the back edge
  remove_loop_back_edge(L, ld);

  // No glue code if arrays are only read
  // if(ld->arrWrite.empty()) return;

  // Error on writes to multiple arrays in the loop
  //  if(ld->arrWrite.size() > 1)
  //    tiler_error("Difference::",
  //                "Writes to multiple arrays in a loop is currently not supported");

  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator wbit = ld->arrWrite.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator weit = ld->arrWrite.end();
  for (; wbit!=weit; wbit++) {
    auto wr_arry = wbit->first;
    auto wr_arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(wr_arry);
    std::list<llvm::Value*> vl = wbit->second;
    // Error on writes to multiple indices
    //    if(vl.size() > 1)
    //      tiler_error("Difference::",
    //                  "Multiple writes to an array in the loop is currently not supported");
    for(auto v : vl) {
      auto store = llvm::dyn_cast<llvm::StoreInst>(v);
      if(isRemInStore(store)) {
        unsupported = 1;
        // std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
        // tiler_error("Difference::", "Encountered unsupported modulo operation");
      }
      llvm::Value* st_val = store->getOperand(0);
      /* WORK IN PROGRESS CODE
      if(!isLoadOrStoreInSubExpr(st_val) && isValueInSubExpr(N, st_val)) {
        std::vector<llvm::Value*> vars;
        vars.push_back(N);
        vars.push_back(ld->ctr);
        llvm_poly simp_st_val;
        get_simplified_polynomial(st_val, vars, getDataLayout(store), simp_st_val);
      } else {}
      */
      if(isValueInSubExpr(N, st_val)) {
        llvm::Value* constVal = NULL;
        //        st_val->print( llvm::outs() );
        //        N->print(llvm::outs());
        if(N == st_val) {
          constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
        } else if (auto st_load = llvm::dyn_cast<llvm::LoadInst>(st_val) ) {
          if(N == st_load->getOperand(0)) {
            constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
          }
        } else if(auto bop = llvm::dyn_cast<llvm::BinaryOperator>(st_val) ) {
          bool res1 = false, res2 = false;
          if(N == bop->getOperand(0)) {
            res1 = true;
          } else if (auto op0_load = llvm::dyn_cast<llvm::LoadInst>(bop->getOperand(0)) ) {
            if(N == op0_load->getOperand(0)) {
              res1 = true;
            }
          } else {}
          if(N == bop->getOperand(1)) {
            res2 = true;
          } else if (auto op1_load = llvm::dyn_cast<llvm::LoadInst>(bop->getOperand(1)) ) {
            if(N == op1_load->getOperand(0)) {
              res2 = true;
            }
          }

          if(!res1 && !res2) tiler_error("Difference::", "Unsupported expression encountered!!");
          unsigned op = bop->getOpcode();
          switch( op ) {
          case llvm::Instruction::Add :
            if(res1 && !res2 && !isValueInSubExpr(N, bop->getOperand(1))) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
            } else if (!res1 && !isValueInSubExpr(N, bop->getOperand(0)) && res2) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
            } else if(res1 && res2) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 2);
            } else {}
            break;
          case llvm::Instruction::Sub :
            if(res1 && !res2 && !isValueInSubExpr(N, bop->getOperand(1))) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), -1);
            } else if (!res1 && !isValueInSubExpr(N, bop->getOperand(0)) && res2) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), -1);
            } else if(res1 && res2) {
              constVal = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), -2);
            } else {}
            break;
          case llvm::Instruction::Mul : break;
            if(res1 && !res2 && !isValueInSubExpr(N, bop->getOperand(1))) {
              constVal = bop->getOperand(1);
            } else if (!res1 && !isValueInSubExpr(N, bop->getOperand(0)) && res2) {
              constVal = bop->getOperand(0);
            } else if(res1 && res2) {
              constVal = NULL;
              tiler_error("Difference::", "Unsupported!!");
            } else {}
          case llvm::Instruction::SRem: break;
          case llvm::Instruction::URem: break;
          default: {
            tiler_error("Difference::", "Unsupported operator encountered!!");
          }
          }
        } else {
          tiler_error("Difference::", "Unsupported expression encountered!!");
        }
        add_to_local_diff(wr_arry_alloca, constVal);
        //        llvm::Value* constOne = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
        //        add_to_local_diff(wr_arry_alloca, constOne);
        //        llvm::Value* constOne = llvm::ConstantInt::get(o.globalContext,
        //                                                       llvm::APInt(32, 1, true));
      }
    }

    for(auto v : vl) {
      auto store = llvm::dyn_cast<llvm::StoreInst>(v);
      llvm::Value* st_val = store->getOperand(0);
      /*
      if(!isLoadOrStoreInSubExpr(st_val) && isValueInSubExpr(N, st_val)) {
        std::vector<llvm::Value*> vars;
        vars.push_back(N);
        vars.push_back(ld->ctr);
        llvm_poly simp_st_val;
        get_simplified_polynomial(st_val, vars, getDataLayout(store), simp_st_val);
      } else {}
      */
      if(isValueInSubExpr(N, st_val)) {
        //        assert(!wr_arry_alloca->isStaticAlloca());
        // Create a new loop where counter goes from 0 to N-1
        // store old_arr = old_arr + 1
        // Currently slicing the loop
        // compute_local_diff_n_add(wr_arry_alloca, ld);
      } else if (llvm::dyn_cast<llvm::ConstantInt>(store->getOperand(0))) {
        /* Scalars do not need to be assigned constants inside loops
        if(wr_arry_alloca->isStaticAlloca())
          tiler_error("Difference::",
                      "Scalar assigned a constant inside a loop");
        */
        // Do nothing about constant assignments to arrays or scalars
      } else {
        generate_glue_for_loop(wr_arry_alloca, store, L, ld);
        compute_local_diff_n_add(wr_arry_alloca, ld);
      }
    }
  }

  // Replace i with N-1
  ld->VMap[ld->ctr] = NS;
  llvm::remapInstructionsInBlocks(to_small_vec(ld->blocks), ld->VMap);
  ld->VMap.clear();
  // Remove phi inst of i
  if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(ld->ctr)) {
    I->eraseFromParent();
  }

}

void aggr_llvm_diff::
generate_glue_for_loop(llvm::AllocaInst* wr_arry_alloca,
                       llvm::StoreInst* store,
                       llvm::Loop* L, loopdata* ld) {
  std::list<llvm::Value*> tmp_diff_list;
  llvm::Type *i32_ptr_type = llvm::IntegerType::getInt32PtrTy(o.globalContext);

  llvm::BasicBlock* pre_header = ld->loop->getLoopPreheader();
  llvm::Instruction* term = pre_header->getTerminator();
  if(!term) tiler_error("Difference::", "Preheader block does not have unique term inst");

  if(isDivInStore(store)) {
    std::map<llvm::Value*, llvm::Value*> prev_val_map;
    identify_prev_value(ld, prev_val_map);
    if(prev_val_map.size() > 0) {
      gen_fpdiv_glue_loop(wr_arry_alloca, store, ld, prev_val_map);
    } else {}
  } else {}

  llvm::Instruction* insertion_pt=NULL;
  if(wr_arry_alloca->isStaticAlloca()) {
    insertion_pt = term;
  } else {
    llvm::Value* Z = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 0);
    llvm::Instruction* I = llvm::BinaryOperator::Create(llvm::Instruction::Add, Z, Z, "no-op");
    I->insertAfter(store);
    insertion_pt = I;
  }

  llvm::IRBuilder<> b(insertion_pt);
  auto st_addr = store->getOperand(1);
  llvm::BitCastInst* st_addr_bc = NULL;
  if( (st_addr_bc = llvm::dyn_cast<llvm::BitCastInst>(st_addr)) )
    st_addr = st_addr_bc->getOperand(0);
  auto st_elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(st_addr);
  auto idx = st_elemPtr->getOperand(1);
  if(st_elemPtr->getNumIndices() == 2) idx = st_elemPtr->getOperand(2);

  llvm::GetElementPtrInst* new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
    (b.CreateGEP(wr_arry_alloca, idx));
  llvm::BitCastInst* new_elem_ptr_bc = NULL;
  if(wr_arry_alloca->isStaticAlloca()) {
    new_elem_ptr_bc = llvm::dyn_cast<llvm::BitCastInst>
      (b.CreateBitCast(new_elem_ptr, i32_ptr_type));
  } else {}
  llvm::LoadInst* new_load = NULL;
  if(new_elem_ptr_bc) {
   new_load = llvm::dyn_cast<llvm::LoadInst> (b.CreateLoad(new_elem_ptr_bc));
  } else {
   new_load = llvm::dyn_cast<llvm::LoadInst> (b.CreateLoad(new_elem_ptr));
  }

  llvm::Value* val = new_load;
  bool at_least_one_diff_val = false;
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator rbit = ld->arrRead.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator reit = ld->arrRead.end();
  for (; rbit!=reit; rbit++) {
    auto load_arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(rbit->first);
    if(wr_arry_alloca == load_arry_alloca && wr_arry_alloca->isStaticAlloca()) continue;
    std::list<llvm::Value*> read_l = rbit->second;
    //    if(read_l.size() > 1)
    //      tiler_error("Difference::", "Not supported");
    //    for(auto v : read_l) {
      std::list<llvm::Value*>& diff_val_l = local_diff_map[load_arry_alloca];
      for(llvm::Value* diff_val : diff_val_l) {
        if(wr_arry_alloca->isStaticAlloca()) {
          if(!load_arry_alloca->isStaticAlloca()) {
            diff_val = b.CreateMul(diff_val, NS);
          }
          val = b.CreateAdd(val, diff_val);
          at_least_one_diff_val = true;
        } else {
          at_least_one_diff_val = false;
          if(wr_arry_alloca == load_arry_alloca) {
            val = b.CreateAdd(val, diff_val);
            at_least_one_diff_val = true;
          }
        }
        if(wr_arry_alloca != load_arry_alloca)
           tmp_diff_list.push_back(diff_val);
      }
      //    }
  }
  if(at_least_one_diff_val) {
    auto st_new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
      (b.CreateGEP(wr_arry_alloca, idx));
    if(wr_arry_alloca->isStaticAlloca()) {
      auto st_new_elem_ptr_bc = llvm::dyn_cast<llvm::BitCastInst>
        (b.CreateBitCast(st_new_elem_ptr, i32_ptr_type));
      b.CreateStore(val, st_new_elem_ptr_bc);
    } else {
      b.CreateStore(val, st_new_elem_ptr);
    }
  } else {
    new_load->eraseFromParent();
    if(new_elem_ptr_bc) new_elem_ptr_bc->eraseFromParent();
    new_elem_ptr->eraseFromParent();
  }

  for(auto v : tmp_diff_list)
    add_to_local_diff(wr_arry_alloca, v);
}

void aggr_llvm_diff::
identify_prev_value(loopdata* ld, std::map<llvm::Value*, llvm::Value*>& prev_val_map) {
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator rbit = ld->arrRead.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator reit = ld->arrRead.end();
  for (; rbit!=reit; rbit++) {
    std::list<llvm::Value*> rl = rbit->second;
    if(rl.size() != 1) continue;
    if(ld->interfering_loops.count(rbit->first) > 0) {
      llvm::Loop* int_loop = ld->interfering_loops.at(rbit->first);
      loopdata* int_ld = ld_map.at(int_loop);
      if(int_ld == NULL) continue;
      if(int_ld->arrRead.size() != 0) {
        std::map<llvm::Value*,std::list<llvm::Value*>>::iterator int_rbit =
          int_ld->arrRead.begin();
        std::map<llvm::Value*,std::list<llvm::Value*>>::iterator int_reit =
          int_ld->arrRead.end();
        for (; int_rbit!=int_reit; int_rbit++) {
          if(int_rbit->first == rbit->first) {
            std::list<llvm::Value*> int_rl = int_rbit->second;
            if(int_rl.size() != 1) continue;
            llvm::LoadInst* prevload = llvm::dyn_cast<llvm::LoadInst>(int_rl.front());
            llvm::LoadInst* load = llvm::dyn_cast<llvm::LoadInst>(rl.front());
            prev_val_map[load] = prevload;
          } else {}
        }
      } else {} // Do nothing
    } else {}
  }
}

void aggr_llvm_diff::
gen_fpdiv_glue_loop(llvm::AllocaInst* wr_arry_alloca,
                     llvm::StoreInst* store, loopdata* ld,
                     std::map<llvm::Value*, llvm::Value*>& prev_val_map) {

  //Split the block before term instruction by adding a no-op inst
  llvm::BasicBlock* prebb = ld->loop->getLoopPreheader();
  llvm::Instruction* term = prebb->getTerminator();
  llvm::Value* Z = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 0);
  llvm::Instruction *I = llvm::BinaryOperator::Create(llvm::Instruction::Add, Z, Z, "no-op");
  I->insertBefore(term);
  llvm::BasicBlock* b1 = prebb->splitBasicBlock(I);
  I->eraseFromParent();

  //Create a new block that holds the glue code
  llvm::BasicBlock* block = llvm::BasicBlock::Create(o.globalContext, "loop", diff_f, b1);
  llvm::IRBuilder<> builder(block);
  llvm::PHINode *pnode = builder.CreatePHI(llvm::IntegerType::getInt32Ty(o.globalContext), 0, "i");
  pnode->addIncoming( Z, prebb);

  // Generate the glue code and add to the block
  build_fpdiv_glue(wr_arry_alloca, ld, builder, pnode, prev_val_map);

  //Increment the loop counter
  llvm::Value* constOne = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
  llvm::Value *nextVal = builder.CreateAdd(pnode, constOne, "i");
  pnode->addIncoming( nextVal, block);

  //Insert the created block between the split blocks
  prebb->getTerminator()->setSuccessor(0, block);
  llvm::Value* cond = builder.CreateICmpSLT(nextVal, NS, "i<N-1");
  builder.CreateCondBr(cond, block, b1);
}

void aggr_llvm_diff::
build_fpdiv_glue(llvm::AllocaInst* wr_arry_alloca, loopdata* ld,
                  llvm::IRBuilder<> &b, llvm::PHINode* counter,
                  std::map<llvm::Value*, llvm::Value*>& prev_val_map) {
  llvm::Type *float_type = llvm::Type::getFloatTy(wr_arry_alloca->getContext());
  //  CreateSIToFP
  llvm::GetElementPtrInst* new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
    (b.CreateGEP(wr_arry_alloca, counter));
  llvm::LoadInst* new_load = llvm::dyn_cast<llvm::LoadInst>
    (b.CreateLoad(new_elem_ptr));
  llvm::Value* store_val = new_load;
  auto it = prev_val_map.begin();
  for(; it!=prev_val_map.end(); it++ ) {
    auto cast_val = b.CreateSIToFP(it->first, float_type);
    store_val = b.CreateFDiv(store_val, cast_val);
    cast_val = b.CreateSIToFP(it->second, float_type);
    store_val = b.CreateFDiv(store_val, cast_val);
  }
  auto st_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
    (b.CreateGEP(wr_arry_alloca, counter));
  b.CreateStore(store_val, st_elem_ptr);
}

void aggr_llvm_diff::
build_div_glue(llvm::AllocaInst* wr_arry_alloca, loopdata* ld,
                  llvm::IRBuilder<> &b, llvm::PHINode* counter,
                  std::map<llvm::Value*, llvm::Value*>& prev_val_map) {
  llvm::GetElementPtrInst* new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
    (b.CreateGEP(wr_arry_alloca, counter));
  llvm::LoadInst* new_load = llvm::dyn_cast<llvm::LoadInst>
    (b.CreateLoad(new_elem_ptr));
  llvm::Value* store_val = new_load;
  auto it = prev_val_map.begin();
  for(; it!=prev_val_map.end(); it++ ) {
    store_val = b.CreateSDiv(store_val, it->first);
    store_val = b.CreateSDiv(store_val, it->second);
  }
  auto st_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
    (b.CreateGEP(wr_arry_alloca, counter));
  b.CreateStore(store_val, st_elem_ptr);
}

void aggr_llvm_diff::
compute_local_diff_n_add(llvm::AllocaInst* wr_arry_alloca, loopdata* ld) {
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator rbit = ld->arrRead.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator reit = ld->arrRead.end();
  for (; rbit!=reit; rbit++) {
    auto load_arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(rbit->first);
    // Diff does not come from the aggregator
    if(wr_arry_alloca == load_arry_alloca) continue;
    if(wr_arry_alloca->isStaticAlloca() &&
       !load_arry_alloca->isStaticAlloca()) {
      std::list<llvm::Value*> read_l = rbit->second;
      for(auto v : read_l) {
        auto load = llvm::dyn_cast<llvm::LoadInst>(v);
        add_to_local_diff(wr_arry_alloca, load);
      }
    } else {}
  }
}

// Remove stores that are not needed in the peel
// Add glue statements needed while processing outer block
void aggr_llvm_diff::
peel_outer_block(llvm::BasicBlock* bb) {
  // loopdata pointer for all blocks outside any loops
  auto ld = ld_map.at(NULL);
  populate_arr_rd_wr(bb, ld->arrRead, ld->arrWrite);
  if(!ld->arrWrite.empty()) {
    std::map<llvm::Value*,std::list<llvm::Value*>>::iterator wbit = ld->arrWrite.begin();
    std::map<llvm::Value*,std::list<llvm::Value*>>::iterator weit = ld->arrWrite.end();
    for (; wbit!=weit; wbit++) {
      auto arry = wbit->first;
      llvm::AllocaInst *arry_alloca = llvm::dyn_cast<llvm::AllocaInst>(arry);
      std::list<llvm::Value*> vl = wbit->second;
      /* Error on multiple writes
      if(vl.size() > 1)
        tiler_error("Difference::",
                    "Multiple writes to an array in the same block is currently not supported");
      */
      for(auto v : vl) {
        llvm::StoreInst* store = llvm::dyn_cast<llvm::StoreInst>(v);
        if(isRemInStore(store)) {
          unsupported = 1;
          // std::cout << "\n\nVAJRA_VERIFICATION_UNKNOWN\n\n";
          // tiler_error("Difference::", "Encountered unsupported modulo operation");
        }
        //        llvm::Type *i32_type = llvm::IntegerType::getInt32Ty(store->getContext());
        llvm::Type *i32_ptr_type = llvm::IntegerType::getInt32PtrTy(store->getContext());
        /*
        llvm::Value* st_val = store->getOperand(0);
        if(!isLoadOrStoreInSubExpr(st_val) && isValueInSubExpr(N, st_val)) {
          std::vector<llvm::Value*> vars;
          vars.push_back(N);
          llvm_poly simp_st_val;
          get_simplified_polynomial(st_val, vars, getDataLayout(store), simp_st_val);
        } else {}
        */
        if(isValueInSubExpr(N, store->getOperand(0))) {
          // Instead of storing N in var, store new_var + 1
          if(arry_alloca->isStaticAlloca()) {

          llvm::AllocaInst* new_arry_alloca = create_new_alloca(arry_alloca);
          // Add the newly created alloca to the alloca_map obtained from the fn_v2v_map
          if(fn_v2v_map.count(diff_f) > 0) {
            std::map<const llvm::Value*, const llvm::Value*>& alloca_map = fn_v2v_map[diff_f];
            if(alloca_map.count(arry_alloca) > 0) {
              alloca_map[new_arry_alloca] = alloca_map[arry_alloca];
            } else {
              tiler_error("Difference::","Unable to map newly created alloca");
            }
          } else {
            tiler_error("Difference::","No value map found for the function under analysis");
          }
          llvm::Value* constOne = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
          llvm::IRBuilder<> b(store);
          auto elemPtr = getGEP(store);
          auto idx = getIdx(store);
          auto new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
            (b.CreateInBoundsGEP(new_arry_alloca, idx));
          auto new_elem_ptr_bc = b.CreateBitCast(new_elem_ptr, i32_ptr_type);
          llvm::LoadInst* load = llvm::dyn_cast<llvm::LoadInst>
            (b.CreateLoad(new_elem_ptr_bc));
          llvm::Value* val = b.CreateAdd(load, constOne);
          b.CreateStore(val, elemPtr);
          add_to_local_diff(arry_alloca, constOne);
          store->eraseFromParent();
          } else {
            llvm::Value* constOne = llvm::ConstantInt::get(llvm::Type::getInt32Ty(o.globalContext), 1);
            add_to_local_diff(arry_alloca, constOne);
            store->eraseFromParent();
          }
        } else if (llvm::dyn_cast<llvm::ConstantInt>(store->getOperand(0))) {
          auto addr = store->getOperand(1);
          llvm::BitCastInst* addr_bc = NULL;
          if( (addr_bc = llvm::dyn_cast<llvm::BitCastInst>(addr)) )
            addr = addr_bc->getOperand(0);
          auto gep = llvm::dyn_cast<llvm::GetElementPtrInst>(addr);
          //          if(arry_alloca->isStaticAlloca()) {
            store->eraseFromParent();
            if(addr_bc != NULL) addr_bc->eraseFromParent();
            gep->eraseFromParent();
          //          } else {} // Do not remove the constant assignments for size N arrays
        } else if(auto load = llvm::dyn_cast<llvm::LoadInst>(store->getOperand(0))) {
          auto load_addr = load->getOperand(0);
          llvm::BitCastInst* load_addr_bc = NULL;
          if( (load_addr_bc = llvm::dyn_cast<llvm::BitCastInst>(load_addr)) )
            load_addr = load_addr_bc->getOperand(0);
          auto load_elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(load_addr);
          auto load_arry = load_elemPtr->getPointerOperand();
          llvm::Value* diff_val = NULL;
          std::list<llvm::Value*>& diff_val_l = local_diff_map[load_arry];
          for(llvm::Value* v : diff_val_l) {
            if(v==NULL) continue;
            diff_val = v;
          }
          auto st_addr = store->getOperand(1);
          llvm::BitCastInst* st_addr_bc = NULL;
          if( (st_addr_bc = llvm::dyn_cast<llvm::BitCastInst>(st_addr)) )
            st_addr = st_addr_bc->getOperand(0);
          auto st_elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(st_addr);
          auto idx = st_elemPtr->getOperand(1);
          if(st_elemPtr->getNumIndices() == 2)
            idx = st_elemPtr->getOperand(2);
          if(diff_val != NULL) {
            llvm::IRBuilder<> b(store);
            llvm::Value* elemPtr_or_bcPtr = NULL;
            if(st_addr_bc) {
              elemPtr_or_bcPtr = st_addr_bc;
            } else {
              elemPtr_or_bcPtr = st_elemPtr;
            }
            llvm::LoadInst* new_load = llvm::dyn_cast<llvm::LoadInst>
              (b.CreateLoad(elemPtr_or_bcPtr));
            llvm::Value* val = b.CreateAdd(new_load, diff_val);
            auto new_elem_ptr = llvm::dyn_cast<llvm::GetElementPtrInst>
              (b.CreateInBoundsGEP(arry_alloca, idx));
            auto new_elem_ptr_bc = b.CreateBitCast(new_elem_ptr, i32_ptr_type);
            b.CreateStore(val, new_elem_ptr_bc);
            add_to_local_diff(arry_alloca, diff_val);
          }
          store->eraseFromParent();
          if(diff_val == NULL) {
            if(st_addr_bc != NULL) st_addr_bc->eraseFromParent();
            st_elemPtr->eraseFromParent();
          }
          load->eraseFromParent();
          if(load_addr_bc != NULL) load_addr_bc->eraseFromParent();
          load_elemPtr->eraseFromParent();
        } else {
          std::cout << "Warning: These instructions are currently not supported";
        }
      }
    }
  } else {}
}

void aggr_llvm_diff::
remove_loop_back_edge (llvm::Loop* L, loopdata* ld) {
  bb* exit_block = NULL;
  bb* header = L->getHeader();
  bb* latch = L->getLoopLatch();
  llvm::Instruction* term = latch->getTerminator();
  if (llvm::BranchInst* bi = llvm::dyn_cast<llvm::BranchInst>(term)) {
    const int NumS = bi->getNumSuccessors();
    for(int i=0; i<NumS; i++) {
      bb* s = bi->getSuccessor(i);
      if(s != header) {
        exit_block = s;
      }
    }

    // Remove the conditional branch and add a unconditional branch
    llvm::IRBuilder<> b(term);
    b.CreateBr(exit_block);
    llvm::Value *loopCond = bi->getCondition();
    bi->eraseFromParent();
    if( auto icmp = llvm::dyn_cast<llvm::ICmpInst>(loopCond) ) {
      icmp->eraseFromParent();
    }
/*
// Doing this generates bmc formula where the
// needed path gets sliced off
    for(int i=0; i<NumS; i++) {
      bb* s = bi->getSuccessor(i);
      if(s == header) {
        bi->setSuccessor(i, exit_block);
      }
    }
*/
  }
}

void aggr_llvm_diff::add_to_local_diff(llvm::AllocaInst* arry_alloca,
                                       llvm::Value* local_diff_val) {
  std::list<llvm::Value*>& arr_local_diff_l = local_diff_map[arry_alloca];
  arr_local_diff_l.push_back(local_diff_val);
}

void aggr_llvm_diff::find_ind_param_N() {
  bool checkAssignment = false;
  if(diff_f->arg_size() == 1 ) {
    // Use the only param to the function as the program parameter
    N = &(*diff_f->arg_begin());
  } else if(!module->global_empty()) {
    // Use the only global variable as the program parameter
    int glbCntr = 0;
    for( auto iter_glb= module->global_begin(),end_glb = module->global_end();
         iter_glb != end_glb; ++iter_glb ) {
      glbCntr ++;
      N = &*iter_glb; //3.8
    }
    //    if(glbCntr != 1)
    //      tiler_error("Difference::","Unable to find the program variable N for induction");
    checkAssignment = true;
  } else {
    for( auto it = entry_bb->begin(), e = entry_bb->end(); it != e; ++it) {
      llvm::Instruction *I = &(*it);
      if( auto alloc = llvm::dyn_cast<llvm::AllocaInst>(I) ) {
        if(alloc->isStaticAlloca()) continue;
        if( auto zext = llvm::dyn_cast<llvm::ZExtInst>(alloc->getArraySize()) ) {
          if(llvm::isa<llvm::BinaryOperator>(zext->getOperand(0)) ) break;
          N = zext->getOperand(0);
          checkAssignment=true;
          break;
        }
      }
    }
  }
  if(N == NULL) {
    tiler_error("Difference::","Unable to find the program variable N for induction");
  }
  // If N is not a function parameter check that there is only one non-det assignment
  // to N in the first block of the program.
  // Otherwise, report error due to inability to find the full-program induction vairable.
  if(checkAssignment) {
    int storeToNCntr = 0;
    for( auto it = entry_bb->begin(), e = entry_bb->end(); it != e; ++it) {
      llvm::Instruction *I = &(*it);
      if( auto store = llvm::dyn_cast<llvm::StoreInst>(I) ) {
        if(N == store->getOperand(1)) {
          if( auto call = llvm::dyn_cast<llvm::CallInst>(store->getOperand(0)) ) {
            llvm::Function* fp = call->getCalledFunction();
            if( fp != NULL && fp->getName().startswith("__VERIFIER_nondet_") ) {
              storeToNCntr++;
            }
          }
        }
      }
    }
    if(storeToNCntr > 1)
      tiler_error("Difference::",
                  "Unable to find the program variable N for induction");
    int intermediateCnt = storeToNCntr;
    for( auto bbit = diff_f->begin(), end = diff_f->end(); bbit != end; bbit++ ) {
      llvm::BasicBlock* bb = &(*bbit);
      if(bb == entry_bb) continue;
      for( auto it = bb->begin(), e = bb->end(); it != e; ++it) {
        llvm::Instruction *I = &(*it);
        if( auto store = llvm::dyn_cast<llvm::StoreInst>(I) ) {
          if(N == store->getOperand(1)) storeToNCntr++;
        }
      }
    }
    if(intermediateCnt != storeToNCntr)
      tiler_error("Difference::",
                  "Unable to find the program variable N for induction");
  }
}

void aggr_llvm_diff::check_conditional_in_loopbody() {
  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    for( auto b: L->getBlocks() ) {
      if(b == L->getLoopLatch()) continue;
      for( auto it = b->begin(), e = b->end(); it != e; ++it) {
        llvm::Instruction *I = &(*it);
        if (llvm::BranchInst* bi = llvm::dyn_cast<llvm::BranchInst>(I)) {
          if(bi->isUnconditional()) continue;
          if( auto icmp = llvm::dyn_cast<llvm::ICmpInst>(bi->getCondition()) ) {
            if(isValueInSubExpr(N, icmp->getOperand( 0 )))
              unsupported = 2;
            if(isValueInSubExpr(N, icmp->getOperand( 1 )))
              unsupported = 2;
          } else {
            tiler_error("Difference::",
                        "Non integer comparision is currently not supported");
          }
        } else {}
      }
    }
  }
}

void aggr_llvm_diff::check_indu_param_in_index( llvm::Function &f ) {
  for( auto bbit = f.begin(), end = f.end(); bbit != end; bbit++ ) {
    llvm::BasicBlock* bb = &(*bbit);
    for( llvm::Instruction& Iobj : bb->getInstList() ) {
      llvm::Instruction* I = &(Iobj);
      if( auto load = llvm::dyn_cast<llvm::LoadInst>(I) ) {
        auto addr = load->getOperand(0);
        if(auto elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(addr) ) {
          auto idx = elemPtr->getOperand(1);
          if(elemPtr->getNumIndices() == 2) idx = elemPtr->getOperand(2);
          if(isValueInSubExpr(N, idx))
            unsupported = 3;
        }
      }
    }
  }
}

// ==============================================================================

void aggr_llvm_diff::peel_cloned_function(llvm::Function* diff_fun) {
  // Get param N and entry block
  N = &(*diff_fun->arg_begin());
  entry_bb = &diff_fun->getEntryBlock();

  // Create N-1 instruction and add before terminator of entry
  llvm::Instruction* term = entry_bb->getTerminator();
  if(!term) tiler_error("Difference::", "Entry block does not have unique term inst");
  llvm::Value* one = llvm::ConstantInt::get(N->getType(), 1);
  llvm::Instruction *NS = llvm::BinaryOperator::Create(llvm::Instruction::Sub, N, one, "NS");
  NS->insertBefore(term);

  // For all loops replace i with N-1, remove phi inst of i and remove back edge
  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    loopList.push_back(L);
    loopdata* ld = ld_map.at(L);
    for( const bb* b: ld->blocks) {
      llvm::WeakTrackingVH &c_b = fn_vmap[b];
      bb* clonedBB;
      if ((clonedBB = llvm::dyn_cast<llvm::BasicBlock>(c_b))) {
        // Casting successful
      } else {
        tiler_error("Difference::", "Casting of the loop block failed");
      }
      ld->cloned_blocks.push_back(clonedBB);
      ld->blocks_to_cloned_map[b] = clonedBB;  // add to map
    }

    // Replace i with N-1
    llvm::Value* c_ctr = fn_vmap[ld->ctr];
    ld->VMap[c_ctr] = NS;
    llvm::remapInstructionsInBlocks(to_small_vec(ld->cloned_blocks), ld->VMap);  //  remaps instructions
    ld->VMap.clear();

    // Remove phi inst of i
    if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(c_ctr)) {
      I->eraseFromParent();
    }

    // Remove the back edge
    remove_loop_back_edge_in_clone(L, ld);
  }

  //  Remap values and metadata in the function; crashing; not needed
  //  llvm::RemapFunction(*diff_fun, fn_vmap);
}

void aggr_llvm_diff::
remove_loop_back_edge_in_clone (llvm::Loop* L, loopdata* ld) {
  bb* exit_block = NULL;
  bb* header = L->getHeader();
  bb* latch = L->getLoopLatch();
  llvm::WeakTrackingVH &c_h = fn_vmap[header];
  llvm::WeakTrackingVH &c_l = fn_vmap[latch];
  bb* c_header;
  bb* c_latch;
  if ((c_header = llvm::dyn_cast<llvm::BasicBlock>(c_h))) {
    // Casting successful
  } else {
    tiler_error("Difference::", "Casting of header block failed");
  }
  if ((c_latch = llvm::dyn_cast<llvm::BasicBlock>(c_l))) {
    // Casting successful
  } else {
    tiler_error("Difference::", "Casting of latch block failed");
  }
  llvm::Instruction* c_term = c_latch->getTerminator();
  if (llvm::BranchInst* c_bi = llvm::dyn_cast<llvm::BranchInst>(c_term)) {
    const int NumS = c_bi->getNumSuccessors();
    for(int i=0; i<NumS; i++) {
      bb* s = c_bi->getSuccessor(i);
      if(s != c_header) {
        exit_block = s;
      }
    }
    for(int i=0; i<NumS; i++) {
      bb* c_s = c_bi->getSuccessor(i);
      if(c_s == c_header) {
        c_bi->setSuccessor(i, exit_block);
      }
    }
  }
}

bool aggr_llvm_diff::loop_cloning( llvm::Function &f ) {
  //First parameter to the function is N
  N = &(*f.arg_begin());
  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    loopList.push_back(L);
  }
  //  std::sort(loopList.begin(), loopList.end(), cmp_loop_by_line_num);
  llvm::Function* diff_fun = create_diff_function(f);
  for(llvm::Loop *L : loopList) {
    process(L, ld_map.at(L), diff_fun);
  }
  return false;
}

llvm::Function* aggr_llvm_diff::create_diff_function( llvm::Function &f ) {
  llvm::ValueToValueMapTy VMap;
  static int call_count = 1;
  std::string funName = f.getName().str() + "_diff_" + std::to_string(call_count);
  llvm::FunctionType *FT = f.getFunctionType();
  llvm::Function * diff_fun = llvm::Function::Create(FT, llvm::GlobalValue::ExternalLinkage, funName, module.get());
  diff_fun->setCallingConv(llvm::CallingConv::C);
  // creating a dummy block before cloning the entry block since it crashes without it
  entry_bb = llvm::BasicBlock::Create(o.globalContext, "entry", diff_fun);
  entry_bb = llvm::CloneBasicBlock(&f.getEntryBlock(), VMap, "entry", diff_fun);
  call_count++;
  return diff_fun;
}

void aggr_llvm_diff::
process(llvm::Loop *L, loopdata *ld, llvm::Function* diff_fun) {
  clone_loop_blocks(L, ld, diff_fun);
  rewire_cloned_loop_blocks(L, ld);
  peel_and_remap_loop_inst(L, ld);
  identify_interfering_writes(L, ld);
  if(!ld->interfering_loops.empty()) {
  }
}

void aggr_llvm_diff::
clone_loop_blocks(llvm::Loop *L, loopdata *ld, llvm::Function* diff_fun) {
  if (!L->getExitingBlock()    ||
      !L->getUniqueExitBlock() ||
      L->getLoopLatch() != L->getExitingBlock())
    tiler_error("Difference::", "Loop does not have a unique exiting latch");
  for( const bb* b: ld->blocks) {
    bb * clonedBB = llvm::CloneBasicBlock(b, ld->VMap, "", diff_fun);
    ld->cloned_blocks.push_back(clonedBB);
    ld->blocks_to_cloned_map[b] = clonedBB;  // add to map
  }
}

void aggr_llvm_diff::
peel_and_remap_loop_inst(llvm::Loop *L, loopdata *ld) {
  llvm::Value* one = llvm::ConstantInt::get(N->getType(), 1);
  llvm::Instruction *NS = llvm::BinaryOperator::Create(llvm::Instruction::Sub, N, one, "NS");
  llvm::SmallVector<llvm::BasicBlock*,20> bbVec;
  for( bb* clonedBB : ld->cloned_blocks) {
    bbVec.push_back(clonedBB);
  }
  llvm::remapInstructionsInBlocks(bbVec, ld->VMap);  //  remaps instructions
  llvm::Value* c_ctr = ld->VMap.lookup(ld->ctr);
  if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(c_ctr)) {
    NS->insertAfter(I);
  }
  ld->VMap[c_ctr] = NS;
  llvm::remapInstructionsInBlocks(bbVec, ld->VMap);  //  remaps instructions
  if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(c_ctr)) {
    I->eraseFromParent();
  }
}

void aggr_llvm_diff::
rewire_cloned_loop_blocks(llvm::Loop *L, loopdata *ld) {
  for( bb* b: ld->cloned_blocks) {
    llvm::Instruction* term = b->getTerminator();
    if(!term) tiler_error("Difference::", "Loop does not have unique term inst");
    if (llvm::BranchInst *bi = llvm::dyn_cast<llvm::BranchInst>(term)) {
      const int NS = bi->getNumSuccessors();
      for(int i=0; i<NS; i++) {
        bb* s = bi->getSuccessor(i);
        bb* cs = ld->blocks_to_cloned_map[s];
        if(cs) {
          bi->setSuccessor(i, cs);
        } else {}
      }
    } else {}
  }
  bb* header = L->getHeader();
  bb* latch = L->getLoopLatch();
  bb* c_header = ld->blocks_to_cloned_map.at(header);
  bb* c_latch = ld->blocks_to_cloned_map.at(latch);
  bb* exit_block = NULL;
  llvm::Instruction* term = latch->getTerminator();
  if (llvm::BranchInst *bi = llvm::dyn_cast<llvm::BranchInst>(term)) {
    const int NS = bi->getNumSuccessors();
    for(int i=0; i<NS; i++) {
      bb* s = bi->getSuccessor(i);
      if(s != header) {
        // bi->setSuccessor(i, c_header);
        exit_block = s;
      }
    }
  }
  llvm::Instruction* c_term = c_latch->getTerminator();
  if (llvm::BranchInst *c_bi = llvm::dyn_cast<llvm::BranchInst>(c_term)) {
    const int NS = c_bi->getNumSuccessors();
    for(int i=0; i<NS; i++) {
      bb* c_s = c_bi->getSuccessor(i);
      if(c_s == c_header) {
        c_bi->setSuccessor(i, exit_block);
      }
    }
  }
}

void aggr_llvm_diff::
identify_interfering_writes(llvm::Loop *currL, loopdata* ld) {
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator rbit = ld->arrRead.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator reit = ld->arrRead.end();
  for (; rbit!=reit; rbit++) {
    bool skip = true;
    bool found = false;
    std::list<llvm::Loop*>::reverse_iterator lbit=loopList.rbegin();
    std::list<llvm::Loop*>::reverse_iterator leit=loopList.rend();
    for(; lbit!=leit; lbit++) {
      llvm::Loop* L = *lbit;
      if(currL != NULL) {
        if(skip && L != currL )
          continue;
        if(L == currL) {
          skip = false;
          continue;
        }
      } else { return; }
      assert(L);
      loopdata* wrld = NULL;
      if( ld_map.find(L) != ld_map.end() )
        wrld = ld_map.at(L);
      else
        tiler_error("Difference::",
                    "Didn't find loop data for the incoming value");
      assert(wrld);
      if(wrld->arrWrite.count(rbit->first) > 0) {
        if( auto alloca = llvm::dyn_cast<llvm::AllocaInst>(rbit->first) ) {
          if(alloca->isStaticAlloca()) {
            ld->interfering_loops[rbit->first] = L;
            found = true;
            break;
          } else if (checkRangeOverlap(ld->readTile.at(rbit->first),
                                       wrld->writeTile.at(rbit->first))) {
            ld->interfering_loops[rbit->first] = L;
            found = true;
            break;
          } else {} // Are there other cases ??
        } else {} // Do nothing
      } else {} // Do nothing
    }
    if(!found) {
      ld->interfering_loops[rbit->first] = NULL;
    } else {} // Found the loop
  }
}

void aggr_llvm_diff::
compute_local_diff_value(llvm::Loop *currL, loopdata* ld) {
  //  llvm::AllocaInst* arrAlloca = NULL;
  //  llvm::StoreInst* arrStore = NULL;
  // Currently handling a single write in the loop
  // TODO: Extend to multiple writes
  if(ld->arrWrite.size() != 1) return;
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator bit = ld->arrWrite.begin();
  std::list<llvm::Value*> wl = bit->second;
  if(wl.size() != 1) return;
  //  arrAlloca = llvm::dyn_cast<llvm::AllocaInst>(&(*(bit->first)));
  //  arrStore = llvm::dyn_cast<llvm::StoreInst>(wl.front());
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator rbit = ld->arrRead.begin();
  std::map<llvm::Value*,std::list<llvm::Value*>>::iterator reit = ld->arrRead.end();
  for (; rbit!=reit; rbit++) {
    if(&(*(rbit->first)) == &(*(bit->first))) continue;
    if(ld->interfering_loops.count(rbit->first) > 0) {
      llvm::Loop* int_loop = ld->interfering_loops.at(rbit->first);
      loopdata* int_ld = ld_map.at(int_loop);
      // Don't compute diff for constant assignments
      if(int_ld->arrRead.size() == 0 ||
         local_diff_map.size() == 0) {
        std::list<llvm::Value*> rl = rbit->second;
        for(llvm::Value* v : rl) {
          local_diff_map[bit->first].push_back(v);
        }
      } else {
        std::map<llvm::Value*,std::list<llvm::Value*>>::iterator int_rbit =
          int_ld->arrRead.begin();
        std::map<llvm::Value*,std::list<llvm::Value*>>::iterator int_reit =
          int_ld->arrRead.end();
        for (; int_rbit!=int_reit; int_rbit++) {
          if(int_rbit->first == rbit->first) continue;
          std::list<llvm::Value*> int_rl = int_rbit->second;
          // Diff currently requires there be a single read corresponding
          // to an array that was aggregated into the written array
          if(int_rl.size() != 1) return;
          // llvm::AllocaInst* diffal = llvm::dyn_cast<llvm::AllocaInst>(&(*(int_rbit->first)));
          // llvm::LoadInst* diffload = llvm::dyn_cast<llvm::LoadInst>(*int_rl.begin());
          // update_cfg( arrAlloca, arrStore, diffal, diffload, ld, int_ld, currL );
        }
      }
    } else {}
  }
}

void aggr_llvm_diff::
update_cfg(llvm::AllocaInst* wral, llvm::StoreInst* wrstore,
           llvm::AllocaInst* diffal, llvm::LoadInst* diffload,
           loopdata* ld, loopdata* int_ld, llvm::Loop* L) {
  llvm::Function *f = L->getHeader()->getParent();
  llvm::LLVMContext& context = f->getContext();
  if(wral->isStaticAlloca()) {
  } else {
    llvm::BasicBlock *allocbb = wrstore->getParent();
    llvm::Value* Z = llvm::ConstantInt::get(llvm::Type::getInt64Ty(context), 0);
    llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "loop", f, allocbb);
    llvm::IRBuilder<> builder(block);
    llvm::PHINode *pnode = builder.CreatePHI(llvm::IntegerType::getInt64Ty(context), 0, "__T_ind");
    pnode->addIncoming( Z, allocbb);
  }
}
// ==============================================================================

llvm::StringRef aggr_llvm_diff::getPassName() const {
  return "Computes the peel of the program along with the diff by applying aggregation algo";
}

void aggr_llvm_diff::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  //TODO: ...
  // au.addRequired<llvm::Analysis>();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
