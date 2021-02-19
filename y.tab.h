/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_ADD = 258,
    T_SUBTRACT = 259,
    T_MULTIPLY = 260,
    T_DIVIDE = 261,
    T_ADD_ASSIGN = 262,
    T_SUB_ASSIGN = 263,
    T_MUL_ASSIGN = 264,
    T_DIV_ASSIGN = 265,
    T_MOD_ASSIGN = 266,
    T_MOD = 267,
    T_GREATER_THAN = 268,
    T_LESSER_THAN = 269,
    T_LESSER_EQ = 270,
    T_GREATER_EQ = 271,
    T_NOT_EQ = 272,
    T_EQUAL = 273,
    T_VOID = 274,
    T_IF = 275,
    T_ELSE = 276,
    T_FOR = 277,
    T_DO = 278,
    T_WHILE = 279,
    T_GOTO = 280,
    T_BREAK = 281,
    T_CONTINUE = 282,
    T_RETURN = 283,
    T_SWITCH = 284,
    T_CASE = 285,
    T_DEFAULT = 286,
    T_MAIN = 287,
    T_INT = 288,
    T_FLOAT = 289,
    T_DOUBLE = 290,
    T_SHORT = 291,
    T_LONG = 292,
    T_LONG_INT = 293,
    T_CHAR = 294,
    T_SIGNED = 295,
    T_UNSIGNED = 296,
    T_LG_OR = 297,
    T_LG_AND = 298,
    T_NOT = 299,
    T_ASSIGN = 300,
    T_DECREMENT = 301,
    T_INCREMENT = 302,
    T_HEX_CONSTANT = 303,
    T_DEC_CONSTANT = 304,
    T_INT_CONSTANT = 305,
    T_STRING = 306,
    T_IDENTIFIER = 307,
    T_IFX = 308
  };
#endif
/* Tokens.  */
#define T_ADD 258
#define T_SUBTRACT 259
#define T_MULTIPLY 260
#define T_DIVIDE 261
#define T_ADD_ASSIGN 262
#define T_SUB_ASSIGN 263
#define T_MUL_ASSIGN 264
#define T_DIV_ASSIGN 265
#define T_MOD_ASSIGN 266
#define T_MOD 267
#define T_GREATER_THAN 268
#define T_LESSER_THAN 269
#define T_LESSER_EQ 270
#define T_GREATER_EQ 271
#define T_NOT_EQ 272
#define T_EQUAL 273
#define T_VOID 274
#define T_IF 275
#define T_ELSE 276
#define T_FOR 277
#define T_DO 278
#define T_WHILE 279
#define T_GOTO 280
#define T_BREAK 281
#define T_CONTINUE 282
#define T_RETURN 283
#define T_SWITCH 284
#define T_CASE 285
#define T_DEFAULT 286
#define T_MAIN 287
#define T_INT 288
#define T_FLOAT 289
#define T_DOUBLE 290
#define T_SHORT 291
#define T_LONG 292
#define T_LONG_INT 293
#define T_CHAR 294
#define T_SIGNED 295
#define T_UNSIGNED 296
#define T_LG_OR 297
#define T_LG_AND 298
#define T_NOT 299
#define T_ASSIGN 300
#define T_DECREMENT 301
#define T_INCREMENT 302
#define T_HEX_CONSTANT 303
#define T_DEC_CONSTANT 304
#define T_INT_CONSTANT 305
#define T_STRING 306
#define T_IDENTIFIER 307
#define T_IFX 308

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 22 "parser.y" /* yacc.c:1909  */

    int ival;
    char *str;
    node_t *tbEntry;
    double dval;

#line 167 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
