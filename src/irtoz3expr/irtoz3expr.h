#ifndef IRTOZ3EXPR_H
#define IRTOZ3EXPR_H

#include "utils/llvmUtils.h"
#include "utils/z3Utils.h"
#include "bmc/glb_model.h"

class irtoz3expr
{
public:
  irtoz3expr( z3::context& c_,
              value_expr_map& def_map_,
              std::map< const llvm::Value*, std::string >& lMap,
              std::map<std::string, llvm::Value*>& evMap,
              glb_model& g_model_)
    : z3context(c_)
    , def_map(def_map_)
    , localNameMap(lMap)
    , exprValMap(evMap)
    , g_model(g_model_)
  {}

  z3::context& z3context;
  value_expr_map& def_map;
  std::map< const llvm::Value*, std::string >& localNameMap;
  std::map<std::string, llvm::Value*>& exprValMap;
  glb_model g_model;

  virtual std::list<z3::expr> getZ3Expr (llvm::Value *V);
  virtual std::list<z3::expr> getZ3Expr (llvm::Instruction *I);
  virtual std::list<z3::expr> getZ3Expr (llvm::Constant *C);
  virtual std::list<z3::expr> getZ3Expr (llvm::BinaryOperator *bop);
  virtual std::list<z3::expr> getZ3Expr (llvm::ICmpInst *icmp);
  virtual std::list<z3::expr> getZ3Expr (llvm::PHINode *phi);
};

#endif
