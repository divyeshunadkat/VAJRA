#include "bmc_utils.h"
#include "utils/utils.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/IR/IntrinsicInst.h"
#pragma GCC diagnostic pop

std::string get_called_name(const llvm::CallInst* call ) {
  assert( call );
  llvm::Function* fp = call->getCalledFunction();
  if( fp != NULL ) return fp->getName();
  const llvm::Value * val = call->getCalledValue();
  if( auto CE = llvm::dyn_cast<llvm::ConstantExpr>(val) ) {
    if( CE->isCast() ) {
      //todo: check if this is correct traveral of LLVM IR
      return CE->getOperand(0)->getName();
    }
  }else{
    tiler_error("bmc", "could not find the name of called function!");
  }
  return "";
}

bool is_assert(const llvm::CallInst* call ) {
  assert( call );
  auto name = get_called_name( call );
  if( name == "assert" ) return true;
  if( name == "_Z6assertb" ) return true;
  if( name == "__VERIFIER_assert" ) return true;
  return false;
}


bool is_assume(const llvm::CallInst* call) {
  assert( call );
  auto name = get_called_name( call );
  if( name == "assume" ) return true;
  if( name == "_Z6assumeb" ) return true;
  if( name == "__VERIFIER_assume" ) return true;
  return false;
}


bool is_nondet(const llvm::CallInst* call) {
  assert( call );
  auto name = get_called_name( call );
  if( name == "__VERIFIER_nondet_" ) return true;
  return false;
}

bool is_error(const llvm::CallInst* call) {
  assert( call );
  auto name = get_called_name( call );
  if( name == "__VERIFIER_error_" ) return true;
  return false;
}

bool ignore_special_functions( const llvm::CallInst* call ) {
  return is_assert( call ) || is_assume( call ) || is_nondet( call )
    || is_error(call);
}
