#include "daikon-inst/comments.h" //todo: move to utils

void src_loc::dump() { print(std::cerr); }

void src_loc::print(std::ostream& o ) {
  o << line << " "<< col << " "<< file<< "\n";
}

void comment::dump() { print(std::cerr); }

void comment::print(std::ostream& o ) {
  o << "------\nComment:\n";
  start.print( o );
  end.print( o );
  o << text << "\n------";
}

z3::expr comment::to_z3_expr( z3::context z3_ctx, rev_name_map& n_map ) {
  std::string type_decls;
  for( auto& name_pair : n_map ) {
    auto name = name_pair.first;
    auto* v = name_pair.second;
    std::string ty_str;
    if( auto glb = llvm::dyn_cast<llvm::GlobalVariable>(v) ) {
      llvm::Type* ty = glb->getType();
      if( auto pty = llvm::dyn_cast<llvm::PointerType>(ty) ) {
        auto el_ty = pty->getElementType();
        z3::sort z_sort = llvm_to_z3_sort(z3_ctx, el_ty);
        ty_str = to_string(z_sort);
      }else{ tiler_error( "parse comment::", "unrecognized type!"); }
    }else{
      llvm::Type* ty = v->getType();
      if( auto pty = llvm::dyn_cast<llvm::PointerType>(ty) ) {
        auto el_ty = pty->getElementType();
        z3::sort z_sort = llvm_to_z3_sort(z3_ctx, el_ty);
        ty_str = to_string( z3_ctx.array_sort( z3_ctx.int_sort(), z_sort ) );
      }else{
        z3::sort z_sort = llvm_to_z3_sort(z3_ctx, ty);
        ty_str = to_string(z_sort);
      }
    }
    type_decls = type_decls + "(declare-fun " + name + " () " + ty_str +")\n";
    type_decls =
      type_decls + "(declare-fun __pre_" + name + " () " + ty_str +")\n";
  }
  type_decls = type_decls + text;
  z3::expr_vector es = z3_ctx.parse_string( type_decls.c_str() );
  assert( es.size() == 1 );
  z3::expr e = es[0];
}
