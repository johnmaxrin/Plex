#include <stdio.h>
#include <ctype.h>
#include "helpers/enum.h"
#include "helpers/helper.h"
#include "fileops/plexFile.h"
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

__global__ void init(char *d_str, int *tokens, char *values, int *size)
{

  int idx = threadIdx.x + blockDim.x * blockIdx.x;
  char *data = &d_str[idx*20];
  char *parseData;
  parseData = parse(data, tokens, values,idx);
  int start = idx*20;

  int i=start;
  while(parseData[i]!='\0')
    values[i] = parseData[i++];
  
  printf("%s\n",parseData);

}

int main(int argc, char *argv[])
{

  char *d_str;

  // const char h_str[20] = "{apple";
  thrust::host_vector<std::string> h_vec = readFile(argv[1]);

  cudaMalloc(&d_str, h_vec.size() * sizeof(char) * 20);
  for (int i = 0; i < h_vec.size(); ++i)
  {
    std::string str = h_vec[i];
    const char *c_str = str.c_str();
    cudaMemcpy(&d_str[i*20], c_str, str.size()+1, cudaMemcpyHostToDevice);
  }

  // Total word * 3 tokens we need at max. 2 can be enough though.
  int *htokens, *tokens, *size;
  char *hvalues, *values;

  cudaMalloc(&tokens, sizeof(int) * 3 * h_vec.size());
  cudaMalloc(&values, sizeof(char) * 20 * h_vec.size());
  cudaMemset(values, '\0', sizeof(char) * 20 * h_vec.size());
  cudaMemset(tokens, -1, sizeof(int) * 3 * h_vec.size());
  cudaMalloc(&size, sizeof(int) * 1);
  htokens = (int *)malloc(sizeof(int) * 3 * h_vec.size());
  hvalues = (char *)malloc(sizeof(char) * 20 * h_vec.size());

  init<<<1, h_vec.size()>>>(d_str, tokens, values, size);

  cudaError_t error = cudaMemcpy(htokens, tokens, sizeof(int) * 3 * h_vec.size(), cudaMemcpyDeviceToHost);
  cudaError_t error1 = cudaMemcpy(hvalues, values, sizeof(int) * 20 * h_vec.size(), cudaMemcpyDeviceToHost);

  cudaDeviceSynchronize();

  for (int i = 0; i < 3*h_vec.size(); ++i)
    printf("%d ", htokens[i]);



  return 0;
}