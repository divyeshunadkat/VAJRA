%{
/*
   Usage: inv2smt [output file path] [input invariants file path] [exists vars file path] [loop index vars file path] [array names file path]
*/

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <errno.h>
  #include <math.h>
  #include <string>
  #include <list>
  #include "utils/z3Utils.h"

  int yylex (void);
  void yyerror (char *);
  //  void chomp( std::string &);
  //  int populateVars(char *, char *, char *);
  //  int invokeZ3(std::string);
  //  z3::expr convertToInt(z3::expr);
  //  z3::expr createIntExpr(z3::expr);
  //  std::string display(z3::expr);
  //  std::string display_app(z3::expr);
  std::string makeSmtStr();

  char prefixStr[4096];
  char* outputFile;
  z3::context c;
  std::string smtStr;
  std::list<z3::expr> exprList;
  std::list<std::string> identList;
  std::list<std::string> arrIdentList;
  std::list<std::string> assertList;
  std::list<std::string> existVarsList;
  //  std::list<std::string> arrList;
  //  std::list<std::string> indList;
  //  std::list<std::string> boundsList;

  FILE *fp;
  FILE *varsfp;
  
  extern FILE *yyin;
  extern FILE *yyout;
%}

%token T_PLUS_OP T_MIN_OP T_MUL_OP T_DIV_OP T_MOD_OP T_AND_OP T_OR_OP T_LE_OP T_EL_OP T_GE_OP T_EG_OP T_EQ_OP T_NE_OP T_G_OP T_L_OP T_ASS_OP T_NL T_LP T_RP T_COMMA T_L_BKT T_R_BKT 

%union {
  char *string;
}

%token <string> T_LIT
%token <string> T_IDENT

%type <string> boolexpr
%type <string> relexpr
%type <string> expr
%type <string> term
%type <string> fact
%%
program:

| program line
;

line:
  T_NL
| boolexpr T_NL  { 
  if(!existVarsList.empty())
  {
    sprintf(prefixStr, "%s\n", $1);
    std::string existVarsDecl;
    for (std::string extVarStr : existVarsList)
    {
      existVarsDecl = existVarsDecl + "(" + extVarStr +" Real)";  
    }
    std::string preStr(prefixStr);
    std::string quantFormula = "(assert (exists (" + existVarsDecl + ") " + preStr + "))";
    assertList.push_front(quantFormula);
  } else {
    sprintf(prefixStr, "(assert %s)\n", $1);
    assertList.push_front(prefixStr);
    //Create the SMT formula using the parsed invariants
    smtStr = makeSmtStr();

    // Parse the SMT string and create a Z3 expr object
    z3::expr_vector es = c.parse_string( smtStr.c_str() );
    assert( es.size() == 1);
    z3::expr e = es[0];
    /* Z3_ast parsed = Z3_parse_smtlib2_string(c, smtStr.c_str(), 0, 0, 0, 0, 0, 0); */
    /* z3::expr e(c, parsed); */

    exprList.push_back(e);
  }
}
;

boolexpr:
relexpr
| boolexpr T_COMMA boolexpr {
        sprintf(prefixStr, "(and %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| boolexpr T_AND_OP boolexpr {
        sprintf(prefixStr, "(and %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| boolexpr T_OR_OP boolexpr {
        sprintf(prefixStr, "(or %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| T_LP boolexpr T_RP {
  sprintf(prefixStr, "%s", $2);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
;

relexpr:
expr T_GE_OP expr {
        sprintf(prefixStr, "(>= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_EG_OP expr {
        sprintf(prefixStr, "(>= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_LE_OP expr {
        sprintf(prefixStr, "(<= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_EL_OP expr {
        sprintf(prefixStr, "(<= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_EQ_OP expr {
        sprintf(prefixStr, "(= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_NE_OP expr {
        sprintf(prefixStr, "(not (= %s %s))", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_G_OP expr {
        sprintf(prefixStr, "(> %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_L_OP expr {
        sprintf(prefixStr, "(< %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
| expr T_ASS_OP expr {
        sprintf(prefixStr, "(= %s %s)", $1, $3);
        if (($$ = strdup(prefixStr)) == NULL) {
                perror("yyparse: realloc error");
                exit(1);
        }
}
;

expr:
  term
| expr T_PLUS_OP term {
  sprintf(prefixStr, "(+ %s %s)", $1, $3);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| expr T_MIN_OP term {
  sprintf(prefixStr, "(- %s %s)", $1, $3);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| T_MIN_OP expr {
  sprintf(prefixStr, "(- %s)", $2);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
;

term:
  fact
| term T_MUL_OP fact {
  sprintf(prefixStr, "(* %s %s)", $1, $3);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| term T_DIV_OP fact {
  sprintf(prefixStr, "(/ %s %s)", $1, $3); 
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| term T_MOD_OP fact {
  sprintf(prefixStr, "(%% %s %s)", $1, $3); 
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
;

fact:
  T_LIT
| T_IDENT {
  identList.push_back($1);
  sprintf(prefixStr, "%s", $1);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| T_LP expr T_RP {
  sprintf(prefixStr, "%s", $2);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
| T_IDENT T_L_BKT expr T_R_BKT {
  arrIdentList.push_back($1);
  sprintf(prefixStr, "(select %s %s)", $1, $3);
  if (($$ = strdup(prefixStr)) == NULL) {
    perror("yyparse: realloc error");
    exit(1);
  }
}
;

%%
/*
void chomp( std::string &s)
{
  int pos;
  if((pos=s.find('\n')) != std::string::npos)
    s.erase(pos);
}

int populateVars(char* exVarsFile, char* indVarsFile, char* arrVarsFile)
{
  char * line = NULL;
  size_t len = 0;
  // Process file containing list of vars to be existentially quantified
  if ((varsfp = fopen(exVarsFile, "r")) == NULL)
  {
    perror(exVarsFile);
    return 1;
  }
  while (getline(&line, &len, varsfp) != -1)
  {
    if ('\n' != line[0])
    {
      std::string str(line);
      existVarsList.push_front(str);
    }
  }
  if(varsfp != NULL) { fclose(varsfp); }

  // Process file containing list of index vars 
  if ((varsfp = fopen(indVarsFile, "r")) == NULL)
  {
    perror(indVarsFile);
    return 1;
  }
  while (getline(&line, &len, varsfp) != -1)
  {
    if ('\n' != line[0])
    {
      std::string str(line);
      indList.push_front(str);
    }
  }
  if(varsfp != NULL) { fclose(varsfp); }

  // Process file containing list of array vars 
  if ((varsfp = fopen(arrVarsFile, "r")) == NULL)
  {
    perror(arrVarsFile);
    return 1;
  }
  while (getline(&line, &len, varsfp) != -1)
  {
    if ('\n' != line[0])
    {
      std::string str(line);
      arrList.push_front(str);
    }
  }
  if(varsfp != NULL) { fclose(varsfp); }

  return 0;
}
*/
std::string makeSmtStr()
{
  std::string tempStr;
  std::string smtStr;
  identList.sort();
  identList.unique();
  for (std::string idtStr : identList)
  {
    tempStr = "(declare-const "+ idtStr +" Int)\n";
    smtStr = smtStr + tempStr;
    //    fputs(tempStr.c_str(),yyout);
    tempStr.clear();
  }
  identList.clear();
  arrIdentList.sort();
  arrIdentList.unique();
  for (std::string arrStr : arrIdentList)
  {
    tempStr = "(declare-const "+ arrStr +" (Array Int Int))\n";
    smtStr = smtStr + tempStr;
    //    fputs(tempStr.c_str(),yyout);
    tempStr.clear();
  }
  arrIdentList.clear();
  for (std::string assStr : assertList)
  {
    smtStr = smtStr + assStr;
    //    fputs(assStr.c_str(),yyout);
  }
  assertList.clear();
  smtStr = smtStr += "\n(check-sat)\n";
  //  fputs("\n(check-sat)\n",yyout);
  //  fputs("\n(apply (using-params qe :qe-nonlinear true))\n", yyout);
  return smtStr;
}
/*
z3::expr createIntExpr(z3::expr e)
{
	std::list<z3::expr> argList;
	z3::expr res(e.ctx());

	unsigned args = e.num_args();
	for (unsigned i = 0; i<args; i++) 
	{
		z3::expr arg = e.arg(i);
                z3::expr e1 = convertToInt(arg);
		argList.push_front(e1);
	}

	Z3_decl_kind dk = e.decl().decl_kind();
	std::list<z3::expr>::const_iterator argListIt;
	argListIt = argList.begin(); 

	if (dk == Z3_OP_NOT) {
		res = !*argListIt;
	} else if (dk == Z3_OP_UMINUS) {
		res = -*argListIt;
	} else if (dk == Z3_OP_LE) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = e1 <= e2;
	} else if (dk == Z3_OP_GE) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = e1 >= e2;
	} else if (dk == Z3_OP_LT) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = e1 < e2;
	} else if (dk == Z3_OP_GT) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = e1 > e2;
	} else if (dk == Z3_OP_IMPLIES) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = implies(e1, e2);
	} else if (dk == Z3_OP_EQ) {
		z3::expr e2 = *argListIt;
		argListIt++;
		z3::expr e1 = *argListIt;
		res = e1 == e2;
	} else if (dk == Z3_OP_DIV) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res / *argListIt;
		}
	} else if (dk == Z3_OP_MUL) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res * *argListIt;
		}
	} else if (dk == Z3_OP_ADD) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res + *argListIt;
		}
	} else if (dk == Z3_OP_SUB) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res - *argListIt;
		}
	} else if (dk == Z3_OP_AND) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res && *argListIt;
		}
	} else if (dk == Z3_OP_OR) {
		res = *argListIt;
		argListIt++;
		for(;argListIt != argList.end(); argListIt++)
		{
			res = res || *argListIt;
		}
	} else {
		if(e.is_real()) {
			res = e.ctx().int_const(e.decl().name().str().c_str());
		} else {
			res = e;
		}
	}
	return res;
}

z3::expr convertToInt(z3::expr e) {
  if (e.is_numeral()) {
    if(e.is_real()) {
      return z3::expr(e.ctx(), Z3_mk_real2int(e.ctx(), e));
    } else if (e.is_int()){
      return e;
    } else {
      //throw "unsupported";
      return e;
    }
  }
  else if (e.is_var()) {
    return z3::expr(e.ctx(), Z3_mk_real2int(e.ctx(), e));
  }
  else if (e.is_app()) {
    return createIntExpr(e);
  }
  else if (e.is_quantifier()) {
  // You should not have quantifier after quantifier elimination 
  //throw "unsupported";
    return e;
  }
}

std::string display_app(z3::expr e) {
  std::list<std::string> argStrList;

  unsigned args = e.num_args();
  for (unsigned i = 0; i<args; i++) 
  {
    z3::expr arg = e.arg(i);
    argStrList.push_back(display(arg));
  }

  Z3_decl_kind dk = e.decl().decl_kind();
  std::list<std::string>::const_iterator argListIt;
  argListIt = argStrList.begin(); 

  if (dk == Z3_OP_NOT) {
    return "( ! " + *argListIt + ")";
  } else if (dk == Z3_OP_UMINUS) {
    return "( - " + *argListIt + ")";
  } else if (dk == Z3_OP_LE) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "(" + e1 + " <= " + e2 + ")";
  } else if (dk == Z3_OP_GE) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "(" + e1 + " >= " + e2 + ")";
  } else if (dk == Z3_OP_LT) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "(" + e1 + " < " + e2 + ")";
  } else if (dk == Z3_OP_GT) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "(" + e1 + " > " + e2 + ")";
  } else if (dk == Z3_OP_IMPLIES) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "( ( !" + e1 + ")" + " || " + e2 + ")";
  } else if (dk == Z3_OP_EQ) {
    std::string e1 = *argListIt;
    argListIt++;
    std::string e2 = *argListIt;
    return "(" + e1 + " == " + e2 + ")";
  } else if (dk == Z3_OP_DIV) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " / " + *argListIt;
    }
    return res + ")";
  } else if (dk == Z3_OP_MUL) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " * " + *argListIt;
    }
    return res + ")";
  } else if (dk == Z3_OP_ADD) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " + " + *argListIt;
    }
    return res + ")";
  } else if (dk == Z3_OP_SUB) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " - " + *argListIt;
    }
    return res + ")";
  } else if (dk == Z3_OP_AND) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " && " + *argListIt;
    }
    return res + ")";
  } else if (dk == Z3_OP_OR) {
    std::string res = "(" + *argListIt;
    argListIt++;
    for(;argListIt != argStrList.end(); argListIt++)
    {
      res = res + " || " + *argListIt;
    }
    return res + ")";
  } else {
    return e.decl().name().str();
  }
}

std::string display(z3::expr e) {
  if(e.is_numeral()) {
    __int64 num, den;
    if (Z3_get_numeral_small(e.ctx(), e, &num, &den)) {
	    return std::to_string(num);
    }
  } else if (e.is_var()) {
    return e.decl().name().str();
  } else if (e.is_app()) {
    return display_app(e);
  } else if (e.is_quantifier()) {
    // Ideally quantifier should not occur. 
    return "";
  }
}


int invokeZ3(std::string smtStr)
{
  int retVal = 0;
  z3::context c;

  // Parse the SMT string and create a Z3 expr object
  Z3_ast parsed = Z3_parse_smtlib2_string(c, smtStr.c_str(), 0, 0, 0, 0, 0, 0);
  z3::expr e(c, parsed);
#ifdef ENABLEPRINTS
  std::cout << "\n\nPrinting parsed formula:\n" << e;
#endif

  // Perform quantifier elimination using Z3 api
  z3::goal g(c);
  z3::tactic t1(c,"qe");
  g.add(e);
  z3::apply_result r = t1(g);

  z3::goal g_qe = r[0];
  z3::expr e_qe = g_qe.as_expr();
  #ifdef ENABLEPRINTS
  std::cout << "\n\nPrinting quantifier elimination result:\n" << e_qe;
  #endif

  //Declaring the expr_vectors for transformation of the SMT formula
  z3::expr_vector jpsrc(c);
  z3::expr_vector jpdst(c);

  z3::expr_vector ip1src(c);
  z3::expr_vector ip1dst(c);

  z3::expr_vector jppsrc(c);
  z3::expr_vector jppdst(c);

  z3::expr_vector ip1jppsrc(c);
  z3::expr_vector ip1jppdst(c);

  z3::expr_vector ipsrc(c);
  z3::expr_vector ipdst(c);

  z3::expr_vector printjpsrc(c);
  z3::expr_vector printjpdst(c);

  z3::expr_vector lbchecksrc(c);
  z3::expr_vector lbcheckdst(c);

  int cnt = 0;
  z3::expr j_mid(c);
  z3::expr ineqip(c);
  z3::expr lbComp(c);
  z3::expr ubComp(c);
  z3::expr indValForLb(c);
  z3::expr indValForUb(c);
  z3::expr ext_j(c);
  z3::expr for_i(c);

  //Populating the expr_vectors
  std::list<std::string>::const_iterator ali;
  for (ali = arrList.begin(); ali != arrList.end(); ++ali) 
  {
    std::string arrName(*ali);
    chomp(arrName);
    std::string jStr = "j_" + arrName;
    z3::expr j = c.int_const(jStr.c_str());
    jpsrc.push_back(j);
    jppsrc.push_back(j);
    ip1jppsrc.push_back(j);
    std::string ubStr = "__ub_" + arrName;
    std::string lbStr = "__lb_" + arrName;
    z3::expr ub = c.int_const(ubStr.c_str());
    z3::expr lb = c.int_const(lbStr.c_str());
    ip1jppsrc.push_back(ub);
    ip1jppsrc.push_back(lb);
    ip1src.push_back(ub);
    ip1src.push_back(lb);
    ipsrc.push_back(ub);
    ipsrc.push_back(lb);

    z3::expr intj = c.int_const(jStr.c_str());
    printjpsrc.push_back(intj);

    std::string jpStr = "j_" + arrName + "_p";
    z3::expr jp = c.int_const(jpStr.c_str());
    jpdst.push_back(jp);

//    z3::expr intjp = c.int_const(jpStr.c_str());
    z3::expr intjp = c.int_const("loopind_p");
    printjpdst.push_back(intjp);

    std::string jppStr = "j_" + arrName + "_pp";
    z3::expr jpp = c.int_const(jppStr.c_str());
    jppdst.push_back(jpp);
    ip1jppdst.push_back(jpp);
    std::string ubpStr = "__ub_" + arrName +"_p";
    std::string lbpStr = "__lb_" + arrName +"_p";
    z3::expr ubp = c.int_const(ubpStr.c_str());
    z3::expr lbp = c.int_const(lbpStr.c_str());
    ip1jppdst.push_back(ubp);
    ip1jppdst.push_back(lbp);
    ip1dst.push_back(ubp);
    ip1dst.push_back(lbp);
    ipdst.push_back(ubp);
    ipdst.push_back(lbp);

    std::string ubProgStr = "CELLCOUNT";
    if(cnt == 0) {
      j_mid = to_expr(c, (jp < j && j < jpp));
      lbComp = !(lb <= c.int_val(0));
      ubComp = !(ub >= c.int_const(ubProgStr.c_str()));
      ext_j = j;
    } else {
      j_mid = to_expr(c, j_mid && (jp < j && j < jpp));
      lbComp = lbComp && !(lb <= c.int_val(0));
      ubComp = ubComp && !(ub >= c.int_const(ubProgStr.c_str()));
    }
    cnt++;
  }

  cnt = 0;
  std::list<std::string>::const_iterator indli;
  for (indli = indList.begin(); indli != indList.end(); ++indli) 
  {
    std::string iStr = *indli;
    chomp(iStr);
    z3::expr i = c.int_const(iStr.c_str());
    ip1src.push_back(i);
    ip1jppsrc.push_back(i);

    z3::expr ip1 = i + 1;
    ip1dst.push_back(ip1);
    ip1jppdst.push_back(ip1);

    z3::expr ind = c.int_const(iStr.c_str());
    ipsrc.push_back(ind);

    std::string ipStr = iStr + "_p";
    z3::expr ip = c.int_const(ipStr.c_str());
    ipdst.push_back(ip);

    std::string iValLbStr = "1";
    z3::expr iValLb = c.int_val(iValLbStr.c_str());
    std::string iValUbStr = "CELLCOUNT";
    z3::expr iValUb = c.int_const(iValUbStr.c_str()) / c.int_val(2);

    if(cnt == 0) {
      ineqip = (ip >= ind + 1 || ind >= ip + 1);
      indValForLb = (i == iValLb);
      indValForUb = (i <= iValUb);
      for_i = i;
    } else {
      ineqip = ineqip && (ip >= ind + 1 || ind >= ip + 1);
      indValForLb = indValForLb && (i == iValLb);
      indValForUb = indValForUb && (i <= iValUb);
    }
    cnt++;
  }

  // Convert the expr from real type to int type
  z3::expr int_e = convertToInt(e_qe).simplify();
  #ifdef ENABLEPRINTS
  std::cout << "\nPrinting int expr:\n\n" << int_e << "\n\n";
  #endif

  z3::expr sub_exp1 = int_e.substitute(jpsrc, jpdst);

  z3::expr sub_exp2 = int_e.substitute(ip1jppsrc, ip1jppdst);

  z3::expr sub_exp3 = int_e.substitute(ip1src, ip1dst);

  z3::expr sub_exp4 = int_e.substitute(jppsrc, jppdst);

  z3::solver s(c);

  //Compactness check

  s.add(sub_exp1);
  s.add(sub_exp2);
  s.add(j_mid);
  s.add(!int_e);
  s.add(!sub_exp3);
  #ifdef ENABLEPRINTS
  std::cout << "\nPrinting the solver contents for Compactness check:\n" << s << "\n";
  #endif

  if (s.check() == z3::unsat) {
    std::cout << "\nCompactness proved\n" << std::endl;
  } else { retVal--; }
  s.reset();

  //Rangelike check

  s.add(j_mid);
  s.add(sub_exp1);
  s.add(sub_exp4);
  s.add(!int_e);
  #ifdef ENABLEPRINTS
  std::cout << "\nPrinting the solver contents for Rangelike check:\n" << s << "\n";
  #endif

  if (s.check() == z3::unsat) {
    std::cout << "Rangelike proved\n" << std::endl;
  } else { retVal--; }
  s.reset();

  //Disjointness check

  z3::expr sub_exp5 = int_e.substitute(ipsrc, ipdst);

  s.add(int_e);
  s.add(sub_exp5);
  s.add(ineqip);
  #ifdef ENABLEPRINTS
  std::cout << "\nPrinting the solver contents for Disjointness check:\n" << s << "\n";
  #endif

  if (s.check() == z3::unsat) {
    std::cout << "Disjointness proved\n" << std::endl;
  } else { retVal--; }
  s.reset();

  //Full Range

//  z3::expr impl_exp = implies(for_i > 1, !int_e);
//  z3::expr fall_exp = forall(for_i, impl_exp);
//  s.add(exists(ext_j, fall_exp));
//  #ifdef ENABLEPRINTS
//  std::cout << "\nPrinting the solver contents for Full Range check:\n" << s << "\n";
//  #endif

//  if (s.check() == z3::unsat) {
//    std::cout << "Full range proved\n" << std::endl;
//  } else { retVal--; 
//    z3::model m = s.get_model();
//    std::cout << "counterexample:\n" << m << "\n";
//  }
//  s.reset();

  //Check !(lb' <= lb(0)) should be unsat
//  s.add(int_e);
//  s.add(lbComp);
//  s.add(indValForLb);
//  #ifdef ENABLEPRINTS
//  std::cout << "\nPrinting the solver contents for lowerbound check:\n" << s << "\n";
//  #endif

//  if (s.check() == z3::unsat) {
//    std::cout << "Lowerbound checked. \n" << std::endl;
//  } else { retVal--; }
//  s.reset();

  //Check !(ub' >= ub) should be unsat

//  s.add(int_e);
//  s.add(ubComp);
//  s.add(indValForUb);
//  #ifdef ENABLEPRINTS
//  std::cout << "\nPrinting the solver contents for lowerbound check:\n" << s << "\n";
//  #endif

//  if (s.check() == z3::unsat) {
//    std::cout << "Upperbound checked. \n" << std::endl;
//  } else { retVal--; }
//  s.reset();


  //Print the invariant
  FILE *invsout;
  if ((invsout = fopen("invariants.txt", "w")) == NULL)
  {
    perror("invariants.txt");
    return 1;
  }
  z3::expr print_inv = int_e.substitute(printjpsrc, printjpdst);
  fputs(display(print_inv).c_str(), invsout); 
  if (invsout!= NULL) { fclose(invsout); }

  return retVal;
}

int main (int argc, char **argv)
{
  std::string smtStr;
  outputFile = 0;
  //  if (argc < 6)
  //  {
  //    std::cout << "Insufficient number of arguments.\n";
  //    return 1;
  //  }
  // Open output file to write SMT formula
  if ((yyout = fopen(argv[1], "w")) == NULL)
  {
    perror(argv[1]);
    return 1;
  }
  outputFile = argv[1];

  // Open input file containing invariants
  if ((fp = fopen(argv[2], "r")) == NULL)
  {
    perror(argv[2]);
    return 1;
  }
  yyin = fp;

  //  populateVars(argv[3], argv[4], argv[5]);

  //Parse the invariants file
  yyparse();
  if (fp != NULL) { fclose(fp); }

  //Create the SMT formula using the parsed invariants
  smtStr = makeSmtStr();
  if (yyout != NULL) { fclose(yyout); }
  //  int rVal = invokeZ3(smtStr);

  // return rVal;
}
*/

std::list<z3::expr> getZ3ExprFromInv(std::string invsFile)
{
  // Open input file containing invariants
  if ((fp = fopen(invsFile.c_str(), "r")) == NULL)
  {
    std::cout << "\n\nUnable to open file " + invsFile + "\n\n";
    perror(invsFile.c_str());
    exit(1);
  }
  yyin = fp;

  //Parse the invariants file
  yyparse();
  if (fp != NULL) { fclose(fp); }

  return exprList;
}

void yyerror (char *s)
{
  fprintf(stderr, "%s\n", s);
}

