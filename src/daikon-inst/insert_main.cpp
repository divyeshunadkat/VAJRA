#include "insert_main.h"

char insert_main::ID = 0;

bool insert_main::runOnModule(llvm::Module &M) {
  std::string mainstr = "main";
  llvm::FunctionType *FT =
    llvm::FunctionType::get(llvm::Type::getVoidTy(M.getContext()), false);

  llvm::errs() << "Checking if function " << mainstr << " exists\n";
  llvm::Function *F = M.getFunction(mainstr);
  if(!F) {
    F = llvm::Function::Create(FT, llvm::GlobalValue::ExternalLinkage, mainstr, &M);
    F->setCallingConv(llvm::CallingConv::C);
    llvm::errs() << "Inserted " << mainstr << " function\n";
    llvm::BasicBlock* block = llvm::BasicBlock::Create(o.globalContext, "entry", F);
    llvm::IRBuilder<> builder(block);

    for (auto fit=M.begin(), endit=M.end(); fit!=endit; ++fit) {
      llvm::StringRef fname = fit->getName();
      if(fname == o.funcName) {
        llvm::Function *callf = M.getFunction(fname);
        std::vector<llvm::Value*> args;
        //	if( !callf->getArgumentList().empty() )
        if(callf->arg_begin() != callf->arg_end())
        {
          //int i;
          //for(i=0; i<callf->getArgumentList().size(); i++)
          for( auto ab = callf->arg_begin(), ae = callf->arg_end(); ab != ae; ab++)
          {
            llvm::Constant *c = M.getOrInsertFunction("rand",
                llvm::FunctionType::getInt32Ty(callf->getContext()));
            llvm::Function *rand= llvm::cast<llvm::Function>(c);
            llvm::Value* newval = builder.CreateCall(rand);
            llvm::Value* remval = builder.CreateSRem(newval,
                llvm::ConstantInt::get(callf->getContext(), llvm::APInt(32, 60, true)) );
            args.push_back(remval);
          }
        }
        builder.CreateCall(callf, args);
      }
    }
    builder.CreateRetVoid();
    return true;
  } else {
    return false;
  }
}

llvm::StringRef insert_main::getPassName() const {
  return "Adds a main function to the program for invariant generation using Daikon";
}

void insert_main::getAnalysisUsage(llvm::AnalysisUsage &au) const {
  //au.setPreservesAll();
  //TODO: ...
  // au.addRequired<llvm::Analysis>();
  //au.addRequired<llvm::LoopInfoWrapperPass>();
}

