#include "irtoz3expr/irtoz3expr.h"

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::Value *V) {
  if( llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(V) ) {
    return getZ3Expr(I);
  } else if( llvm::GlobalVariable *glb = llvm::dyn_cast<llvm::GlobalVariable>(V) ) {
    z3::expr var = g_model.get_state_var(0, glb);
    std::string instName = glb->getName().str();
    //    localNameMap[V] = instName;  // Need to put name of global in the local name map?
    std::list<z3::expr> res;
    res.push_back(var);
    exprValMap[instName]=V;
    return res;
  } else if( llvm::Constant *C = llvm::dyn_cast<llvm::Constant>(V) ) {
    return getZ3Expr(C);
  } else {
    std::string instName = localNameMap.at(V);
    //z3::expr var = z3context.int_const(instName.c_str());
    z3::expr var = def_map.get_term(V);
    std::list<z3::expr> res;
    res.push_back(var);
    exprValMap[instName]=V;
    return res;
  }
}

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::Instruction *I) {
  if( auto bop = llvm::dyn_cast<llvm::BinaryOperator>(I) ) {
    return getZ3Expr(bop);
  } else if( llvm::isa<llvm::UnaryInstruction>(I) ) {
    if( auto cast = llvm::dyn_cast<llvm::CastInst>(I) ) {
      auto v = cast->getOperand(0);
      return getZ3Expr(v);
    } else if( auto load = llvm::dyn_cast<llvm::LoadInst>(I) ) {
      auto v = load->getOperand(0);
      return getZ3Expr(v);
    } else {
      tiler_error("irtoz3expr::", "Unsupported uniary instruction!!");
    }
  } else if( llvm::PHINode* phi = llvm::dyn_cast<llvm::PHINode>(I) ) {
    return getZ3Expr(phi);
  } else if( llvm::ICmpInst* icmp = llvm::dyn_cast<llvm::ICmpInst>(I) ) {
    return getZ3Expr(icmp);
  } else if( auto call = llvm::dyn_cast<llvm::CallInst>(I) ) {
    llvm::Function* fp = call->getCalledFunction();
    if( fp != NULL && fp->getName().startswith("__VERIFIER_nondet_") ) {
      std::string instName = call->getName().str();
      localNameMap[call] = instName;
      z3::expr var = def_map.get_term(call, "N");
      std::list<z3::expr> res;
      res.push_back(var);
      exprValMap[instName]=call;
      return res;
    } else {
      tiler_error("irtoz3expr::", "Unsupported call instruction in the index expression!!");
    }
  } else {
    tiler_error("irtoz3expr::", "Unsupported instruction in the index expression!!");
  }
}

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::Constant *C) {
  std::list<z3::expr> res;
  if( const llvm::ConstantInt* c = llvm::dyn_cast<llvm::ConstantInt>(C) ) {
    unsigned bw = c->getBitWidth();
    if(bw == 16 || bw == 32 || bw == 64 ) {
      int i = *(c->getUniqueInteger().getRawData());
      // res.push_back(def_map.get_term(c));
      res.push_back(z3context.int_val(i));
      return res;
    } else {
      tiler_error( "irtoz3expr::", "unsupported bit width!!" );
    }
  } else if( llvm::UndefValue* op = llvm::dyn_cast<llvm::UndefValue>(C) ) {
    llvm::Type* ty = op->getType();
    if( auto i_ty = llvm::dyn_cast<llvm::IntegerType>(ty) ) {
      int bw = i_ty->getBitWidth();
      if(bw == 16 || bw == 32 || bw == 64 ) {
        // static unsigned count = 1;
        // std::string freshvar = "__T_tmp_" + std::to_string(count++);
        // res.push_back(z3context.int_const(freshvar.c_str()));
        z3::expr var = def_map.get_term(op);
        res.push_back(var);
        return res;
      } else {
        tiler_error("irtoz3expr::", "unsupported bit width!!");
      }
    } else {
      tiler_error("irtoz3expr::", "unsupported type: "<< ty << "!!");
    }
  } else {
    tiler_error("irtoz3expr::", "unsupported constant type!!");
  }
}

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::ICmpInst *icmp) {
  std::list<z3::expr> res;
  auto op0 = icmp->getOperand(0);
  auto op1 = icmp->getOperand(1);
  const std::list<z3::expr>& a = getZ3Expr(op0);
  const std::list<z3::expr>& b = getZ3Expr(op1);
  auto pred = icmp->getPredicate();
  switch( pred ) {
  case llvm::CmpInst::ICMP_EQ :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1==e2);
   break;
  case llvm::CmpInst::ICMP_NE :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1!=e2);
   break;
  case llvm::CmpInst::ICMP_UGT :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1>e2);
   break;
  case llvm::CmpInst::ICMP_UGE :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1>=e2);
   break;
  case llvm::CmpInst::ICMP_ULT :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1<e2);
    break;
  case llvm::CmpInst::ICMP_ULE :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1<=e2);
    break;
  case llvm::CmpInst::ICMP_SGT :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1>e2);
    break;
  case llvm::CmpInst::ICMP_SGE :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1>=e2);
    break;
  case llvm::CmpInst::ICMP_SLT :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1<e2);
    break;
  case llvm::CmpInst::ICMP_SLE :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1<=e2);
    break;
  default:
    tiler_error("irtoz3expr::", "unsupported instruction occurred!!");
  }
  return res;
}

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::BinaryOperator *bop) {
  std::list<z3::expr> res;
  auto op0 = bop->getOperand(0);
  auto op1 = bop->getOperand(1);
  const std::list<z3::expr>& a = getZ3Expr(op0);
  const std::list<z3::expr>& b = getZ3Expr(op1);
  unsigned op = bop->getOpcode();
  switch( op ) {
  case llvm::Instruction::Add :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1+e2);
   break;
  case llvm::Instruction::Sub :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1-e2);
   break;
  case llvm::Instruction::Mul :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1*e2);
   break;
  case llvm::Instruction::SDiv :
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(e1/e2);
   break;
  case llvm::Instruction::SRem:
   for(z3::expr e1 : a)
     for(z3::expr e2 : b)
       res.push_back(rem(e1,e2));
   break;
  default:
    const char* opName = bop->getOpcodeName();
    tiler_error("irtoz3expr::", "unsupported instruction \"" << opName << "\" occurred!!");
  }
  return res;
}

std::list<z3::expr> irtoz3expr::getZ3Expr (llvm::PHINode *phi) {
  std::list<z3::expr> res;
  if( phi->getType()->isIntegerTy() ) {
    unsigned num = phi->getNumIncomingValues();
    for ( unsigned i = 0 ; i < num ; i++ ) {
      llvm::Value* v = phi->getIncomingValue(i);
      if(llvm::Instruction *I = llvm::dyn_cast<llvm::Instruction>(v)) {
        const std::list<z3::expr>& l = getZ3Expr(I);
        for(z3::expr e : l) {
          res.push_back(e);
        }
      } else if( llvm::dyn_cast<llvm::ConstantInt>(v) ) {
        continue;
      } else {
        tiler_error("irtoz3expr::","unsupported construct in phi node");
      }
    }
    return res;
  } else {
    tiler_error("irtoz3expr::", "phi nodes with non integers not supported !!");
  }
}
