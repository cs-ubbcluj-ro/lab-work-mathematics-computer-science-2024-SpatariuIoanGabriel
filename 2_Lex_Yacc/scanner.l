%{
    #include <stdio.h>
    #include <string.h>

    int STIndex = 0; 
    int column = 1;  
    FILE* STFile;
    FILE* PifFile;

    void addSymbol(const char* name, const char* type);
    int getSTIndex(const char* name);
    void getLexicalError(const char* errorType, const char* token, int line, int column);
%}

%option noyywrap

%%

"int"|"main"|"if"|"else"|"while"|"do"|"bool"|"char"|"cin"|"cout"|"endl"|"return" {
    fprintf(PifFile, "%s : 0\n", yytext);
    column += yyleng;
}

"true"|"false" {
    int index = getSTIndex(yytext);
    if (index == -1) {
        STIndex++;
        addSymbol(yytext, "CONST");
        index = STIndex;
    }
    fprintf(PifFile, "CONST : %d\n", index);
    column += yyleng;
}

[A-Za-z][A-Za-z0-9]* {
    int index = getSTIndex(yytext);
    if (index == -1) {
        STIndex++;
        addSymbol(yytext, "ID");
        index = STIndex;
    }
    fprintf(PifFile, "ID : %d\n", index);
    column += yyleng;
}

[0-9]+ {
    int index = getSTIndex(yytext);
    if (index == -1) {
        STIndex++;
        addSymbol(yytext, "CONST");
        index = STIndex;
    }
    fprintf(PifFile, "CONST : %d\n", index);
    column += yyleng;
}

\"([^\"\\]|\\.)*\" {
    int index = getSTIndex(yytext);
    if (index == -1) {
        STIndex++;
        addSymbol(yytext, "CONST");
        index = STIndex;
    }
    fprintf(PifFile, "CONST : %d\n", index);
    column += yyleng;
}

"<<"|">>"|"+"|"-"|"*"|"/"|"%"|"=" {
    fprintf(PifFile, "%s : 0\n", yytext);
    column += yyleng;
}

"<="|">="|"=="|"!="|"<"|">" {
    fprintf(PifFile, "%s : 0\n", yytext);
    column += yyleng;
}

"["|"]"|"{"|"}"|","|":"|";"|"("|")" {
    fprintf(PifFile, "%s : 0\n", yytext);
    column += yyleng;
}

\n {
    yylineno++;
    column = 1;
}

[ \t]+ {
    column += yyleng;
}

"//".* {
    yylineno++;
    column = 1;
}

. {
    getLexicalError("The character is not valid!", yytext, yylineno, column);
    column += yyleng;
}

%%

void addSymbol(const char* name, const char* type) {
    fprintf(STFile, "%d: %s\n", STIndex, name);
}

int getSTIndex(const char* name) {
    char buffer[256];
    rewind(STFile);
    while (fgets(buffer, sizeof(buffer), STFile)) {
        char sym[100];
        int index;
        sscanf(buffer, "%d: %s", &index, sym);
        if (strcmp(sym, name) == 0) {
            return index;
        }
    }
    return -1;
}

void getLexicalError(const char* errorType, const char* token, int line, int column) {
    fprintf(stderr, "There is an error at line %d, column %d: %s - '%s'\n", line, column, errorType, token);
}

int main(void) {
    FILE* inputFile = fopen("problem.txt", "r");
    if (!inputFile) {
        printf("Error opening file\n");
        return 1;
    }
    yyin = inputFile;

    STFile = fopen("ST.out", "w+");
    if (!STFile) {
        printf("Error opening Symbol Table output file\n");
        return 1;
    }

    PifFile = fopen("PIF.out", "w");
    if (!PifFile) {
        printf("Error opening PIF output file\n");
        return 1;
    }

    yylex();
    fclose(inputFile);
    fclose(STFile);
    fclose(PifFile);
    return 0;
}


