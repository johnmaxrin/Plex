#include "helper.h"
#include "enum.h"
#include "global.h"
#include "checks.h"
#include <stdio.h>

__device__ char* parse(char *str, int *tokens, char *values, int idx)
{

    int pointer = 0, bufferPointer = 0;
    char buffer[MTS];
    int token = -1;
    int count = idx*TPW;
    char *data = new char[MTS];

    while (str[pointer] != '\0')
    {

        if (isalnum(str[pointer]))
        {
            buffer[bufferPointer++] = str[pointer++];
            if (!isalnum(str[pointer]))
            {
                token = iskeyword(buffer);
                if (token == -1)
                {
                    tokens[count++] = IDENTIFIER;
                    plex_strcpy(data, buffer,idx);
                }
                else
                {
                    tokens[count++] = token;
                    plex_strcpy(data, buffer,idx);
                }
                
                memset(buffer,'\0' ,sizeof(char) * MTS);
                bufferPointer = 0;
            }
        }

        else if (issymbol(str[pointer]) != -1)
        {
            tokens[count++] = issymbol(str[pointer]);

            plex_strcpysymbol(data, str[pointer++],idx);
        }
        else
        {
            tokens[count++] = -2;
            plex_strcpysymbol(data,str[pointer++],idx);
        }
    }

    return data;
}

__device__ bool plex_strcmp(const char *keyword, char *string)
{
    int i = 0;
    while (keyword[i] == string[i])
    {
        if (string[i] == '\0')
        {
            return true;
        }
        i++;
    }

    return false;
}

__device__ void plex_strcpy(char *string, char *value, int idx)
{
    int strlen = 0;
    int valuelen = 0;

    for (; string[strlen] != '\0'; ++strlen)
        ;
    for (valuelen = 0; value[valuelen] != '\0'; ++valuelen)
        ;

    for (int i = 0; i <= valuelen; ++i)
    {
        if (value[i] != '\0')
            string[strlen++] = value[i];
    }

    string[strlen++] = '.';
    string[strlen] = '\0';
}

__device__ void plex_strcpysymbol(char *string, char value, int idx)
{
    int strlen = 0;
    for (; string[strlen] != '\0'; ++strlen)
        ;

    string[strlen++] = value;
    string[strlen++] = '.';
    string[strlen] = '\0';
}

