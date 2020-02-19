#include "irtoz3expr/irtoz3expr_index.h"

void irtoz3expr_index::setLoop(llvm::Loop *inpL)
{
  L = inpL;
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::Value *V) {
  return irtoz3expr::getZ3Expr(V);
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::Instruction *I) {
  return irtoz3expr::getZ3Expr(I);
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::Constant *C) {
  return irtoz3expr::getZ3Expr(C);
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::ICmpInst *icmp) {
  return irtoz3expr::getZ3Expr(icmp);
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::BinaryOperator *bop) {
  return irtoz3expr::getZ3Expr(bop);
}

std::list<z3::expr> irtoz3expr_index::getZ3Expr (llvm::PHINode *phi) {
  std::list<z3::expr> res;
  if( phi->getType()->isIntegerTy() ) {
    if( localNameMap.find(phi) != localNameMap.end() ) {
      std::string instName = localNameMap.at(phi);
      if( instName != "" ) {
        z3::expr var = def_map.get_term(phi, instName);
        res.push_back(var);
        exprValMap[instName]= phi;
      }
    }
    if( res.empty() ) {
      z3::expr var = def_map.get_term(phi);
      res.push_back(var);
    }
  } else { 
    tiler_error("irtoz3expr_index::", "phi nodes with non integers not supported !!");
  }
  return res;
}
