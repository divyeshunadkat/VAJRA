git = git -c user.name="Auto" -c user.email="auto@auto.com" 

PROJECT=vajra
BUILDDIR = $(HOME)/verifier-build
SRCDIR = $(PWD)/src
LLVM_VERSION=6.0.0
LLVM-SRC=$(BUILDDIR)/llvm-$(LLVM_VERSION).src.tar.xz
CFE-SRC=$(BUILDDIR)/cfe-$(LLVM_VERSION).src.tar.xz
CLANG-TOOLS=$(BUILDDIR)/clang-tools-extra-$(LLVM_VERSION).src.tar.xz

all : release

.PHONY : release debug run clean patch test llvm-svn llvm-up deepclean

release : $(BUILDDIR)/buildr/Makefile
	+make -C $(BUILDDIR)/buildr
	rm -rf $(PROJECT)
	cp -f $(BUILDDIR)/buildr/$(PROJECT) $(PROJECT)

debug :  $(BUILDDIR)/buildd/Makefile
	+make -C $(BUILDDIR)/buildd
	rm -rf $(PROJECT)
	ln -s $(BUILDDIR)/buildd/$(PROJECT) $(PROJECT)

llvm-svn: export LLVM_VERSION = svn
llvm-svn: $(BUILDDIR)/buildl/Makefile
	echo "$(LLVM_VERSION)"
	+make -C $(BUILDDIR)/buildl
	rm $(PROJECT)
	ln -s $(BUILDDIR)/buildl/$(PROJECT) $(PROJECT)

$(BUILDDIR)/buildr/Makefile: $(BUILDDIR)/z3/buildr/libz3.so
	mkdir -p $(BUILDDIR)/buildr
	cd $(BUILDDIR)/buildr; cmake -DCMAKE_BUILD_TYPE=Release -DPROJECT=$(PROJECT) $(SRCDIR)

$(BUILDDIR)/buildd/Makefile: $(BUILDDIR)/z3/buildd/libz3.so $(BUILDDIR)/llvm-$(LLVM_VERSION)/lib/libLLVMCore.a
	mkdir -p $(BUILDDIR)/buildd
	cd $(BUILDDIR)/buildd; cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_VERSION=$(LLVM_VERSION) -DPROJECT=$(PROJECT) $(SRCDIR)

$(BUILDDIR)/buildl/Makefile: $(BUILDDIR)/z3/buildd/libz3.so $(BUILDDIR)/llvm-$(LLVM_VERSION)/lib/libLLVMCore.a
	mkdir -p $(BUILDDIR)/buildl
	cd $(BUILDDIR)/buildl; cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_VERSION=$(LLVM_VERSION) -DPROJECT=$(PROJECT) $(SRCDIR)

clean :
	rm -rf $(BUILDDIR)/buildr
	rm -rf $(BUILDDIR)/buildd
	rm -rf $(BUILDDIR)/buildl
	rm -f $(PROJECT)
	rm -f *.dot
	find -name "*~"| xargs rm -rf

# removes all the downloaded llvms and all the installs
deepclean: clean
	rm -rf $(BUILDDIR)/*

#-----------------------------------------------------------------------------
# Z3 fetch and patch generation

$(BUILDDIR)/z3/README.md :
	mkdir -p $(BUILDDIR)
	cd $(BUILDDIR);$(git) clone https://github.com/Z3Prover/z3.git

$(BUILDDIR)/z3/buildr/libz3.so : $(BUILDDIR)/z3/README.md
	rm -rf $(BUILDDIR)/z3/buildr
	mkdir -p $(BUILDDIR)/z3/buildr
	cd $(BUILDDIR)/z3/buildr; cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../
	+make -C $(BUILDDIR)/z3/buildr

$(BUILDDIR)/z3/buildr/libz3.a : $(BUILDDIR)/z3/buildr/libz3.so

$(BUILDDIR)/z3/buildd/libz3.so : $(BUILDDIR)/z3/README.md
	rm -rf $(BUILDDIR)/z3/buildd
	mkdir -p $(BUILDDIR)/z3/buildd
	cd $(BUILDDIR)/z3/buildd; cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug ../
	+make -C $(BUILDDIR)/z3/buildd

#---------------------------------------------------------------------------
# fetch and install local llvm with debugging enabled

#$(BUILDDIR)/llvm-$(LLVM_VERSION).src/tools/clang/tools/extra/docs/clang-modernize.rst
$(BUILDDIR)/llvm-$(LLVM_VERSION).src/LLVMBuild.txt :
	(test -f $(LLVM-SRC) || (cd $(BUILDDIR);wget --no-check-certificate https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLVM_VERSION)/llvm-$(LLVM_VERSION).src.tar.xz) || (cd $(BUILDDIR);wget --no-check-certificate http://releases.llvm.org/$(LLVM_VERSION)/llvm-$(LLVM_VERSION).src.tar.xz))
	(test -f $(CFE-SRC) || (cd $(BUILDDIR);wget --no-check-certificate https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLVM_VERSION)/cfe-$(LLVM_VERSION).src.tar.xz) || (cd $(BUILDDIR);wget --no-check-certificate http://releases.llvm.org/$(LLVM_VERSION)/cfe-$(LLVM_VERSION).src.tar.xz))
	(test -f $(CLANG-TOOLS) || (cd $(BUILDDIR);wget --no-check-certificate https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLVM_VERSION)/clang-tools-extra-$(LLVM_VERSION).src.tar.xz) || (cd $(BUILDDIR);wget --no-check-certificate http://releases.llvm.org/$(LLVM_VERSION)/clang-tools-extra-$(LLVM_VERSION).src.tar.xz))
	cd $(BUILDDIR);tar -xvJf llvm-$(LLVM_VERSION).src.tar.xz
	cd $(BUILDDIR);tar -xvJf cfe-$(LLVM_VERSION).src.tar.xz -C llvm-$(LLVM_VERSION).src/tools/; mv llvm-$(LLVM_VERSION).src/tools/cfe-$(LLVM_VERSION).src llvm-$(LLVM_VERSION).src/tools/clang
	cd $(BUILDDIR);tar -xvJf clang-tools-extra-$(LLVM_VERSION).src.tar.xz -C llvm-$(LLVM_VERSION).src/tools/clang/tools; mv llvm-$(LLVM_VERSION).src/tools/clang/tools/clang-tools-extra-$(LLVM_VERSION).src llvm-$(LLVM_VERSION).src/tools/clang/tools/extra

$(BUILDDIR)/llvm-svn.src/LLVMBuild.txt:
	cd $(BUILDDIR);svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm-svn.src
	cd $(BUILDDIR)/llvm-svn.src/tools; svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
	cd $(BUILDDIR)/llvm-svn.src/tools/clang/tools; svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
	cd $(BUILDDIR)/llvm-svn.src/projects; svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
	# cd $(BUILDDIR)/llvm-svn.src/projects; svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx


LLVM_CMAKE_OPTIONS= -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=DEBUG -DLLVM_BUILD_LLVM_DYLIB=TRUE -DLLVM_ENABLE_RTTI:BOOL=TRUE -DLLVM_ENABLE_DUMP=TRUE -DCMAKE_INSTALL_PREFIX=../../llvm-$(LLVM_VERSION) ../

$(BUILDDIR)/llvm-$(LLVM_VERSION)/lib/libLLVMCore.a : $(BUILDDIR)/llvm-$(LLVM_VERSION).src/LLVMBuild.txt
	cd $(BUILDDIR); mkdir -p llvm-$(LLVM_VERSION).src/build; mkdir -p llvm-$(LLVM_VERSION)
	cd $(BUILDDIR)/llvm-$(LLVM_VERSION).src/build;cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=DEBUG -DLLVM_BUILD_LLVM_DYLIB=TRUE -DLLVM_ENABLE_RTTI:BOOL=TRUE -DLLVM_ENABLE_DUMP=TRUE -DLLVM_ENABLE_BINDINGS=FALSE -DCMAKE_INSTALL_PREFIX=../../llvm-$(LLVM_VERSION) ../
	+make -C $(BUILDDIR)/llvm-$(LLVM_VERSION).src/build
	+make -C $(BUILDDIR)/llvm-$(LLVM_VERSION).src/build install

llvm-up: export LLVM_VERSION = svn
llvm-up:
	cd $(BUILDDIR)/llvm-svn.src; svn up
	cd $(BUILDDIR)/llvm-svn.src/tools/clang; svn up
	cd $(BUILDDIR)/llvm-svn.src/tools/clang/tools/extra; svn up
	cd $(BUILDDIR)/llvm-svn.src/projects/compiler-rt; svn up
	cd $(BUILDDIR)/llvm-svn.src/build;cmake $(LLVM_CMAKE_OPTIONS)
	+make -C $(BUILDDIR)/llvm-svn.src/build
	+make -C $(BUILDDIR)/llvm-svn.src/build install

#---------------------------------------------------------------------------
