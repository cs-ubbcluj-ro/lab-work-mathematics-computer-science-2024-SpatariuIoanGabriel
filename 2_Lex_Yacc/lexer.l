%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>

void yyerror(const char *s);
int column = 1;  // Tracks the current column for error reporting
%}

%%

"int"          { column += yyleng; return INT; }
"main"         { column += yyleng; return MAIN; }
"return"       { column += yyleng; return RETURN; }
"if"           { column += yyleng; return IF; }
"else"         { column += yyleng; return ELSE; }
"while"        { column += yyleng; return WHILE; }
"struct"       { column += yyleng; return STRUCT; }
"cin"          { column += yyleng; return CIN; }
"cout"         { column += yyleng; return COUT; }
"bool"         { column += yyleng; return BOOL; }
"char"         { column += yyleng; return CHAR; }
"string"       { column += yyleng; return STRING; }
"double"       { column += yyleng; return DOUBLE; }

[0-9]+         { 
                  yylval.intval = atoi(yytext); 
                  column += yyleng; 
                  return INT_CONST; 
               }

\"[^\"]*\"     { 
                  yylval.strval = strdup(yytext); 
                  column += yyleng; 
                  return STRING_LITERAL; 
               }

[a-zA-Z_][a-zA-Z0-9_]* { 
                  yylval.strval = strdup(yytext); 
                  column += yyleng; 
                  return IDENTIFIER; 
               }

"{"            { column += yyleng; return LBRACE; }
"}"            { column += yyleng; return RBRACE; }
"("            { column += yyleng; return LPAREN; }
")"            { column += yyleng; return RPAREN; }
"=="           { column += yyleng; return EQ; }
"!="           { column += yyleng; return NEQ; }
"<="           { column += yyleng; return LTE; }
">="           { column += yyleng; return GTE; }
"<"            { column += yyleng; return LT; }
">"            { column += yyleng; return GT; }
"="            { column += yyleng; return ASSIGN; }
";"            { column += yyleng; return SEMICOLON; }
"+"            { column += yyleng; return PLUS; }
"-"            { column += yyleng; return MINUS; }
"*"            { column += yyleng; return MUL; }
"/"            { column += yyleng; return DIV; }
"%"            { column += yyleng; return MOD; }
">>"           { column += yyleng; return RSHIFT; }
"<<"           { column += yyleng; return LSHIFT; }

[ \t]+         { column += yyleng; } /* Ignore spaces and tabs */
\n             { column = 1; yylineno++; } /* Update line number on newline */

.              { 
                  fprintf(stderr, "Unexpected character '%s' at line %d, column %d\n", yytext, yylineno, column); 
                  column += yyleng; 
                  yyerror("Unexpected character"); 
               }

%%

int yywrap() {
    return 1;
}
