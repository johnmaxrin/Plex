#include"enum.h"
#include"checks.h"
#include"helper.h"

__device__ bool isalnum(char s)
{
    if (s >= 'a' && s <= 'z' || s >= 'A' && s <= 'Z')
    {
        return true;
    }
    else
        return false;
}

__device__ int issymbol(char c)
{
    switch (c)
    {
    case '(':
        return LPAREN;
    case ')':
        return RPAREN;
    case '=':
        return EQUAL;
    case '<':
        return LESSTHAN;
    case '>':
        return GREATERTHAN;
    case '+':
        return PLUS;
    case '-':
        return MINUS;
    case '/':
        return DIVIDE;

    default:
        return -1;
    }

}


__device__ int iskeyword(char *string)
{
    const char *keywords[10] = {"int", "float", "bool", "long", "char", "if", "else", "while", "do", "for"};

    for (int i = 0; i < 10; ++i)
    {
        if (plex_strcmp(keywords[i], string))
        {
            if (i == 0)
                return INTTOKEN;
            else if (i == 1)
                return FLOATTOKEN;
            else if (i == 2)
                return BOOLTOKEN;
            else if (i == 3)
                return LONGTOKEN;
            else if (i == 4)
                return CHARTOKEN;
            else if (i == 5)
                return IF;
            else if (i == 6)
                return ELSE;
            else if (i == 7)
                return WHILE;
            else if (i == 8)
                return DO;
            else if (i == 9)
                return FOR;
        }
    }

    return -1;
}


