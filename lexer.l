
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
dec 		([+-]?({digit}*)["."]({digit}+))|([+-]?({digit}+)["."]({digit}*))
whitespace [ \t\r\f\v]+
char '\.\'
space [ ]
tab ['\t']
line ['\n']
string \"(.^([%d]|[%f]|[%s]|[%c]))\"
identifier (_|{alpha})({alpha}|{digit}|_)*

%%

int 		{ yylval.dval = (int)atoi(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_INT;
			}
short 		{ yylval.dval = (int)atoi(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_SHORT;
			}
long 		{ yylval.dval = (long int)atoi(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_LONG;
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
void 		{ printf("<keyword, %s>\n", yytext);
			  return T_VOID;
			}
if 			{ printf("<keyword, %s>\n", yytext);
			  return T_IF;
			}
else 		{ printf("<keyword, %s>\n", yytext);
			  return T_ELSE;
			}
while 		{ printf("<keyword, %s>\n", yytext);
			  return T_WHILE;
			}
break 		{ printf("<keyword, %s>\n", yytext);
			  return T_BREAK;
			}
return 		{ printf("<keyword, %s>\n", yytext);
			  return T_RETURN;
			}
main		{ printf("<keyword, %s>\n", yytext);
			return T_MAIN;
			}

{whitespace} ;

[0][xX][0-9a-fA-F]+ 							{ insert(SymbolTable, "T_HEX_CONSTANT", yytext); 
			  									yylval.dval = (int)strtol(yytext, NULL, 16);
												printf("Constant, %lf\n", yylval.dval);
			  									return T_HEX_CONSTANT;
			  									}
[+-]?{digit}+									{ insert(SymbolTable, "T_INT_CONSTANT", yytext);
			  									yylval.dval = atoi(yytext);
												printf("Constant, %d\n", (int)yylval.dval);
			  									return T_INT_CONSTANT;
			  									}
{dec}											{ insert(SymbolTable, "T_DEC_CONSTANT", yytext);
			  									yylval.dval = atof(yytext);
												printf("Constant, %lf\n", yylval.dval);
			  									return T_DEC_CONSTANT;
			  									}
({digit}*)["."]?{digits}[eE][+-]?{digits}		{ insert(SymbolTable, "T_DEC_CONSTANT", yytext);
			  									yylval.dval = atof(yytext);
												printf("Constant, %lf\n", yylval.dval);
			  									return T_DEC_CONSTANT;
			  									}


{identifier}	{
					if(strlen(yytext) <= 32)
					{
						insert(SymbolTable, "T_IDENTIFIER", yytext);
						yylval.tbEntry = exists(SymbolTable, yytext);
						return T_IDENTIFIER;
					}
					else
					{
						//printf("Error at line %d. Identifier name exceeds limit (length of identifier must be between 1 and 32 characters both inclusive).\n", yylineno);
						yyerror("Identifier name exceeds limit (length of identifier must be between 1 and 32 characters both inclusive).");
						ErrFlag = 1;
					}
					
				}

{string} 	{
				insert(SymbolTable, "STRING", yytext);
				return T_STRING;
			}


"="		{ printf("<symbol, %s>\n", yytext);
		return T_ASSIGN;
		}	
"if"/"(".*")" 	{
					printf("<keyword, %s>\n", yytext);
					return T_IF;
				}
"\n"		{line_no++;}



.			{ printf("<symbol, %c>\n", yytext[0]);
			return yytext[0];};
%%

