#include "File.h"

File::File(int file_size, std::string file_name, std::string file_type)
{
	FI_file_size = file_size;
	FI_file_name = file_name;
	FI_file_type = file_type;
}