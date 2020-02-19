#ifndef SEGMENT_H
#define SEGMENT_H

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/LinkAllPasses.h"
#pragma GCC diagnostic pop

class loopdata;

class segment {
public:

  std::vector< llvm::BasicBlock* > entryCutPoints;
  std::vector< llvm::BasicBlock* > exitCutPoints;
  std::vector< llvm::BasicBlock* > bodyBlocks;

  std::map< llvm::BasicBlock*, std::map<std::string, llvm::Value*> > assuMapCPs;
  std::map< llvm::BasicBlock*, std::map<std::string, llvm::Value*> > assertMapCPs;

  segment() { }
  llvm::BasicBlock* getBodyBlock() { return bodyBlocks.front(); }
  llvm::BasicBlock* getEntryBlock() { return entryCutPoints.front(); }
};

#endif
