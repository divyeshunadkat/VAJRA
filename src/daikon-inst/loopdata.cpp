#include "loopdata.h"


void loopdata::
getWrittenArrays(std::vector<const llvm::AllocaInst*>& arrays_updated) {
  for(auto iter = arrWrite.begin(); iter != arrWrite.end(); ++iter) {
    if( auto g = llvm::dyn_cast<const llvm::AllocaInst>( iter->first )) {
      arrays_updated.push_back(g);
    } else {
      tiler_error("bmc loop pass", "Unsupported value in array write list");        // error
    }
    // for( llvm::Value *v : iter->second ) {
    //   if( auto a = llvm::dyn_cast<const llvm::Instruction>( v ) ) {
    //     arrays_updated.push_back(a);
    //   } else {
    //     // error
    //     tiler_error("bmc aggr pass","Unsupported value in array write list");
    //   }
    // }
  }
}

void loopdata::
getWrittenGlbs(std::vector<const llvm::GlobalVariable*>& glbs_updated) {
  for(auto iter = glbWrite.begin(); iter != glbWrite.end(); ++iter) {
    if( auto g = llvm::dyn_cast<const llvm::GlobalVariable>( iter->first )) {
      glbs_updated.push_back(g);
    } else {
      tiler_error("bmc loop pass", "Unsupported value in glbvar write list");        // error
    }
  }
}

void loopdata::setPureReadArrays() {
  bool is_written = false;
  for(auto r_iter = arrRead.begin(); r_iter != arrRead.end(); ++r_iter) {
    is_written = false;
    if( auto ar = llvm::dyn_cast<const llvm::AllocaInst>( r_iter->first )) {
      for(auto w_iter = arrWrite.begin(); w_iter != arrWrite.end(); ++w_iter) {
        if( auto aw = llvm::dyn_cast<const llvm::AllocaInst>( w_iter->first )) {
          if(aw == ar && !w_iter->second.empty()) {
            is_written = true;
            break;
          } else {} // do nothing
        } else {
          tiler_error("bmc loop pass", "Unsupported value in array write list");        // error
        }
      }
      if(!is_written) {
        arrPureRead.push_back(ar);
      } else {} // do nothing
    } else {
      tiler_error("bmc loop pass", "Unsupported value in array read list");        // error
    }
  }
}

void loopdata::setPureReadGlbs() {
  bool is_written = false;
  for(auto r_iter = glbRead.begin(); r_iter != glbRead.end(); ++r_iter) {
    is_written = false;
    if( auto gr = llvm::dyn_cast<const llvm::GlobalVariable>( r_iter->first )) {
      for(auto w_iter = glbWrite.begin(); w_iter != glbWrite.end(); ++w_iter) {
        if( auto gw = llvm::dyn_cast<const llvm::GlobalVariable>( w_iter->first )) {
          if(gw == gr && !w_iter->second.empty()) {
            is_written = true;
            break;
          } else {} // do nothing
        } else {
          tiler_error("bmc loop pass", "Unsupported value in glbvar write list");        // error
        }
      }
      if(!is_written) {
        glbPureRead.push_back(gr);
      } else {} // do nothing
    } else {
      tiler_error("bmc loop pass", "Unsupported value in glbvar read list");        // error
    }
  }
}


void loopdata::setLoop(llvm::Loop *l) {
  loop = l;
}

void loopdata::setParent(loopdata *p) {
  parent = p;
}

void loopdata::addChildHead(loopdata *ch) {
  childHeads.push_back(ch);
}

std::string loopdata::getHeadPhiName( llvm::PHINode * phi ) {
  return headPhiNameMap.at(phi);
}

void loopdata::setHeadPhiName( llvm::PHINode * phi, std::string name ) {
  headPhiNameMap[ phi ] = name;
}

void loopdata::setCtr(llvm::Value *v) {
  ctr = v;
}

void loopdata::setCtrZ3Expr(z3::expr ce) {
  ctrZ3Expr = ce;
}

void loopdata::setCtrName(std::string cn) {
  ctrName = cn;
}

void loopdata::setStepCnt(int step) {
  stepCnt = step;
}

void loopdata::setInitBound(z3::expr e) {
  initBound = e;
}

void loopdata::setExitBound(z3::expr e) {
  exitBound = e;
}

void loopdata::addNextToVec(loopdata *n) {
  next.push_back(n);
}

void loopdata::addEnterSegment(segment *s) {
  enterSegment.push_back(s);
}

void loopdata::addExitSegment(segment *s) {
  exitSegment.push_back(s);
}

void loopdata::print() {
  std::cout << "\nLoopdata pointer is : " << this << "\n";
  std::cout << "Loop pointer is : " << loop << "\n";
  std::cout << "Loop counter is : " << ctrZ3Expr << "\n";
  std::cout << "Loop init bound is : " << initBound << "\n";
  std::cout << "Loop exit bound is : " << exitBound << "\n";
  std::cout << "Loop step count is : " << stepCnt << "\n";
  std::cout << "Loop parent is : " << parent << "\n\n";

  std::map<llvm::Value*,std::list<z3::expr>>::iterator bit;

  std::cout << "Printing read index exprs\n";
  for(bit=arrReadExpr.begin(); bit!=arrReadExpr.end(); bit++) {
    std::cout << "\nArray pointer : " << bit->first <<"\n";
    for(z3::expr e : bit->second) {
      std::cout << e << "\n";
    }
  }
  std::cout << "\nPrinting written index exprs\n";
  for(bit=arrWriteExpr.begin(); bit!=arrWriteExpr.end(); bit++) {
    std::cout << "\nArray pointer : " << bit->first <<"\n";
    for(z3::expr e : bit->second) {
      std::cout << e << "\n";
    }
  }
  std::cout << "\nPrinting written index min max exprs\n";
  for(bit=writeMinMax.begin(); bit!=writeMinMax.end(); bit++) {
    std::cout << "\nArray pointer : " << bit->first <<"\n";
    for(z3::expr e : bit->second) {
      std::cout << e << "\n";
    }
  }

  std::cout << "\nPeeling direction for the loop is from : ";
  if(peel_direction_first) {
    std::cout << "first\n";
  } else {
    std::cout << "last\n";
  }
  /*std::cout << "\nPrinting blocks collected\n";
  for(auto b : blocks) {
    b->print(llvm::errs());
    }*/
  std::cout << "\nFinished printing of loop data object\n\n";
}
