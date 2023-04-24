#include"hostHelp.h"
#include<sstream>
#include<stdio.h>

thrust::host_vector<int> generateTokens(int *htokens, int size)
{
  thrust::host_vector<int> tokens;
  for(int i=0; i<size; ++i)
  {
    if(htokens[i] != -1)
      tokens.push_back(htokens[i]);
  }

  return tokens;
}

thrust::host_vector<std::string> generateValues(char *values, int size)
{
  thrust::host_vector<std::string> data; 
  std::string item;
  
  for(int i=0; i<size; ++i)
  {
    std::stringstream ss(&values[i*20]);
    
    while (getline(ss,item,'.'))
        data.push_back(item);  
    
  }

  return data;
}