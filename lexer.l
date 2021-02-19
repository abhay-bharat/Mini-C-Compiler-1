
%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int ErrFlag = 0;
	#include "symbol_table.h"
    #include "y.tab.h"

	//void yyerror(char *s);
	//int yylex(void);
	int line_no = 1;
	extern symtab_t* SymbolTable;
%}

alpha [A-Za-z]
digit [0-9]
digits {digit}+
fraction 	(\.{digits})?
exponent 	([Ee][+-]?{digits})?
number 		{digits}{fraction}{exponent}
whitespace [ \t\r\f\v]+
char '\.\'
space [ ]
tab ['\t']
line ['\n']
string \"(.^([%d]|[%f]|[%s]|[%c]))\"
identifier (_|{alpha})({alpha}|{digit}|_)*

%%
{whitespace} ;
int 		{ yylval.dval = (int)atoi(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_INT;
			}
float 		{ yylval.dval = atof(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_FLOAT;
			}
char 		{ printf("<keyword, %s>\n", yytext);
			return T_CHAR;
			}
double 		{ printf("<keyword, %s>\n", yytext);
			return T_DOUBLE;
			}
main		{ printf("<keyword, %s>\n", yytext);
			return T_MAIN;
			}
"="			{ printf("<symbol, %c>\n", yytext[0]);
			return T_ASSIGN;}
{identifier}	{
					insert(SymbolTable, "ID", yytext);
					yylval.tbEntry = exists(SymbolTable, yytext);
					return T_IDENTIFIER;
				}
{string} 	{
				insert(SymbolTable, "STRING", yytext);
				return T_STRING;
			}
{number}	{
				insert(SymbolTable, "NUM", yytext);
				return T_INT_CONSTANT;
			}
"if"/"(".*")" 	{
					printf("<keyword, %s>\n", yytext);
					return T_IF;
				}
"\n"		{line_no++;}



.			{ printf("<symbol, %c>\n", yytext[0]);
			return yytext[0];};
%%

