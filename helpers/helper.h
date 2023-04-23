#ifndef __PLEX_HELPER__
#define __PLEX_HELPER__

__device__ char* parse(char *, int *, char *, int);
__device__ bool plex_strcmp(const char *, char *);
__device__ void plex_strcpy(char *, char *, int);
__device__ void plex_strcpysymbol(char *, char,int);

#endif