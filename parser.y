%{
//header files
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"symbol_table.h"

// Initialising Symbol table and constant table
//entry **SymbolTable = NULL;
//entry **ConstantTable = NULL;
symtab_t* SymbolTable = NULL;

int yyerror(char* err);
int yylex(void);
char* curr_data_type;

// #define yyin (stdin)
// #define yyout (stdout)
%}

// Data types of tokens
%union{
    int ival;
    char *str;
    node_t *tbEntry;
    double dval;
}

//operators
%token T_ADD T_SUBTRACT T_MULTIPLY T_DIVIDE T_ADD_ASSIGN T_SUB_ASSIGN T_MUL_ASSIGN T_DIV_ASSIGN T_MOD_ASSIGN  T_MOD
//relational operators
%token T_GREATER_THAN T_LESSER_THAN T_LESSER_EQ T_GREATER_EQ T_NOT_EQ T_EQUAL
//keywords
%token T_VOID T_IF T_ELSE T_FOR T_DO T_WHILE T_GOTO T_BREAK T_CONTINUE T_RETURN T_SWITCH T_CASE T_DEFAULT  T_MAIN
//data types
%token T_INT T_FLOAT T_DOUBLE T_SHORT T_LONG T_LONG_INT T_CHAR T_SIGNED T_UNSIGNED
//logical operators
%token T_LG_OR T_LG_AND T_NOT
//assignment operators
%token T_ASSIGN T_DECREMENT T_INCREMENT
//constants
%token <dval> T_HEX_CONSTANT T_DEC_CONSTANT T_INT_CONSTANT 
%token <str> T_STRING
//identifier
%token <tbEntry> T_IDENTIFIER
//start symbol
%start program

//associativity of operators
%left ','
%right T_ASSIGN
%left T_LG_OR
%left T_LG_AND
%left T_EQUAL T_NOT_EQ
%left T_LESSER_THAN T_GREATER_THAN T_LESSER_EQ T_GREATER_EQ
%left T_ADD T_SUBTRACT
%left T_MULTIPLY T_DIVIDE T_MOD
%right T_NOT


%nonassoc T_IFX
%nonassoc T_ELSE

%%

program : declarationList;

declarationList : declarationList declaration
                | declaration
                ;

declaration : varDeclaration
            | funDeclaration
            ;

varDeclaration : type varDecList ';'
               ;
varDecList : varDecList ',' varDecInitialize
           | varDecInitialize  
           ;
varDecInitialize : varDecId 
                 | varDecId T_ASSIGN assignmentExpression
                 ;
varDecId : T_IDENTIFIER {$1->data_type = curr_data_type;} 
         | T_IDENTIFIER '[' T_INT_CONSTANT ']'
         ;
assignmentExpression : conditionalStmt 
                     | unaryExpression assignmentOperator assignmentExpression
                     ;
assignmentOperator : T_ASSIGN
                   | T_ADD_ASSIGN
                   | T_SUB_ASSIGN
                   | T_MUL_ASSIGN
                   | T_DIV_ASSIGN
                   | T_MOD_ASSIGN
                   ;

const_type : T_DEC_CONSTANT
           | T_INT_CONSTANT
           | T_HEX_CONSTANT
           | T_STRING
           ;
type : type pointer
     | T_INT {curr_data_type = strdup("INT");}
     | T_FLOAT {curr_data_type = strdup("FLOAT");}
     | T_DOUBLE {curr_data_type = strdup("DOUBLE");}
     | T_CHAR {curr_data_type = strdup("CHAR");}
     | T_LONG_INT
     | T_VOID
     ;

pointer : T_MULTIPLY pointer
        | T_MULTIPLY
        ;

funDeclaration : type T_IDENTIFIER '(' params ')' blockStmt | type T_MAIN '(' params ')' blockStmt | onlyDec ;
onlyDec : type T_IDENTIFIER '(' params ')' ';' ;
funCall : T_IDENTIFIER '(' args ')' ';' ;
args    : argList
        | 
        ;
argList : argList ',' expression
        | expression
        ;

params : paramList 
       |
       ;
paramList : paramList ',' paramTypeList
          | paramTypeList
          ;
paramTypeList : type paramId;
paramId : T_IDENTIFIER
        | T_IDENTIFIER '[' ']'
        ;

//types of statements
statement : expressionStmt
          | blockStmt
          | selectionStmt
          | iterationStmt
          | returnStmt
          | breakStmt
          | funCall
          ;

expressionStmt : expression ';' | ';' ;

blockStmt : '{' localDeclarations statementList '}' ;
localDeclarations : localDeclarations statementList varDeclaration
                  | 
                  ;
statementList : statementList statement
              |
              ;

selectionStmt : T_IF '(' logicalExpression ')' statement %prec T_IFX
              | T_IF '(' logicalExpression ')' statement T_ELSE statement
              ;

iterationStmt : T_WHILE '(' logicalExpression ')' statement ;

conditionalStmt : logicalExpression '?' expression ':' conditionalStmt
                | logicalExpression
                ;

returnStmt : T_RETURN ';' 
           | T_RETURN expression
           ;
breakStmt : T_BREAK ';' ;

//arithmetic expressions
expression : T_IDENTIFIER assignmentOperator assignmentExpression
           | T_INCREMENT T_IDENTIFIER
           | T_DECREMENT T_IDENTIFIER
           | logicalExpression
           ;

logicalExpression : logicalExpression T_LG_OR andExpression
                  | andExpression
                  ;
andExpression : andExpression T_LG_AND unaryRelExpression
              | unaryRelExpression 
              ;
unaryRelExpression : T_NOT unaryRelExpression
                   | relExpression
relExpression : sumExpression T_GREATER_THAN sumExpression
              | sumExpression T_LESSER_THAN sumExpression
              | sumExpression T_GREATER_EQ sumExpression 
              | sumExpression T_LESSER_EQ sumExpression
              | sumExpression T_EQUAL sumExpression 
              | sumExpression T_NOT_EQ sumExpression
              | sumExpression
              ;
sumExpression : sumExpression T_ADD term
              | sumExpression T_SUBTRACT term
              | term
              ;
term : term T_MULTIPLY unaryExpression
     | term T_DIVIDE unaryExpression
     | term T_MOD unaryExpression
     | unaryExpression
     ;
unaryExpression : unary_op unaryExpression
                | factor
                ;
unary_op : T_ADD | T_SUBTRACT ;
factor : T_IDENTIFIER
       | '(' expression ')'
       | const_type
       ;


%%

void display_symbolTable()
{
    printf("\n\tSymbol Table");
    Display(SymbolTable);
}
extern FILE* yyin;
extern int yylineno;
extern char* yytext;
int main(int argc, char* argv[])
{
    //SymbolTable = CreateTable();
    //ConstantTable = CreateTable();
    SymbolTable = (symtab_t*)malloc(sizeof(symtab_t));
    SymbolTable->head = NULL;

    yyin = fopen(argv[1], "r");
    if(!yyparse())
    {
        printf("\nParsing Complete\n");
        display_symbolTable();
    }
    else
    {
        printf("\nParsing Failed\n");
    }
    fclose(yyin);
    return 0;
}

int yyerror(char* err)
{
    printf("Line no: %d Error message: %s Token: %s\n", yylineno, err, yytext);
    return 0;
} 