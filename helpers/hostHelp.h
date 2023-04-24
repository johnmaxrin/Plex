#include<thrust/host_vector.h>

#ifndef __HOST_HELP__
#define __HOST_HELP__

thrust::host_vector<std::string> generateValues(char *values, int size);
thrust::host_vector<int> generateTokens(int *htokens, int size);

#endif // __HOST_HELP__

