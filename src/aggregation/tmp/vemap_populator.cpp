#include "vemap_populator.h"

char params_populator::ID = 0;

bool params_populator::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }
  // Add z3 symbol for the params into the map
  for( auto ab = f.arg_begin(), ae = f.arg_end(); ab != ae; ab++) {
    params.get_term( &(*ab) );
  }
  return false;
}

llvm::StringRef params_populator::getPassName() const {
  return "Creates a z3 symbol for the params of the function";
}

void params_populator::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
}

// -------------------------------------------------------------------------------------------------

char aggr_map_populator::ID = 0;

bool aggr_map_populator::runOnLoop(llvm::Loop *L, llvm::LPPassManager &LPM) {
  aggregation_maps* ag = new aggregation_maps(z3_ctx);
  ag->L = L;
  auto pair = std::make_pair(L, ag);
  aggr_map.insert(pair);

  return false; // did not modify the loop
}

bool aggr_map_populator::doInitialization(llvm::Loop *L, llvm::LPPassManager &LPM) {
  return false; // did not modify the loop
}

bool aggr_map_populator::doFinalization() {
  return false; // did not modify the loop
}

llvm::StringRef aggr_map_populator::getPassName() const {
  return "Create z3 symbols for the values in all the loops for the aggregation algorithm";
}

void aggr_map_populator::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
}
