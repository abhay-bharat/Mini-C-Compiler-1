%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int ErrFlag = 0;
	#include "symbol_table.h"
    #include "y.tab.h"

	//void yyerror(char *s);
	//int yylex(void);
	extern int yylineno;
	extern symtab_t* SymbolTable;
	//scope for indicating the scope of the variable
	extern int scope = 0; 
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

/* States */
%x PREPROCESSOR
%x MLCOMMENT
%x SLCOMMENT
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
float 		{ yylval.dval = (float)atof(yytext);
			  printf("<keyword, %s>\n", yytext);
			  return T_FLOAT;
			}
char 		{ 	yylval.dval = yytext;
				printf("<keyword, %s>\n", yytext);
				return T_CHAR;
			}
double 		{ yylval.dval = (double)atof(yytext);
			  printf("<keyword, %s>\n", yytext);
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

^"#include"  					{BEGIN PREPROCESSOR;}
<PREPROCESSOR>{whitespace} 		;
<PREPROCESSOR>"<"[^<>\n]*">"	{BEGIN INITIAL;}
<PREPROCESSOR>\"[^<>\n]*\"		{BEGIN INITIAL;}
<PREPROCESSOR>"\n"				{ yylineno++; 
								  BEGIN INITIAL;
								  ErrFlag=1;	
								}
<PREPROCESSOR>.					{ yyerror("Improper defined Header");}


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

{string} 			{
						insert(SymbolTable, "STRING", yytext, scope);
						return T_STRING;
					}

{identifier}	{
					if(strlen(yytext) <= 32)
					{
						insert(SymbolTable, "T_IDENTIFIER", yytext, scope);
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

"/*"			{BEGIN MLCOMMENT;}
<MLCOMMENT>.		;
<MLCOMMENT>"\n"		{++yylineno;}
<MLCOMMENT><<EOF>>	{yyerror("EOF encountered while parsing multi line comment");
					yyterminate();
					}
<MLCOMMENT>"*/"	{BEGIN INITIAL;}

"//"			{BEGIN SLCOMMENT;}
<SLCOMMENT>.	;
<SLCOMMENT><<EOF>>	{yyerror("EOF encountered while parsing single line comment");
					yyterminate();
					}
<SLCOMMENT>"\n" 	{++yylineno;
				BEGIN INITIAL;}

"+"                                 {printf("<symbol, %s>\n", yytext);
									return T_ADD;}
"-"                                 {printf("<symbol, %s>\n", yytext);
									return T_SUBTRACT;}
"*"                                 {printf("<symbol, %s>\n", yytext);
									return T_MULTIPLY;}
"/"                                 {printf("<symbol, %s>\n", yytext);
									return T_DIVIDE;}
"%"                                 {printf("<symbol, %s>\n", yytext);
									return T_MOD;}
"="                                 {printf("<symbol, %s>\n", yytext);
									return T_ASSIGN;}
"--"                                {printf("<symbol, %s>\n", yytext);
									return T_DECREMENT;}
"++"                                {printf("<symbol, %s>\n", yytext);
									return T_INCREMENT;}

"+="                                {printf("<symbol, %s>\n", yytext);
									return T_ADD_ASSIGN;}
"-="                                {printf("<symbol, %s>\n", yytext);
									return T_SUB_ASSIGN;}
"*="                                {printf("<symbol, %s>\n", yytext);
									return T_MUL_ASSIGN;}
"/="                                {printf("<symbol, %s>\n", yytext);
									return T_DIV_ASSIGN;}
"%="                                {printf("<symbol, %s>\n", yytext);
									return T_MOD_ASSIGN;}

">"                                 {printf("<symbol, %s>\n", yytext);
									return T_GREATER_THAN;}
"<"                                 {printf("<symbol, %s>\n", yytext);
									return T_LESSER_THAN;}
">="                                {printf("<symbol, %s>\n", yytext);
									return T_GREATER_EQ;}
"<="                                {printf("<symbol, %s>\n", yytext);
									return T_LESSER_EQ;}
"=="                                {printf("<symbol, %s>\n", yytext);
									return T_EQUAL;}

"||"                                {printf("<symbol, %s>\n", yytext);
									return T_LG_OR;}
"&&"                                {printf("<symbol, %s>\n", yytext);
									return T_LG_AND;}
"!"                                 {printf("<symbol, %s>\n", yytext);
									return T_NOT;}
"!="                                {printf("<symbol, %s>\n", yytext);
									return T_NOT_EQ;}

"{"			{
				scope++;
			}

"}"			{
				scope--;
				if(scope <= 0)
					yyerror("Undefined scope");
			}

"\n"		{yylineno++;}



.			{ printf("<symbol, %c>\n", yytext[0]);
			return yytext[0];};
%%
