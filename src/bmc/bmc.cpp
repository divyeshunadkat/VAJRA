#include "bmc.h"
#include "bmc/bmc_fun_pass.h"
#include "bmc/bmc_fun_pre_comp_pass.h"
#include "bmc/bmc_loop_pass.h"
#include "bmc_utils.h"
#include "witness.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// pragam'ed to aviod warnings due to llvm included files
#include "llvm/Transforms/IPO/AlwaysInliner.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Analysis/CFGPrinter.h"
#pragma GCC diagnostic pop

void bmc::run_bmc_pass() {
  llvm::legacy::PassManager passMan;
  passMan.add( new build_name_map(o, def_map, localNameMap, exprValMap,
                                  revStartLocalNameMap,
                                  revEndLocalNameMap ) );
  passMan.add( new collect_fun_blocks(z3_ctx, o, ld_map) );
  passMan.add( new collect_loopdata(z3_ctx, o, def_map, ld_map, localNameMap,
                                    exprValMap, module, g_model) );

  if(o.loop_aggr) {
    passMan.add( new bmc_loop_pass(o,z3_ctx, def_map, *this));
  } else {
    passMan.add( new bmc_fun_pass(o, z3_ctx, def_map, *this));
  }
  passMan.run( *module.get() );
}

void bmc::collect_aggr_pass() {
  llvm::legacy::PassManager passMan;
  passMan.add( new build_name_map( o, def_map, localNameMap, exprValMap,
                                   revStartLocalNameMap,
                                   revEndLocalNameMap ) );
  passMan.add( new collect_fun_blocks(z3_ctx, o, ld_map) );
  passMan.add( new collect_loopdata( z3_ctx, o, def_map, ld_map, localNameMap,
                                     exprValMap, module, g_model) );
  passMan.add( new bmc_aggr_pass(o, z3_ctx, def_map, *this) );
  passMan.run( *module.get() );
}

void bmc::collect_bmc_ds_pass() {
  llvm::legacy::PassManager passMan;
  passMan.add( new bmc_fun_pre_comp_pass(o, z3_ctx, *this) );
  passMan.run( *module.get() );
}

void bmc::collect_rev_name_map_pass() {
  llvm::legacy::PassManager passMan;
  passMan.add(new build_name_map(o, def_map, localNameMap, exprValMap,
                                 revStartLocalNameMap, revEndLocalNameMap));
  passMan.run( *module.get() );
}

std::map< const llvm::Function*, bmc_fun*>& bmc::get_func_formula_map() {
  return func_formula_map;
}

std::map< const llvm::Loop*, bmc_loop*>& bmc::get_loop_formula_map() {
  return loop_formula_map;
}

std::map< const llvm::Loop*, bmc_ds_aggr*>& bmc::get_loop_aggr_map() {
  return aggr_map;
}

void bmc::init_glb() {

  glb_state glb_st = populate_glb_state();

  for (auto fit=module->begin(), endit=module->end(); fit!=endit; ++fit) {
    llvm::StringRef fname = fit->getName();
    if(fname == o.funcName) {
      // g_model.set_state( &fit->getEntryBlock(), glb_st );
      g_model.set_state( 0, glb_st );
    }else{
      // declare all non entry functions can be inlined
      if( !fit->isDeclaration() ) // function have a body available
        fit->addFnAttr(llvm::Attribute::AlwaysInline);
    }
  }
}

glb_state bmc::populate_glb_state() {
  glb_state glb_st;
  auto& vec = glb_st.get_glb_name_vec();

  int glbCntr = 0;
  for( auto iter_glb= module->global_begin(),end_glb = module->global_end();
       iter_glb != end_glb; ++iter_glb ) {

    llvm::GlobalVariable* glb = &*iter_glb; //3.8
    llvm::Type* ty = glb->getType();
    //const std::string gvar = (std::string)(glb->getName());

    if( auto pty = llvm::dyn_cast<llvm::PointerType>(ty) ) {
      assert(pty);
      auto el_ty = pty->getElementType();
      assert(el_ty);

      if(el_ty->isArrayTy()) continue;

      g_model.insert_glb_to_id(glb, glbCntr);
      g_model.insert_name_to_glb(glb->getName().str() ,glb);

      z3::sort z_sort = llvm_to_z3_sort(z3_ctx, el_ty);
      g_model.insert_glb_sort( z_sort );

      auto new_glb = g_model.get_fresh_glb_name(glbCntr, glb->getName());
      vec.push_back(new_glb);

      if( glb->hasUniqueInitializer() ) {
        auto c = glb->getInitializer();
        // auto val = get_term( z3_ctx, c, m );
        auto val = read_const( c, z3_ctx );
        glb_bmc_vec.push_back(new_glb == val);
      } else {} // do nothing
    } else {
      tiler_error("bmc", (std::string)(glb->getName()) << " not a global pointer!");
    }
    glbCntr++;
  }
  return glb_st;
}

void bmc::check_all_spec(bmc_ds* bmc_ds_ptr) {
  for(z3::expr e : bmc_ds_ptr->spec_vec) {
    if(run_solver(e, bmc_ds_ptr)) {
      std::cout << "\nSpecification that failed the check : \n" << e;
      std::cout << "\n\nTILER_BMC_VERIFICATION_FAILED\n\n";
      return;
    } else { } // contine with other specifications
  }
  std::cout << "\n\nTILER_BMC_VERIFICATION_SUCCESSFUL\n\n";
}

bool bmc::run_solver(z3::expr &spec, bmc_ds* bmc_ds_ptr) {
  z3::solver s(z3_ctx);
  for(z3::expr e : bmc_ds_ptr->bmc_vec) {
    s.add(e);
  }
  s.add(!spec);
  if (s.check() == z3::sat) {
    if(o.verbosity > 4) {
      z3::model m = s.get_model();
      produce_witness(m, bmc_ds_ptr);
    }
    return true;
  } else {
    return false;
  }
}

bool bmc::run_solver(z3::expr &spec, std::vector<z3::expr>& bmc_vec) {
  z3::solver s(z3_ctx);
  for(z3::expr e : bmc_vec) {
    s.add(e);
  }
  s.add(!spec);
  if (s.check() == z3::sat) {
    z3::model m = s.get_model();
    std::cout << m;
    return true;
  } else {
    return false;
  }
}

std::string
bmc::get_val_for_instruction( const llvm::Instruction* I, z3::model& mdl,
                              std::map<std::string,std::string>& state,
                              bmc_ds* bmc_ds_ptr, unsigned call_count ) {
  std::string v;
  unsigned copy_count = 0;
  auto val = bmc_ds_ptr->m.read_term( I, copy_count );
  if( val ) {
    // auto it = bmc_ds_ptr->m.find( {I,copy_count} );
    // if( it != bmc_ds_ptr->m.end() ) {
    //   auto val = mdl.eval( it->second );
    // std::cout << val << "\n";
    v = to_string( val );
    auto it_d = bmc_ds_ptr->dbg_name_map.find( I );
    if( it_d != bmc_ds_ptr->dbg_name_map.end() ) {
      std::string vname = it_d->second;
      state[vname] = v;
      v = vname + " = " + v;
    }
  }
  return v;
}

std::string state_to_string( std::map<std::string,std::string>& state ) {
  std::string s = "["; bool first = true;
  for( auto& pair : state ) {
    if( first ) {
      first = false;
    }else{
      s = s + ", ";
    }
    s = s + "\"" + pair.first + " = " + pair.second  + "\"";
  }
  return s+"]";
}

void bmc::produce_witness_call( z3::model mdl, const llvm::CallInst* call ) {
  assert(call);
  if( ignore_special_functions( call ) ) return;
  if( llvm::cast<llvm::IntrinsicInst>(call) ) {
    // ignore
  }else if( ignore_special_functions( call ) ) {
    // ignore
  }else{
    llvm::Function* fp = call->getCalledFunction();
    if( fp != NULL ) {
      bmc_fun* called_fun = func_formula_map[call->getCalledFunction()];
      assert(called_fun && "Called function is null in produce witness");
      unsigned call_count = called_fun->get_call_count( call );
      produce_witness( mdl, called_fun, call_count );
    }else{
      tiler_error( "bmc", "unknown function called" );
    }
  }
}

void bmc::produce_witness( z3::model mdl, bmc_ds* bmc_ds_ptr,
                           unsigned call_count ) {
  witness w(o);
  std::map<std::string,std::string> state;
  unsigned bidx =0;
  for( auto b : bmc_ds_ptr->bb_vec ) {
    z3::expr path_bit = bmc_ds_ptr->get_path_bit(bidx);
    // z3::expr path_bit = bmc_ds_ptr->block_to_path_bit.at(b);
    if( is_true( path_bit, mdl ) ) {
      if( o.verbosity > 6 ) {
        std::cout << "-------------------------------------------\n";
        std::cout << "dumping block:" << getLocRange( b ) << "\n";
      }
      for( const llvm::Instruction& Iobj : b->getInstList() ) {
        const llvm::Instruction* I = &(Iobj);
        if( auto call = llvm::dyn_cast<llvm::CallInst>(I) ) {
          produce_witness_call( mdl, call );
        }
        // if( bmc_ds_ptr->m.find({I,0}) == bmc_ds_ptr->m.end() ) continue;
        if( bmc_ds_ptr->m.read_term( I, 0 ) ) {} else continue;
        auto val = get_val_for_instruction( I, mdl, state, bmc_ds_ptr, call_count );
        std::string s = state_to_string( state );
        auto loc = getLoc(I);
        w.add( loc, val, s, bidx, 0 );
        if( o.verbosity > 6 ) {
          I->print( llvm::outs() );
          if( val != "" ) std::cout << "~~~~~~>" << val << "|";
          std::cout << getLocation(I);
          std::cout << "\n";
        }
      }
      // b->print( llvm::outs() );
    }
    bidx++;
  }
  // w.show_path();
  w.generate_html();
}
