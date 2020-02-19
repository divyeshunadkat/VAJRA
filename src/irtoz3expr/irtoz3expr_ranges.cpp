#include "irtoz3expr/irtoz3expr_ranges.h"

void irtoz3expr_ranges::setLoop(llvm::Loop *inpL) {
  L = inpL;
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::Value *V) {
  return irtoz3expr::getZ3Expr(V);
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::Instruction *I) {
  return irtoz3expr::getZ3Expr(I);
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::Constant *C) {
  return irtoz3expr::getZ3Expr(C);
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::ICmpInst *icmp) {
  return irtoz3expr::getZ3Expr(icmp);
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::BinaryOperator *bop) {
  return irtoz3expr::getZ3Expr(bop);
}

std::list<z3::expr> irtoz3expr_ranges::getZ3Expr (llvm::PHINode *phi) {
  return irtoz3expr::getZ3Expr(phi);
}

//Depricated
void irtoz3expr_ranges::findCntrRange() {
  llvm::BasicBlock* h = L->getHeader();
  auto t = h->getTerminator();
  if (llvm::BranchInst *bi = llvm::dyn_cast<llvm::BranchInst>(t)) {
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
        tiler_error("irtoz3expr_ranges::","loop condition of unsupported format");
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
            // std::cout << "\n\nConstant initialization in Phi\n\n";
            initExprVal = v;
          } else {
            tiler_error("irtoz3expr_ranges::","unsupported structure in phi node");
          }
        }
      }

      for(z3::expr e : getZ3Expr(initExprVal)) {
        if(isIncr) {
          initExprL.push_back(loopVar >= e);
        } else {
          initExprL.push_back(loopVar <= e);
        }
      }
    } else {
      tiler_error("irtoz3expr_ranges::", "unsupported comparision in loop condition");
    }
    std::list<z3::expr> condExprL = getZ3Expr(loopCond);
  } else {
    tiler_error("irtoz3expr_ranges::", "Terminator not a branch instrunction!");
  }
}
