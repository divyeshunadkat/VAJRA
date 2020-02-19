#include "collect_fun_blocks.h"

char collect_fun_blocks::ID = 0;

collect_fun_blocks::
collect_fun_blocks( z3::context& z3_, options& o_,
                    std::map<llvm::Loop*, loopdata*>& ldm)
  : llvm::FunctionPass(ID)
  , z3_ctx(z3_)
  , o(o_)
  , ld_map(ldm)
{}

bool collect_fun_blocks::runOnFunction( llvm::Function &f ) {
  if(f.getName() != o.funcName) {
    return false;
  }
  collect_nonloop_blocks(&f);
  return false;
}

void collect_fun_blocks::
collect_allloop_blocks(loopdata* ld, std::vector<llvm::BasicBlock*>& l) {
  auto &LIWP = getAnalysis<llvm::LoopInfoWrapperPass>();
  auto LI = &LIWP.getLoopInfo();
  for (auto I = LI->rbegin(), E = LI->rend(); I != E; ++I) {
    llvm::Loop *L = *I;
    assert(L);
    loopdata* chld = NULL;
    if( ld_map.find(L) == ld_map.end() ) {
      chld = new loopdata(z3_ctx);
      chld->setLoop(L);
      auto pair = std::make_pair(L, chld);
      ld_map.insert(pair);
    }else{
      chld = ld_map.at(L);
    }
    assert(chld);
    chld->setParent(ld);
    ld->addChildHead(chld);
    for(bb* b: L->getBlocks()) {
      l.push_back(b);
    }
  }
  std::sort(ld->childHeads.begin(), ld->childHeads.end(), cmp_loopdata_by_line_num);
}

void collect_fun_blocks::
collect_nonloop_blocks(llvm::Function* f) {
  loopdata* ld = new loopdata(z3_ctx);
  ld->setLoop(NULL);
  ld_map[NULL] = ld;

  std::vector<llvm::BasicBlock*> all_blocks;
  collect_allloop_blocks( ld, all_blocks );

  bool next_null=false;
  bool is_in_loop=false;
  for( auto bbit=f->begin(), end=f->end(); bbit!=end; bbit++ ) {
    llvm::BasicBlock* b = &(*bbit);
    if(next_null==true) {
      next_null=false;
      ld->blocks.push_back(NULL);
    }
    if(find(all_blocks.begin(), all_blocks.end(), b) != all_blocks.end()) {
      if(is_in_loop == false) {
        next_null=true;
      }
      is_in_loop = true;
      continue;
    } else {
      is_in_loop = false;
    }
    ld->blocks.push_back(b);
  }
}

llvm::StringRef collect_fun_blocks::getPassName() const {
  return "Creates loopdata object for the target function with \
          list of blocks having null entries for loops";
}

void collect_fun_blocks::
getAnalysisUsage(llvm::AnalysisUsage &au) const {
  au.setPreservesAll();
  au.addRequired<llvm::LoopInfoWrapperPass>();
}
