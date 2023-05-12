
#include<thrust/host_vector.h>
#include<string>
#include<fstream>

#ifndef __PLEX_FILE__
#define __PLEX_FILE__



thrust::host_vector<std::string> readFile(const char *);
void printOutput(thrust::host_vector<std::string>,thrust::host_vector<int>, double);



#endif