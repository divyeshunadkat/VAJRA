cmake_minimum_required(VERSION 2.8.7)

project(${PROJECT})

find_package (BISON REQUIRED)
find_package(FLEX REQUIRED)

#set(CMAKE_POSITION_INDEPENDENT_CODE ON) # requires version 2.8.9

BISON_TARGET(MyParser inv2smt/inv2smt.y ${CMAKE_CURRENT_BINARY_DIR}/inv2smt.y.cpp)
FLEX_TARGET(MyScanner inv2smt/inv2smt.l  ${CMAKE_CURRENT_BINARY_DIR}/inv2smt.l.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

SET (LLVM_DEBUG FALSE CACHE BOOL "Use Locally compiled and debug enabled LLVM")
SET (Z3_DEBUG FALSE CACHE BOOL "Link debug verion of Z3")

IF(CMAKE_BUILD_TYPE MATCHES Debug)
    message("debug mode")
    SET (LLVM_DEBUG TRUE)
    SET (Z3_DEBUG TRUE)
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug)

message(STATUS "DEBUG : LLVM - ${LLVM_DEBUG}")

IF(LLVM_DEBUG)
  SET( LLVM_DIR "${PROJECT_BINARY_DIR}/../llvm-${LLVM_VERSION}")
  SET( CLANG_DIR "${PROJECT_BINARY_DIR}/../llvm-${LLVM_VERSION}")
  find_package(LLVM REQUIRED CONFIG NO_DEFAULT_PATH HINTS "${LLVM_DIR}/lib/cmake/llvm/")
  find_package(Clang REQUIRED CONFIG NO_DEFAULT_PATH HINTS "${CLANG_DIR}/lib/cmake/clang/")
ELSE(LLVM_DEBUG)
  find_package(LLVM 6.0 REQUIRED CONFIG)
  find_package(Clang REQUIRED CONFIG HINTS "/usr/lib/llvm-6.0/lib/cmake/clang")
  # find_package(Clang REQUIRED clangTooling libClang)
ENDIF(LLVM_DEBUG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "Using ClangConfig.cmake in: ${Clang_DIR}")

SET(Boost_USE_STATIC_LIBS    OFF)
SET(Boost_USE_STATIC_RUNTIME OFF)

find_package(Boost 1.68.0 COMPONENTS regex program_options system filesystem REQUIRED) 

IF(Z3_DEBUG)
  LINK_DIRECTORIES("${PROJECT_BINARY_DIR}/../z3/buildd")
ELSE(Z3_DEBUG)
  LINK_DIRECTORIES("${PROJECT_BINARY_DIR}/../z3/buildr")
ENDIF(Z3_DEBUG)

ADD_DEFINITIONS(-std=c++11 -Wall)


include_directories (${CMAKE_CURRENT_BINARY_DIR} "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}/../z3/src/api" "${PROJECT_BINARY_DIR}/../z3/src/api/c++")
include_directories(${Boost_INCLUDE_DIRS})
LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${CLANG_INCLUDE_DIRS})

#enabling lld linker
SET( CMAKE_LINKER "/usr/bin/ld.lld-6.0" )
add_definitions("-Wl,--threads -Wl,--thread-count,4")
message(STATUS "Linker In use : ${CMAKE_LINKER}")


if(LLVM_VERSION EQUAL "7.0.0svn")
  ADD_DEFINITIONS(-DLLVM_SVN)
else(LLVM_VERSION EQUAL "7.0.0svn")
endif(LLVM_VERSION EQUAL "7.0.0svn")

# unexplained guard 
if( LLVM_DEBUG )
  llvm_map_components_to_libnames(llvm_libs
    aarch64asmparser aarch64codegen
    armasmparser armcodegen
    hexagoncodegen
    mipsasmparser mipscodegen
    msp430codegen
#    msp430asmparser
    nvptxcodegen
    powerpcasmparser powerpccodegen
    sparcasmparser sparccodegen
    systemzasmparser systemzcodegen
    x86asmparser x86codegen
    xcorecodegen
    amdgpuasmparser amdgpucodegen
    bpfasmparser bpfcodegen
    lanaicodegen
    objcarcopts
#    webassemblyasmparser webassemblyasmprinter
#    webassemblycodegen
    )
endif( LLVM_DEBUG )

# message(STATUS "LLVM LIBS : ${llvm_libs}")

SET(clang_libs clangDaemon clangFrontendTool)

LINK_DIRECTORIES(${LLVM_LIBRARY_DIRS})

SET(SOURCES daikon-inst/cinput.cpp utils/llvmUtils.cpp utils/z3Utils.cpp utils/options.cpp daikon-inst/comments.cpp daikon-inst/transform.cpp daikon-inst/insert_main.cpp daikon-inst/slicedpost_check.cpp daikon-inst/loopdata.cpp daikon-inst/collect_loopdata.cpp daikon-inst/collect_fun_blocks.cpp daikon-inst/build_name_map.cpp irtoz3expr/irtoz3expr.cpp irtoz3expr/irtoz3expr_index.cpp irtoz3expr/irtoz3expr_ranges.cpp bmc/array_model.cpp bmc/glb_model.cpp bmc/bmc_pass.cpp bmc/bmc_fun_pass.cpp bmc/bmc_fun_pre_comp_pass.cpp bmc/bmc_loop_pass.cpp bmc/bmc_aggr_pass.cpp bmc/bmc_llvm_aggr.cpp bmc/witness.cpp bmc/bmc_ds.cpp bmc/bmc.cpp bmc/bmc_utils.cpp aggregation/aggregation.cpp aggregation/aggr_llvm_diff.cpp aggregation/array_ssa.cpp main.cpp ${BISON_MyParser_OUTPUTS} ${FLEX_MyScanner_OUTPUTS})

add_executable(${PROJECT} ${SOURCES})

SET(LIBZ3 z3)

target_link_libraries (${PROJECT} ${LIBZ3} ${Boost_LIBRARIES} ${llvm_libs} ${clang_libs})
