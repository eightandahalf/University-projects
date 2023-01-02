#ifndef _FOLDER_H
#define _FOLDER_H

#include "File.h"
#include <string>
#include <vector>

int folder_totalmemory(std::vector<int>& FileSizes);

class Folder
{
private:
	int FO_file_amount;
	int FO_folder_size;
	int FO_occup_memory;
	std::string FO_folder_name;
	std::vector<std::string> FO_file_types;
	std::vector<std::string> FO_file_names;
	std::vector<int> FO_file_sizes;
	std::vector<File> files;
public:
	Folder(std::string foldername, int foldersize, int& folder_number, int& rand);
	void FO_Print();
	std::vector<std::string> file_names();
	std::vector<std::string> file_types();
	std::vector<int> file_sizes();
	int fileamount();
};
#endif // !_FOLDER_H
