#include "build_name_map.h"

char build_name_map::ID = 0;

build_name_map::build_name_map( options& o_, value_expr_map& def_map_, name_map& lMap,
                                std::map<std::string, llvm::Value*>& evMap,
                                std::map< const bb*, rev_name_map >& revStartLocalNameMap_,
                                std::map< const bb*, rev_name_map >& revEndLocalNameMap_ )
  : llvm::FunctionPass(ID)
  , o(o_)
  , revStartLocalNameMap( revStartLocalNameMap_ )
  , revEndLocalNameMap( revEndLocalNameMap_ )
  , exprValMap(evMap)
  , localNameMap(lMap)
  , def_map(def_map_)
{}

build_name_map::~build_name_map() {}

bool build_name_map::runOnFunction( llvm::Function &f ) {
  buildNameMap( o, f, localNameMap);
  buildRevNameMap( f );
  buildParamExpr( f );
  return false;
}


void build_name_map::buildRevNameMap( llvm::Function &f ) {
  bb_vec_t bb_vec;
  std::map< const bb*, unsigned> block_to_id;        // useless
  std::map< const bb*, bb_set_t > loop_ignore_edges; // useless
  std::map< const bb*, bb_set_t > rev_loop_ignore_edges;
  collect_loop_backedges(this, loop_ignore_edges, rev_loop_ignore_edges);
  computeTopologicalOrder(f, rev_loop_ignore_edges, bb_vec, block_to_id);

  for( auto b : bb_vec ) {
    std::map<std::string, const llvm::Value*> start_map;
    std::set< std::string > conflicted_names;
    if( b == &f.getEntryBlock()) {
      auto module = f.getParent();
      for( auto iter_g = module->global_begin(),end_g = module->global_end();
           iter_g != end_g; ++iter_g ) {
        llvm::GlobalVariable* glb = &*iter_g;
        auto name = (std::string)(glb->getName());
        start_map[name] = glb;
      }
      // process input parameters
      for( auto ab = f.arg_begin(), ae = f.arg_end(); ab != ae; ab++) {
        llvm::Value* x = &*ab;
        std::string name = (std::string)(x->getName());
        start_map[name] = x;
      }
    }else{
      for(auto PI = llvm::pred_begin(b),E = llvm::pred_end(b);PI != E;++PI) {
        const llvm::BasicBlock* prev = *PI;
        if( exists( loop_ignore_edges, b ) ) {
          if( exists( loop_ignore_edges.at( b ), prev) ) continue;
        }
        for( auto& pair: revEndLocalNameMap.at(prev) ) {
          std::string name = pair.first;
          const llvm::Value* v = pair.second;
          if( conflicted_names.find( name ) != conflicted_names.end() )
            continue;
          if( start_map.find( name ) != start_map.end() ) {
            if( v != start_map.at(name) ) {
              conflicted_names.insert( name );
              start_map.erase(name); // not needed really
            }
          }else{
            start_map[name] = v;
          }
        }
      }
      for( auto I = b->begin(); llvm::isa<llvm::PHINode>(I); ++I ) {
        const llvm::PHINode *phi = llvm::cast<llvm::PHINode>(I);
        std::string name = localNameMap[phi];
        conflicted_names.erase(name);
        start_map[name] = phi;
      }
    }

    revStartLocalNameMap[b] = start_map;
    for( auto I = b->begin(); I != b->end(); ++I ) {
      if ( llvm::isa<llvm::PHINode>(I) ) continue;
      auto* Ip = llvm::cast<llvm::Instruction>(I);
      if( localNameMap.find(Ip) != localNameMap.end() ) {
        std::string name = localNameMap[Ip];
        if( auto* dVal = llvm::dyn_cast<llvm::DbgValueInst>(Ip) ) {
          assert( llvm::isa<llvm::Constant>( dVal->getValue() ) );
          start_map[name]  = dVal->getValue();
        }else{
          start_map[name] = Ip;
        }
        conflicted_names.erase(name);
      }
    }
    // assert( conflicted_names.empty() );
    revEndLocalNameMap[b] = start_map;
  }
}

void build_name_map::buildParamExpr( llvm::Function &f ) {
  for( auto ab = f.arg_begin(), ae = f.arg_end(); ab != ae; ab++) {
    def_map.get_term( &(*ab), (&(*ab))->getName().str() );
    exprValMap[(&(*ab))->getName().str()] = &(*ab);
  }
}

llvm::StringRef build_name_map::getPassName() const {
  return "Builds the llvm::Value to name string map for all functions";
}

void build_name_map::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
