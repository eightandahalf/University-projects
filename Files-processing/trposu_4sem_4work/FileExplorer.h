#ifndef _FILE_EXPLORER_
#define _FILE_EXPLORER_
#include <vector>
#include <string>
#include "Disk.h"

int disk_totalmemory(std::vector<int>& DiskSizes);

class FileExplorer
{
private:
	int FE_disk_amount; // amount of disk in our file explorer
	int FE_all_space;   // all space available on our system
	std::vector<std::string> FE_disk_names; // list of disk names
	std::vector<int> FE_disk_sizes; // size of every single disk in our system
	std::vector<Disk> disks;
public:
	FileExplorer();
	void FE_print();
	void FE_TZ();

	void FE_disk_printing();
	int FE_disk_occupied_memory(int Disk_num);
	int FE_disk_size();
};


#endif // !_FILE_EXPLORER_