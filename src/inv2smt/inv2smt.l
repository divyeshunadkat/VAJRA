
%option noyywrap
%option nounput
%option yylineno
%option noinput
%option never-interactive

%{
	#include "inv2smt.y.hpp"
//	#include "y.tab.h"
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <stdio.h>
	#include <string>
	#include <list>

//	extern std::list<std::string> identList;
%}

VAR ([a-zA-Z_][a-zA-Z_0-9]*)
NUM [0]|([1-9][0-9]*)
WSP [ \t]
%%
"+"		{ return T_PLUS_OP; }
"-"		{ return T_MIN_OP; }
"*"		{ return T_MUL_OP; }
"/"		{ return T_DIV_OP; }
"%"		{ return T_MOD_OP; }
"&&"		{ return T_AND_OP; }
"||"		{ return T_OR_OP; }
"="		{ return T_ASS_OP; }
"=<"		{ return T_EL_OP; }
"=>"		{ return T_EG_OP; }
"=="		{ return T_EQ_OP; }
"!="		{ return T_NE_OP; }
"<"		{ return T_L_OP; }
"<="		{ return T_LE_OP; }
">"		{ return T_G_OP; }
">="		{ return T_GE_OP; }
"\n"		{ return T_NL; }
"("		{ return T_LP; }
")"		{ return T_RP; }
","		{ return T_COMMA; }
"["             { return T_L_BKT; }
"]"             { return T_R_BKT; }
{NUM}		{ 
			if ((yylval.string = strdup(yytext)) == NULL)
			{
				perror("yyparse: realloc error");
				exit(1);
			}
			return T_LIT;
		}
{VAR}		{ 
			if ((yylval.string = strdup(yytext)) == NULL)
			{
				perror("yyparse: realloc error");
				exit(1);
			}
//			identList.push_front(yytext);
			return T_IDENT;
		}
{WSP}+		{ ; }
.		{
			char errStr[27];
			sprintf(errStr, "Invalid character `%c` found.", yytext[0]);
			perror(errStr);
		}
