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

void printOutput(thrust::host_vector<std::string> tokenData,thrust::host_vector<int> tokensList,double timespent)
{
    FILE *file = fopen("output.txt", "w");

    if(file == NULL)
    {
        printf("Error while creating output file!\n");
        return;
    }
    
    for(int i = 0; i<tokensList.size(); ++i)
        fprintf(file,"< %s , %d >\n",tokenData[i].c_str(),tokensList[i]);

    fprintf(file,"Execution time: %f\n",timespent);

}
