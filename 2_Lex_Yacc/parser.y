%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylineno; // Line number from Flex
    extern int column;   // Column from Flex
    void yyerror(const char *s); // Error handling function

    FILE* productionFile; // File to store production indexes
%}

%union {
    int intval;
    char* strval;
}

%token <strval> ID
%token <intval> CONST
%token IF ELSE WHILE DO RETURN INT BOOL CHAR
%token PLUS MINUS MULTIPLY DIVIDE MOD ASSIGN
%token LEQ GEQ EQ NEQ LT GT
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE COMMA COLON SEMICOLON
%token CIN COUT ENDL TRUE FALSE
%type <strval> expression statement declaration

%%

program:
    INT MAIN LPAREN RPAREN LBRACE statements RBRACE {
        fprintf(productionFile, "1\n");
        printf("Program syntactic correct\n");
    }
;

statements:
    statement statements {
        fprintf(productionFile, "2\n");
    }
    |
    /* empty */ {
        fprintf(productionFile, "3\n");
    }
;

statement:
    declaration {
        fprintf(productionFile, "4\n");
    }
    | expression SEMICOLON {
        fprintf(productionFile, "5\n");
    }
    | IF LPAREN expression RPAREN statement ELSE statement {
        fprintf(productionFile, "6\n");
    }
    | WHILE LPAREN expression RPAREN statement {
        fprintf(productionFile, "7\n");
    }
    | RETURN expression SEMICOLON {
        fprintf(productionFile, "8\n");
    }
;

declaration:
    type ID SEMICOLON {
        fprintf(productionFile, "9\n");
    }
    | type ID ASSIGN expression SEMICOLON {
        fprintf(productionFile, "10\n");
    }
;

type:
    INT {
        fprintf(productionFile, "11\n");
    }
    | BOOL {
        fprintf(productionFile, "12\n");
    }
    | CHAR {
        fprintf(productionFile, "13\n");
    }
;

expression:
    CONST {
        fprintf(productionFile, "14\n");
    }
    | ID {
        fprintf(productionFile, "15\n");
    }
    | expression PLUS expression {
        fprintf(productionFile, "16\n");
    }
    | expression MINUS expression {
        fprintf(productionFile, "17\n");
    }
    | expression MULTIPLY expression {
        fprintf(productionFile, "18\n");
    }
    | expression DIVIDE expression {
        fprintf(productionFile, "19\n");
    }
    | expression MOD expression {
        fprintf(productionFile, "20\n");
    }
    | LPAREN expression RPAREN {
        fprintf(productionFile, "21\n");
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d, column %d\n", s, yylineno, column);
    exit(1);
}

int main(void) {
    FILE* inputFile = fopen("problem.txt", "r");
    if (!inputFile) {
        printf("Error opening input file\n");
        return 1;
    }
    yyin = inputFile;

    productionFile = fopen("Productions.out", "w");
    if (!productionFile) {
        printf("Error opening productions output file\n");
        return 1;
    }

    if (!yyparse()) {
        printf("Parsing completed successfully. Productions are saved in Productions.out\n");
    }

    fclose(inputFile);
    fclose(productionFile);
    return 0;
}
