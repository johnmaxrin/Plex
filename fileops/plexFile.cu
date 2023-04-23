#include"plexFile.h"

thrust::host_vector<std::string> readFile(const char * fileName)
{
    std::ifstream file(fileName);

    if(!file.is_open())
    {
        printf("File not found!");
        exit(0);
    }

    std::string str;
    thrust::host_vector<std::string> h_vec;

    while (file >> str)
        h_vec.push_back(str);
    
    return h_vec;
}
