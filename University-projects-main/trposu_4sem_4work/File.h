#pragma once
#include <iostream>
#include <string>
#include <vector>

class File
{
private:
	int FI_file_size;
	std::string FI_file_name;
	std::string FI_file_type;
public:
	File(int file_size, std::string file_name, std::string file_type);
	void FO_Print()
	{
		std::cout << "File name: " << FI_file_name << "\tFile type: " << FI_file_type << "\tFile size: " << FI_file_size << std::endl;
	}
};