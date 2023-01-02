#include "FileExplorer.h"
#include "Disk.h"

int main()
{
	FileExplorer FileEXPLORER = FileExplorer();
	//FileEXPLORER.FE_print();
	//// number of disk to find a size...
	//FileEXPLORER.FE_disk_occupied_memory(4);
	FileEXPLORER.FE_disk_printing();

	FileEXPLORER.FE_TZ();
}