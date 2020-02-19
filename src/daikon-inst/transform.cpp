#include "transform.h"

char transform::ID = 0;

transform::transform(std::unique_ptr<llvm::Module>& m,
                     options& o_, z3::context& z3_,
                     value_expr_map& def_map_,
                     std::map<llvm::Loop*, loopdata*>& ldm,
                     name_map& lMap,
                     std::map<std::string, llvm::Value*>& evMap)
  : llvm::FunctionPass(ID)
  , module(m)
  , o(o_)
  , z3context(z3_)
  , def_map(def_map_)
  , ld_map(ldm)
  , localNameMap(lMap)
  , exprValMap(evMap)
  , g_model(z3_)
{
  //  DBuilder = new llvm::DIBuilder(*module);
  //  CU = DBuilder->createCompileUnit(llvm::dwarf::DW_LANG_C, fileName, dirName, "", 0, "", 0);
  //  Unit = DBuilder->createFile(fileName, dirName);
  printf_func = printf_prototype(module.get(), o.globalContext);
  ir2e = new irtoz3expr_index(z3context, def_map, localNameMap, exprValMap, g_model);
}

transform::~transform() {
  //  DBuilder->finalize();
}

bool transform::removeAssumeStmt( llvm::Function &f ) {
  glbPreExprs.clear();
  for( auto bbit = f.begin(), end = f.end(); bbit != end; bbit++ ) {
    llvm::BasicBlock* bb = &(*bbit);
    for( auto it = bb->begin(), e = bb->end(); it != e; ++it) {
      llvm::Instruction *I = &(*it);
      if( auto call = llvm::dyn_cast<llvm::CallInst>(I) ) {
        if(llvm::isa<llvm::DbgValueInst>(I) ||llvm::isa<llvm::DbgDeclareInst>(I)){
          // Ignore debug instructions
        }else{
          llvm::Value * val = call->getCalledValue();
          if( auto CE = llvm::dyn_cast<llvm::ConstantExpr>(val) ) {
            if(CE->isCast()) {
              if(CE->getOperand(0)->getName() == "assume" ||
                  CE->getOperand(0)->getName() == "_Z6assumeb") {
                //Get Z3 expr for the parameter and conjunct it with the formula
                // std::list<z3::expr> l = getZ3ExprForIndex(call->getArgOperand(0), NULL);
                ir2e->setLoop(NULL);
                std::list<z3::expr> l = ir2e->getZ3Expr(call->getArgOperand(0));
                for(z3::expr e : l) {
                  glbPreExprs.push_back(e);
                }
                std::cout << "\nRemoving the assume call\n";
                it = I->eraseFromParent();
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

bool transform::removeAssertStmt( llvm::Loop* L ) {
  for( auto bb: L->getBlocks() ) {
    for( auto it = bb->begin(), e = bb->end(); it != e; ++it) {
      llvm::Instruction *I = &(*it);
      if( auto call = llvm::dyn_cast<llvm::CallInst>(I) ) {
        if(llvm::isa<llvm::DbgValueInst>(I) ||llvm::isa<llvm::DbgDeclareInst>(I)){
          // Ignore debug instructions
        }else{
          llvm::Value * val = call->getCalledValue();
          if( auto CE = llvm::dyn_cast<llvm::ConstantExpr>(val) ) {
            if(CE->isCast()) {
              if(CE->getOperand(0)->getName() == "assert") {
//                std::cout << "\nRemoving the assert call\n";
                it = I->eraseFromParent();
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

void transform::search_loops_for_access_expressions( ) {
  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    //    llvm::Loop *L = llvm::dyn_cast<llvm::Loop>(*I);
    //    std::cout << L << "\n";
    loopList.push_back(L);
    assertNonNesting(L);
    //    std::cout << "\n\n Generating ranges for the current loop \n\n";
    setRangesForLoop(L);
  }
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    if(removeAssertStmt(L)) {
      continue;
    }
    //populateLoopCntr(L);
    loopCntr.push_back(ld_map.at(L)->ctrZ3Expr);
    std::list<z3::expr> l = def_map.get_expr_list();
    l.sort(z3::eq);
    l.unique(z3::eq);
    for(auto l_ex : l) {
      nonIndParams.push_back(l_ex);
    }
    //    std::cout << "\n\n Searching loop access expressions \n\n";
    search_loop_for_access_expressions(L);
    adjustWrRdInd();
    //    std::cout << "\n\n Inserting function calls and defs for Daikon \n\n";
    insertFuncCallNDef(L);
    //    std::cout << "\n\n Generating Tile for the current loop \n\n";
    generateTileFromSrcExp(L);
    clearDSforDaikon();
  }
}

void transform::search_loop_for_access_expressions( llvm::Loop* L ) {
  std::list<z3::expr> indList;
  std::list<z3::expr>* l = NULL;
  for( auto b: L->getBlocks() ) {
    for( llvm::Instruction& Iobj : b->getInstList() ) {
      llvm::Instruction* I = &(Iobj);
      if( auto load = llvm::dyn_cast<llvm::LoadInst>(I) ) {
//        std::cout << "\nFound a Load Inst \n";
        auto val = load->getOperand(0);
        if( auto elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(val) ) {
          auto arry = elemPtr->getPointerOperand();
          l = rdInd.at(arry);
          if(l!=NULL) {
            for(z3::expr e : indList) {
              l->push_back(e);
            }
          }
          l = allArrInd.at(arry);
        }
      } else if( auto store = llvm::dyn_cast<llvm::StoreInst>(I) ) {
//        std::cout << "\nFound a Store Inst \n";
        auto val = store->getOperand(1);
        if( auto elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(val) ) {
          auto arry = elemPtr->getPointerOperand();
          l = wrInd.at(arry);
          if(l!=NULL) {
            for(z3::expr e : indList) {
              l->push_back(e);
            }
          }
          l = allArrInd.at(arry);
        }
      } else if( auto elemPtr = llvm::dyn_cast<llvm::GetElementPtrInst>(I) ) {
//        std::cout << "\nFound a GEP of previous Load/Store Inst \n";
        assert(elemPtr->getNumIndices() == 1);
        auto arry = elemPtr->getPointerOperand();
        auto idx = elemPtr->getOperand(1);
        if(elemPtr->getNumIndices() == 2) idx = elemPtr->getOperand(2);
        if( arrays_seen.find( arry) != arrays_seen.end() ) {
          if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(idx)) {
            ir2e->setLoop(L);
            indList = ir2e->getZ3Expr(I);
            //            indList = getZ3ExprForIndex(I, L);
          }
        }
      }
      if(l!=NULL) {
        for(z3::expr e : indList) {
          l->push_back(e);
        }
        indList.clear();
        l=NULL;
      }
    }
  }
}

std::list<std::string> transform::getArgNamesList() {
  std::list<std::string> argNamesList;
  std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
  for (it=allArrInd.begin(); it!=allArrInd.end(); it++) {
    std::list<z3::expr>* l = it->second;
    l->sort(z3::eq);
    l->unique(z3::eq);
    for(auto e = l->begin(); e!=l->end(); e++) {
      std::string argName = localNameMap.at(it->first) + "_OB_"
                    + getExprNameStrForDaikon(*e) + "_CB_";
      argNamesList.push_back(argName);
//      std::cout << "\nParam name : " << argName << "\n";
    }
  }
  nonIndParams.sort(z3::eq);
  nonIndParams.unique(z3::eq);
  for(z3::expr e : nonIndParams) {
    argNamesList.push_back(getExprNameStrForDaikon(e));
  }
  return argNamesList;
}

std::string transform::getExprNameStrForDaikon(z3::expr e) {
  if(e.is_numeral()) {
    int64_t num;
    if (Z3_get_numeral_int64(e.ctx(), e, &num)) {
      if (num < 0) {
        return "_U_" + std::to_string(abs(num));
      } else {
        return std::to_string(num);
      }
    }
  } else if (e.is_var()) {
    return e.decl().name().str();
  } else if (e.is_app()) {
    return getNameStrForDaikon(e);
  } else if (e.is_quantifier()) {
    tiler_error("transform::", "encountered a quantifier");
  }
  return "";
}

std::string transform::getNameStrForDaikon(z3::expr e) {
  std::list<std::string> argStrList;

  unsigned args = e.num_args();
  for (unsigned i = 0; i<args; i++)
  {
    z3::expr arg = e.arg(i);
    argStrList.push_back(getExprNameStrForDaikon(arg));
  }

  Z3_decl_kind dk = e.decl().decl_kind();
  std::list<std::string>::const_iterator argListIt;
  argListIt = argStrList.begin();

  if (dk == Z3_OP_MUL) {
    std::string res = *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + "_M_" + *argListIt;
    }
    return res;
  } else if (dk == Z3_OP_ADD) {
    std::string res = *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + "_P_" + *argListIt;
    }
    return res;
  } else if (dk == Z3_OP_SUB) {
    std::string res = *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + "_S_" + *argListIt;
    }
    return res;
  } else if (dk == Z3_OP_DIV) {
    std::string res = *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + "_D_" + *argListIt;
    }
    return res;
  } else if (dk == Z3_OP_REM) {
    std::string res = *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + "_R_" + *argListIt;
    }
    return res;
  } else if (dk == Z3_OP_UMINUS) {
    std::string res = "_U_" + *argListIt;
    return res;
  } else {
    return e.decl().name().str();
  }
}

void transform::insertFuncCallNDef(llvm::Loop *L) {
  std::string funcName = getFuncNameForDaikon(L);
  insertFuncDef(funcName);
  insertFuncCall(funcName, L);
}

void transform::insertFuncDef(std::string fName) {
  std::list<std::string> argNamesList = getArgNamesList();

  //  llvm::SmallVector<llvm::Metadata *, 8> EltTys;
  //  llvm::DIType *intTyDeb = DBuilder->createBasicType("int", 64, 64, llvm::dwarf::DW_ATE_signed);
  llvm::IntegerType *intTy = llvm::IntegerType::getInt64Ty(module->getContext());
  std::vector<llvm::Type*> args;
  for(unsigned i=0; i<argNamesList.size(); i++) {
    args.push_back(intTy);
    //    EltTys.push_back(intTyDeb);
  }
  llvm::FunctionType *FT =
    llvm::FunctionType::get(llvm::Type::getVoidTy(module->getContext()), args, false);

  llvm::Function *F = module->getFunction(fName);
  if(!F) {
    F = llvm::Function::Create(FT, llvm::GlobalValue::ExternalLinkage, fName, module.get());
    F->setCallingConv(llvm::CallingConv::C);
    F->setAttributes(attr);

    //    llvm::DIScope *FContext = CU;
    //    llvm::DISubroutineType *ST = DBuilder->createSubroutineType(DBuilder->getOrCreateTypeArray(EltTys));
    //    llvm::DISubprogram *SP = DBuilder->createFunction(
    //      FContext, fName, llvm::StringRef(), Unit, 0, ST,
    //      false /* internal linkage */, true /* definition */, 0,
    //  llvm::DINode::FlagPrototyped, false);
    // F->setSubprogram(SP);

    llvm::BasicBlock* block = llvm::BasicBlock::Create(F->getContext(), "entry", F);
    llvm::IRBuilder<> builder(block);
    //    builder.SetCurrentDebugLocation(llvm::DebugLoc::get(1, 1, FContext));

    //    unsigned ArgIdx = 0;
    for( llvm::Function::arg_iterator ab = F->arg_begin(), ae = F->arg_end(); ab != ae; ab++) {
      std::string argNameStr = argNamesList.front();
//      std::cout << "\nSetting param name to " << argNameStr;
      llvm::Value* x = &*ab;
      x->setName(argNameStr);

      // Create a debug descriptor for the variable.
      //      llvm::DILocalVariable *D = DBuilder->createParameterVariable(
      //          SP, argNameStr, ++ArgIdx, Unit, 0, intTyDeb, true);
      //      DBuilder->insertDeclare(x, D, DBuilder->createExpression(),
      //                              llvm::DebugLoc::get(1, 1, SP),
      //                              builder.GetInsertBlock());
      argNamesList.pop_front();
    }
    assert(argNamesList.empty());

    genTracePrintStmts(builder, F);
    builder.CreateRetVoid();
    //    auto ret = builder.CreateRetVoid();
    //    builder.SetCurrentDebugLocation(llvm::DebugLoc::get(1, 1, SP));
    //    builder.SetInstDebugLocation(ret);
  }
}

void transform::genTracePrintStmts(llvm::IRBuilder<> &builder, llvm::Function *F) {
    insertHeaderPrintStmts(builder);
    insertDeclInfoPrintStmts(builder, F, true);
    insertDeclInfoPrintStmts(builder, F, false);

    insertFuncNamePrintStmt(builder, F, true);

    for( llvm::Function::arg_iterator ab = F->arg_begin(), ae = F->arg_end(); ab != ae; ab++) {
      llvm::Value* x = &*ab;
      insertVarPrintStmts(builder, x);
    }

    insertFuncNamePrintStmt(builder, F, false);

    for( llvm::Function::arg_iterator ab = F->arg_begin(), ae = F->arg_end(); ab != ae; ab++) {
      llvm::Value* x = &*ab;
      insertVarPrintStmts(builder, x);
    }
}

void transform::insertHeaderPrintStmts(llvm::IRBuilder<> &builder) {
  std::string header = "\ninput-language C/C++\ndecl-version 2.0\n\n";
  insertPrintfCall(builder, header.c_str());
}

void transform::insertDeclInfoPrintStmts(llvm::IRBuilder<> &builder, llvm::Function *F, bool isEntry) {
  std::string ppt = "\nppt .." + F->getName().str();
  if(isEntry)  ppt += ":::ENTER\n";
  else         ppt += ":::EXIT0\n";
  insertPrintfCall(builder, ppt.c_str());

  std::string ppttype = "  ppt-type ";
  if(isEntry)  ppttype += "enter\n";
  else         ppttype += "subexit\n";
  insertPrintfCall(builder, ppttype.c_str());

  for( llvm::Function::arg_iterator ab = F->arg_begin(), ae = F->arg_end(); ab != ae; ab++) {
    llvm::Value* x = &*ab;
    std::string var = "  variable " + x->getName().str() + "\n";
    insertPrintfCall(builder, var.c_str());
    std::string vartype = "    var-kind variable\n    rep-type int\n    dec-type int\n    flags is_param\n";
    insertPrintfCall(builder, vartype.c_str());
  }
}

void transform::insertFuncNamePrintStmt(llvm::IRBuilder<> &builder, llvm::Function *F, bool isEntry) {
  if(isEntry) {
    std::string funcName = "\n.." + F->getName().str() + ":::ENTER\n";
    insertPrintfCall(builder, funcName.c_str());
  } else {
    std::string funcName = "\n.." + F->getName().str() + ":::EXIT0\n";
    insertPrintfCall(builder, funcName.c_str());
  }
}

void transform::insertVarPrintStmts(llvm::IRBuilder<> &builder, llvm::Value *x) {
  std::string var = x->getName().str() + "\n";
  insertPrintfCall(builder, var.c_str());

  llvm::SmallVector<llvm::Value*,2> argsVec;
  argsVec.push_back(geti8StrVal(*module, "%d\n", "format",o.globalContext));
  argsVec.push_back( x );
  //  llvm::CallInst *I = builder.CreateCall(printf_func, argsVec);
  builder.CreateCall(printf_func, argsVec);

  std::string one= "1\n";
  insertPrintfCall(builder, one.c_str());
}

void transform::insertPrintfCall(llvm::IRBuilder<> &builder, const char * str) {
  builder.CreateCall(printf_func, geti8StrVal(*module, str, "str", o.globalContext));
}

void transform::insertFuncCall(std::string fName, llvm::Loop *L) {
  llvm::Function *callf = module->getFunction(fName);
  if(!callf) {
    tiler_error("transform::", "Calling a function having no definition");
  } else {
    llvm::IRBuilder<> builder(L->getLoopLatch()->getFirstNonPHI());
    std::vector<llvm::Value*> args;
    //    if( !callf->getArgumentList().empty() )
    if(callf->arg_begin() != callf->arg_end())
    {
      std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
      for (it=allArrInd.begin(); it!=allArrInd.end(); it++) {
        std::list<z3::expr>* l = it->second;
        for(auto e = l->begin(); e!=l->end(); e++) {
          args.push_back(getArrValueFromZ3Expr(it->first, *e, builder,
                                               module->getContext(),
                                               exprValMap, arrays_seen));
        }
      }
      for(z3::expr e : nonIndParams) {
        args.push_back(getValueFromZ3Expr(e, builder,
                                          module->getContext(),
                                          exprValMap, arrays_seen));
      }
    }
    builder.CreateCall(callf, args);
  }
}

void transform::setRangesForLoop(llvm::Loop *L) {
  rangeExpr[L] = new std::list<z3::expr>();
  std::list<z3::expr>* rangeExprL = rangeExpr.at(L);
//  std::cout << "\nInside set ranges for loop.\n";
  z3::expr loopVar = ld_map.at(L)->ctrZ3Expr;
  z3::expr lowerBnd = ld_map.at(L)->initBound;
  z3::expr upperBnd = ld_map.at(L)->exitBound;
  if(ld_map.at(L)->stepCnt > 0) {
    rangeExprL->push_back(lowerBnd <= loopVar && loopVar <= upperBnd );
  } else {
    rangeExprL->push_back(lowerBnd >= loopVar && loopVar >= upperBnd );
  }
/*  llvm::BasicBlock* h = L->getHeader();
  if (llvm::BranchInst *bi = llvm::dyn_cast<llvm::BranchInst>(h->getTerminator())) {
    llvm::Value *loopCond = bi->getCondition();

    std::list<z3::expr> initExprL;
    if( llvm::ICmpInst* icmp = llvm::dyn_cast<llvm::ICmpInst>(loopCond) ) {
      auto op0 = icmp->getOperand(0);
      auto op1 = icmp->getOperand(1);
      llvm::PHINode* phi = NULL;
      if( llvm::PHINode* phi0 = llvm::dyn_cast<llvm::PHINode>(op0) ) {
        phi = phi0;
      } else if( llvm::PHINode* phi1 = llvm::dyn_cast<llvm::PHINode>(op1) ) {
        phi = phi1;
      } else {
        tiler_error("transform::","loop condition of unsupported format");
      }

      bool isIncr = false;
      z3::expr loopVar(z3context);
      llvm::Value *initExprVal = NULL;
      if( phi->getType()->isIntegerTy() ) {
        unsigned num = phi->getNumIncomingValues();
        for ( unsigned i = 0 ; i < num ; i++ ) {
          llvm::Value *v = phi->getIncomingValue(i);
          if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(v)) {
            if(isInLatch(I, L)) {
              std::string instName = localNameMap.at(v);
              loopVar = z3context.int_const(instName.c_str());
              isIncr = isIncrOp(v);
            } else {
              initExprVal = v;
            }
          } else if( llvm::dyn_cast<llvm::ConstantInt>(v) ) {
            //            std::cout << "\n\nConstant initialization in Phi\n\n";
            initExprVal = v;
          } else {
            tiler_error("transform::","unsupported structure in phi node");
          }
        }
      }

      //      for(z3::expr e : getZ3ExprForIndex(initExprVal, L)) {
      ir2e->setLoop(L);
      for(z3::expr e : ir2e->getZ3Expr(initExprVal)) {
        if(isIncr) {
          initExprL.push_back(loopVar >= e);
        } else {
          initExprL.push_back(loopVar <= e);
        }
      }
    }

    ir2e->setLoop(L);
    std::list<z3::expr> condExprL = ir2e->getZ3Expr(loopCond);
    //    std::list<z3::expr> condExprL = getZ3ExprForIndex(loopCond, L);

    for(z3::expr e1 : initExprL) {
      for(z3::expr e2 : condExprL) {
        rangeExprL->push_back(e1 && e2);
      }
    }
    }*/
}

void transform::generateTileFromSrcExp(llvm::Loop *L) {
  std::string loopFuncName = getFuncNameForDaikon(L);
  const std::list<z3::expr> &tileExprList = getRefinedMinMaxTiles(L);
  std::string fileName = loopFuncName + ".tile";
  printTileToFile(fileName, tileExprList);
  const std::list<z3::expr> &rdTileExprList = getRefinedMinMaxReadTiles(L);
  std::string rdFileName = loopFuncName + ".rdtile";
  printTileToFile(rdFileName, rdTileExprList);
}

void transform::printTileToFile(std::string fileName, const std::list<z3::expr>& tileExprList) {
  FILE *invsout;
  if ((invsout = fopen(fileName.c_str(), "w")) == NULL) {
    tiler_error("transform::", "Unable to open the invariants file");
  }
  for(z3::expr e : tileExprList) {
    fputs(display(e).c_str(), invsout);
    fputs("\n", invsout);
  }
  if (invsout!= NULL) { fclose(invsout); }
}

std::list<z3::expr> transform::getRefinedMinMaxReadTiles(llvm::Loop *L) {
  std::list<z3::expr> tileExprList;
  std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
  for (it=rdInd.begin(); it!=rdInd.end(); it++) {
    std::string arrStr = localNameMap.at(it->first);
    std::list<z3::expr>* l = it->second;
    if(!l->empty()) {
      l->sort(z3::eq);
      l->unique(z3::eq);

      //      std::cout << "\n\n Getting min-max read tile for the array " << arrStr << "\n\n";
      z3::expr refined = getTileExprFromList(arrStr, l, false, true, L);
      //      std::cout << "\n\n Checking Read Tile Overlap \n\n";
      bool refine = true;
      while( refine && !l->empty() ) {
        //        std::cout << "\n\n Refining Read Tile \n\n";
        refineList(arrStr, refined, l, true, L);
        refined = getTileExprFromList(arrStr, l, false, true, L);
        //        std::cout << "\n\n Checking Read Tile Overlap \n\n";
        refine = checkOverlap(arrStr, refined, true);
      }
//      std::cout << "Pushing the read expr\n" << refined << "\n";
      tileExprList.push_back(refined);
    }
  }
  return tileExprList;
}

std::list<z3::expr> transform::getRefinedMinMaxTiles(llvm::Loop *L) {
  std::list<z3::expr> tileExprList;
  std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
  for (it=wrInd.begin(); it!=wrInd.end(); it++) {
    std::string arrStr = localNameMap.at(it->first);
    std::list<z3::expr>* l = it->second;
    if(!l->empty()) {
      l->sort(z3::eq);
      l->unique(z3::eq);

      //      std::cout << "\n\n Getting min-max write tile for the array " << arrStr << "\n\n";
      z3::expr refined = getTileExprFromList(arrStr, l, false, false, L);
      //      std::cout << "\n\n Checking Write Tile Overlap \n\n";
      bool refine = true;
      while( refine && !l->empty() ) {
        //        std::cout << "\n\n Refining Write Tile \n\n";
        refineList(arrStr, refined, l, false, L);
        refined = getTileExprFromList(arrStr, l, false, false, L);
        //        std::cout << "\n\n Checking Write Tile Overlap \n\n";
        refine = checkOverlap(arrStr, refined, false);
      }
      if(!l->empty()) {
        z3::expr frcExpr = getTileExprFromList(arrStr, l, true, false, L);
        if(!checkRelevantRange(frcExpr)) {
          // std::cout << "\n\n Pushing the expr\n" << refined << "\n\n";
        } else {
          // std::cout << "\n\n Relevant Range check failed for the tile\n" << frcExpr << "\n\n";
          tiler_error("transform::", "Relevant Range check failed for the tile");
        }
        tileExprList.push_back(refined);
      }
    }
  }
  return tileExprList;
}

z3::expr transform::getTileExprFromList(std::string arrStr,
                                        std::list<z3::expr> *l,
                                        bool isRRC, bool isRd,
                                        llvm::Loop *L) {
  std::string lbName;
  std::string ubName;
  //std::string jpName = "j_"+arrStr+"_p";
  std::string jpName;

  if(isRd) {
    lbName = "__lbp_"+arrStr;
    ubName = "__ubp_"+arrStr;
    jpName = "prevind_p";
  } else {
    lbName = "__lb_"+arrStr;
    ubName = "__ub_"+arrStr;
    jpName = "loopind_p";
  }
  z3::expr lbVar = z3context.int_const(lbName.c_str());
  z3::expr ubVar = z3context.int_const(ubName.c_str());
  z3::expr jpVar = z3context.int_const(jpName.c_str());

  z3::expr lbandexp(z3context);
  z3::expr ubandexp(z3context);
  z3::expr lborexp(z3context);
  z3::expr uborexp(z3context);
  int cnt = 0;
  for(auto e = l->begin(); e!=l->end(); e++) {
    if(cnt == 0) {
      lbandexp = (lbVar <= *e);
      ubandexp = (ubVar >= *e);
      lborexp = (lbVar >= *e);
      uborexp = (ubVar <= *e);
    } else {
      lbandexp = lbandexp && (lbVar <= *e);
      ubandexp = ubandexp && (ubVar >= *e);
      lborexp = lborexp || (lbVar >= *e);
      uborexp = uborexp || (ubVar <= *e);
    }
    cnt++;
  }

  if(cnt !=0 ) {
    z3::expr lbexp(z3context);
    z3::expr ubexp(z3context);
    lbexp = lbandexp && lborexp;
    ubexp = ubandexp && uborexp;
    z3::expr e = lbexp && ubexp;
    if(isRRC) {
      z3::expr impl(z3context);
      z3::expr fall_exp(z3context);
      z3::expr ext_j(z3context);
      z3::expr ubfa = exists(ubVar, e && !((lbVar <= jpVar) && (ubVar >= jpVar)));
      z3::expr lbfa = exists(lbVar, ubfa);
      std::list<z3::expr> exprList1;
      if(L != NULL) {
        exprList1 = *rangeExpr.at(L);
      }
      if(exprList1.empty()) {
        impl = lbfa;
      } else {
        cnt=0;
        for(z3::expr rangeE : exprList1) {
          if(cnt==0) {
            impl = implies(rangeE, lbfa);
          } else {
            impl = implies(rangeE, impl);
          }
          cnt++;
        }
      }
      cnt=0;
      for(z3::expr i : loopCntr) {
        if(cnt==0) {
          fall_exp = forall(i, impl);
        } else {
          fall_exp = forall(i, fall_exp);
        }
        cnt++;
      }
      std::list<z3::expr> exprList2;
      llvm::Loop* nxtL = getNextLoop(loopList, L);
      if(nxtL != NULL) {
        exprList2 = *rangeExpr.at(nxtL);
      } else {
        exprList2 = *rangeExpr.at(L);
      }
      z3::expr_vector isrc(z3context);
      z3::expr_vector idst(z3context);
      for(z3::expr i : loopCntr) {
        isrc.push_back(i);
        idst.push_back(jpVar);
      }
      if(exprList2.empty()) {
        ext_j = fall_exp;
      } else {
        cnt=0;
        for(z3::expr tRangeE : exprList2) {
          z3::expr rangeE = tRangeE.substitute(isrc, idst);
          std::cout << rangeE;
          if(cnt==0) {
            ext_j = rangeE && fall_exp;
          } else {
            ext_j = rangeE && ext_j;
          }
          cnt++;
        }
      }
      e = ext_j;
    } else {
      e = e && (lbVar <= jpVar) && (ubVar >= jpVar);
    }
    return e;
  } else {
    std::cout << "No index expressions for tile generation";
    return (lbVar <= jpVar) && (ubVar >= jpVar);
  }
}

void transform::refineList(std::string arrStr, z3::expr e,
                           std::list<z3::expr> *l, bool isRd,
                           llvm::Loop *L) {
  z3::expr_vector ipsrc(z3context);
  z3::expr_vector ipdst(z3context);

  std::string lbName;
  std::string ubName;
  if(isRd) {
    lbName = "__lbp_"+arrStr;
    ubName = "__ubp_"+arrStr;
  } else {
    lbName = "__lb_"+arrStr;
    ubName = "__ub_"+arrStr;
  }
  z3::expr lb = z3context.int_const(lbName.c_str());
  z3::expr ub = z3context.int_const(ubName.c_str());

  std::string lbpName = lbName+"_p";
  z3::expr lbp = z3context.int_const(lbpName.c_str());
  std::string ubpName = ubName+"_p";
  z3::expr ubp = z3context.int_const(ubpName.c_str());

  ipsrc.push_back(ub);
  ipsrc.push_back(lb);
  ipdst.push_back(ubp);
  ipdst.push_back(lbp);

  int cnt=0;
  z3::expr ineqip(z3context);
  loopCntr.sort(z3::eq);
  loopCntr.unique(z3::eq);
  z3::expr k = z3context.int_const("__T_k");
  for(z3::expr i : loopCntr) {
    ipsrc.push_back(i);
    if(ld_map.at(L)->stepCnt > 0) {
      ipdst.push_back(i+k);
    } else {
      ipdst.push_back(i-k);
    }
    cnt++;
  }

  auto it = l->begin();
  while( it !=l->end() ) {
    z3::expr sub_e = e.substitute(ipsrc, ipdst);
    z3::expr ex = *it;
    z3::solver s(z3context);
    s.add(e);
    s.add(sub_e);
    s.add(k>0);
    s.add(lb <= ex && ex <= ub && lbp <= ex && ex <= ubp);
    if (s.check() == z3::sat) {
      it = l->erase(it);
      e = getTileExprFromList(arrStr, l, false, isRd, L);
    } else {
      it++;
    }
  }
}

bool transform::checkOverlap(std::string arrStr, z3::expr e, bool isRd) {
  z3::expr_vector ipsrc(z3context);
  z3::expr_vector ipdst(z3context);

  std::string lbName;
  std::string ubName;
  if(isRd) {
    lbName = "__lbp_"+arrStr;
    ubName = "__ubp_"+arrStr;
  } else {
    lbName = "__lb_"+arrStr;
    ubName = "__ub_"+arrStr;
  }
  z3::expr lb = z3context.int_const(lbName.c_str());
  z3::expr ub = z3context.int_const(ubName.c_str());

  std::string lbpName = lbName+"_p";
  z3::expr lbp = z3context.int_const(lbpName.c_str());
  std::string ubpName = ubName+"_p";
  z3::expr ubp = z3context.int_const(ubpName.c_str());

  ipsrc.push_back(ub);
  ipsrc.push_back(lb);
  ipdst.push_back(ubp);
  ipdst.push_back(lbp);

  int cnt=0;
  z3::expr ineqip(z3context);
  loopCntr.sort(z3::eq);
  loopCntr.unique(z3::eq);
  for(z3::expr i : loopCntr) {
    ipsrc.push_back(i);
    std::string ipStr = "__T_i_" + std::to_string(cnt);
    z3::expr ip = z3context.int_const(ipStr.c_str());
    ipdst.push_back(ip);
    if(cnt == 0) {
      ineqip = (ip >= i + 1 || i >= ip + 1);
    } else {
      ineqip = ineqip && (ip >= i + 1 || i >= ip + 1);
    }
    cnt++;
  }
  z3::expr sub_e = e.substitute(ipsrc, ipdst);

  z3::solver s(z3context);
  s.add(e);
  s.add(sub_e);
  s.add(ineqip);
  if (s.check() == z3::sat) {
    std::cout << "\n\n Overlap \n\n";
//    std::cout << "\nSolver contents of overlapping tile\n" << s << "\n";
    return true;
  } else {
    std::cout << "\n\n No overlap \n\n";
    return false;
  }
}

bool transform::checkRelevantRange(z3::expr e) {
  z3::solver s(z3context);
  for(z3::expr e1 : glbPreExprs)
    s.add(e1);
  s.add(e);
  if (s.check() == z3::sat) {
    std::cout << "\n\n FAILED: Range check \n\n";
    // std::cout << "\nRelevant Range check solver contents\n" << s << "\n";
    return true;
  } else {
    std::cout << "\n\n Range check passed \n\n";
    // std::cout << "\nRelevant Range check solver contents\n" << s << "\n";
    return false;
  }
}

void transform::
collect_arrays( llvm::Function &f ) {
  arrays_seen.clear();
  for( auto bbit = f.begin(), end = f.end(); bbit != end; bbit++ ) {
    llvm::BasicBlock* bb = &(*bbit);
    for( llvm::Instruction& Iobj : bb->getInstList() ) {
      llvm::Instruction* I = &(Iobj);
      if( auto alloc = llvm::dyn_cast<llvm::AllocaInst>(I) ) {
        if( alloc->isArrayAllocation() &&
            !alloc->getType()->getElementType()->isIntegerTy() ) {
          tiler_error( "transform::", "only pointers to intergers is allowed!" );
        }
        arrays_seen.insert( alloc );
        allArrInd[alloc] = new std::list<z3::expr>();
        rdInd[alloc] = new std::list<z3::expr>();
        wrInd[alloc] = new std::list<z3::expr>();
      }
    }
  }
}

void transform::initArrays(llvm::Function &f) {
  llvm::LLVMContext& context = f.getContext();

  for( auto arrAllocInst : arrays_seen ) {
    //Split the block after array allocation by adding a no-op inst
    llvm::Instruction *arrAlloc = llvm::dyn_cast<llvm::Instruction>(arrAllocInst);
    llvm::BasicBlock *allocbb = arrAlloc->getParent();
    llvm::Value* Z = llvm::ConstantInt::get(llvm::Type::getInt64Ty(context), 0);
    llvm::Instruction *I = llvm::BinaryOperator::Create(llvm::Instruction::Add, Z, Z, "no-op");
    I->insertAfter(arrAlloc);
    llvm::BasicBlock* b1 = allocbb->splitBasicBlock(I);
    I->eraseFromParent();

    //Create a new block that initializes the array
    llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "loop", &f, b1);
    llvm::IRBuilder<> builder(block);
    llvm::PHINode *pnode = builder.CreatePHI(llvm::IntegerType::getInt64Ty(context), 0, "__T_ind");
    pnode->addIncoming( Z, allocbb);

    // Initialize array to rand + rand
    llvm::Function *rand = rand_prototype(module.get(), o.globalContext);
    llvm::Value* rand1 = builder.CreateCall(rand);
    llvm::Value* rand2 = builder.CreateCall(rand);
    llvm::Value* val = builder.CreateAdd(rand1, rand2);
    llvm::Value* gep = builder.CreateGEP(arrAllocInst, pnode);
    //    llvm::StoreInst* store = builder.CreateStore(val, gep);
    builder.CreateStore(val, gep);

    //Increment the loop counter
    llvm::Value* constOne = llvm::ConstantInt::get(context, llvm::APInt(64, 1, true));
    llvm::Value *nextVal = builder.CreateAdd(pnode, constOne, "__T_ind");
    pnode->addIncoming( nextVal, block);

    //Insert the created block between the split blocks
    allocbb->getTerminator()->setSuccessor(0, block);
    llvm::AllocaInst *inst = llvm::dyn_cast<llvm::AllocaInst>(arrAllocInst);
    llvm::Value* cond = builder.CreateICmpSLT(nextVal, inst->getArraySize(), "i<size");
    //    llvm::BranchInst* br = builder.CreateCondBr(cond, block, b1);
    builder.CreateCondBr(cond, block, b1);
  }
}


bool transform::runOnFunction( llvm::Function &f ) {

  if(attr.isEmpty() && !f.getAttributes().isEmpty()) {
     attr = f.getAttributes();
  }

  //  buildNameMap(f, localNameMap);
  collect_arrays(f);
  removeAssumeStmt(f);
  search_loops_for_access_expressions( );
  initToRand(f);
  initArrays(f);

  return true;
}

void transform::initToRand(llvm::Function &f) {
  llvm::BasicBlock* eb = &(f.getEntryBlock());
  for( auto I = eb->begin(), E = eb->end(); I != E; ++I) {
    assert( &(*I) );
    if( auto store = llvm::dyn_cast<llvm::StoreInst>(&(*I)) ) {
      llvm::Value* val = store->getOperand(0);
      if( llvm::isa<llvm::Constant>(val) ) {
        if( llvm::isa<llvm::UndefValue>(val) ) {
          llvm::Constant *c = module->getOrInsertFunction("rand",
              llvm::FunctionType::getInt64Ty(f.getContext()));
          llvm::Function *rand= llvm::cast<llvm::Function>(c);
          llvm::IRBuilder<> builder(&(*I));
          llvm::Value* newval = builder.CreateCall(rand);
          llvm::Value* remval = builder.CreateSRem(newval,
              llvm::ConstantInt::get(f.getContext(), llvm::APInt(32, 20, true)) );
          store->setOperand(0,remval);
        }
      }
    }
  }
}

void transform::adjustWrRdInd() {
  std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
  for (it=allArrInd.begin(); it!=allArrInd.end(); it++) {
    std::list<z3::expr>* allIndL = it->second;
    if(allIndL->empty()) {
      std::map<llvm::Value*,std::list<z3::expr>*>::iterator writ;
      for (writ=wrInd.begin(); writ!=wrInd.end(); writ++) {
        std::list<z3::expr>* wrl = writ->second;
        for(z3::expr e : *wrl)
          allIndL->push_back(e);
      }
      std::map<llvm::Value*,std::list<z3::expr>*>::iterator rit;
      for (rit=rdInd.begin(); rit!=rdInd.end(); rit++) {
        std::list<z3::expr>* rl = rit->second;
        for(z3::expr e : *rl)
          allIndL->push_back(e);
      }
    }
    llvm::Value* arr = it->first;
    std::list<z3::expr>* l = wrInd.at(arr);
    if(l->empty()) {
      std::list<z3::expr>* rl = rdInd.at(arr);
      for(z3::expr e : *rl)
        l->push_back(e);
    }
  }
}

void transform::clearDSforDaikon() {
  std::map<llvm::Value*,std::list<z3::expr>*>::iterator it;
  for (it=allArrInd.begin(); it!=allArrInd.end(); it++) {
    std::list<z3::expr>* l = it->second;
    l->clear();
  }
  for (it=rdInd.begin(); it!=rdInd.end(); it++) {
    std::list<z3::expr>* l = it->second;
    l->clear();
  }
  for (it=wrInd.begin(); it!=wrInd.end(); it++) {
    std::list<z3::expr>* l = it->second;
    l->clear();
  }
  nonIndParams.clear();
  loopCntr.clear();
}

llvm::StringRef transform::getPassName() const {
  return "Instruments the program for invariant generation using Daikon";
}

void transform::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  //TODO: ...
  // au.addRequired<llvm::Analysis>();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
