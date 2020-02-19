#ifndef IRTOZ3EXPR_RANGES_H
#define IRTOZ3EXPR_RANGES_H

#include "irtoz3expr.h"

class irtoz3expr_ranges : public irtoz3expr
{
public:
  irtoz3expr_ranges( z3::context& c_,
                     value_expr_map& def_map_,
                     std::map< const llvm::Value*, std::string >& lMap,
                     std::map<std::string, llvm::Value*>& evMap,
                    glb_model& g_model_)
    : irtoz3expr(c_, def_map_, lMap, evMap, g_model_) { }

  llvm::Loop *L;

  void setLoop(llvm::Loop *inpL);
  void findCntrRange();
  virtual std::list<z3::expr> getZ3Expr (llvm::Value *V);
  virtual std::list<z3::expr> getZ3Expr (llvm::Instruction *I);
  virtual std::list<z3::expr> getZ3Expr (llvm::Constant *C);
  virtual std::list<z3::expr> getZ3Expr (llvm::BinaryOperator *bop);
  virtual std::list<z3::expr> getZ3Expr (llvm::ICmpInst *icmp) override;
  virtual std::list<z3::expr> getZ3Expr (llvm::PHINode *phi) override;
};

#endif
