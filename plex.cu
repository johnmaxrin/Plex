#include <stdio.h>
#include <ctype.h>
#include <sstream>
#include "helpers/enum.h"
#include "helpers/hostHelp.h"
#include "helpers/global.h"
#include "helpers/helper.h"
#include "fileops/plexFile.h"
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>



__global__ void init(char *d_str, int *tokens, char *values)
{

  int idx = threadIdx.x + blockDim.x * blockIdx.x;
  char *data = &d_str[idx*MTS];
  char *parseData;
  parseData = parse(data, tokens, values,idx);
  int start = idx*MTS;

  int i=start,j=0;
  while(parseData[j]!='\0')
    values[i++] = parseData[j++];
  

  }


int main(int argc, char *argv[])
{
  int *htokens, *tokens;
  char *hvalues, *values, *d_str;

  // Reading file  
  thrust::host_vector<std::string> h_vec = readFile(argv[1]);

  cudaMalloc(&d_str, h_vec.size() * sizeof(char) * MTS);
  for (int i = 0; i < h_vec.size(); ++i)
  {
    std::string str = h_vec[i];
    const char *c_str = str.c_str();
    cudaMemcpy(&d_str[i*MTS], c_str, str.size()+1, cudaMemcpyHostToDevice);
  }

  

  cudaMalloc(&tokens, sizeof(int) * TPW * h_vec.size());
  cudaMalloc(&values, sizeof(char) * MTS * h_vec.size());
  cudaMemset(values, '\0', sizeof(char) * MTS * h_vec.size());
  cudaMemset(tokens, -1, sizeof(int) * TPW * h_vec.size());
  htokens = (int *)malloc(sizeof(int) * TPW * h_vec.size());
  hvalues = (char *)malloc(sizeof(char) * MTS * h_vec.size());

  // Start of GPU Processing 
  init<<<1, h_vec.size()>>>(d_str, tokens, values);
  cudaMemcpy(htokens, tokens, sizeof(int) * TPW * h_vec.size(), cudaMemcpyDeviceToHost);
  cudaMemcpy(hvalues, values, sizeof(char) * MTS * h_vec.size(), cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();
  // End of GPU Processing 

  generateValues(hvalues,h_vec.size());
  thrust::host_vector<std::string> tokenData = generateValues(hvalues,h_vec.size());
  thrust::host_vector<int> tokensList = generateTokens(htokens,h_vec.size()*TPW);


  for(int i = 0; i<tokensList.size(); ++i)
    printf("< %s , %d >\n",tokenData[i].c_str(),tokensList[i]);
  

  return 0;
}

