#ifndef _DISK_H
#define _DISK_H
#include "Folder.h"
#include <vector>
#include <string>

int folders_in_disk_totalmemory(std::vector<int>& FolderSizes);

class Disk
{
private:
	int DI_disk_size;
	int DI_folder_amount;
	int DI_occup_memory;
	std::string DI_disk_name;
	std::vector<std::string> DI_folder_names;
	std::vector<int> DI_folder_sizes;
	std::vector<Folder> folders;
public:
	Disk(std::string diskname, int disksize, int& disk_number, int& rand);
	void DI_Print();
	void DI_disk_printing();
	int DI_num_of_folder();
	std::vector<std::string> filenames(int i);
	std::vector<std::string> filetypes(int i);
	std::vector<int> filesizes(int i);
	int fileamount(int i);
	std::string diskname();
	std::string foldername(int i);
	int foldersize(int i);
};

#endif // !_DISK_H