#include "Folder.h"
#include <iostream>

#include "Names3.h"
#include "Random3.h"

int Folder::fileamount()
{
	return FO_file_amount;
}

std::vector<std::string> Folder::file_names()
{
	return FO_file_names;
}

std::vector<std::string> Folder::file_types()
{
	return FO_file_types;
}

std::vector<int> Folder::file_sizes()
{
	return FO_file_sizes;
}

int folder_totalmemory(std::vector<int>& FileSizes) {
	int result = 0;
	for (int i = 0; i < FileSizes.size(); i++)
	{
		result += FileSizes[i];
	}
	return result;
}

Folder::Folder(std::string foldername, int foldersize, int& folder_number, int& rand)
{
	std::random_device dev6; // Will be used to obtain a seed for the random number engine
	std::mt19937 rng6(dev6()); // Standard mersenne_twister_engine seeded with rd()

	int type_number_in_const_char;
	int file_size;
	std::string file_name, file_type, file_size_str;
	std::string temp_name, temp_type;
	int temp_size, file_size_restriction;

	FO_folder_name = foldername;
	FO_folder_size = foldersize;

	if (folder_number != 0 && rand == 1)
	{
		std::cin.clear(); // after NOT 1 choice in FileExplorer.h
		std::cin.ignore(INT_MAX, '\n');
	}

	if (rand == 1)
	{
		std::cout << "Hey! Enter, how many file do you want: " << std::endl;

		while (!(std::cin >> FO_file_amount))
		{
			std::cout << "Uncorrect input! Try again: " << std::endl;
			std::cin.clear();
			std::cin.ignore(INT_MAX, '\n');
		}

		file_size_restriction = foldersize / FO_file_amount;

		for (int i = 1; i <= FO_file_amount; i++)
		{
			std::cout << "Enter name of " << i << " file: " << std::endl;
			std::cin >> file_name;
			FO_file_names.push_back(file_name);
			file_size_control(file_size, file_name, file_size_restriction);
			FO_file_sizes.push_back(file_size);
			type_number_in_const_char = file_type_control() - 1;
			file_type = FileTypes[type_number_in_const_char];
			FO_file_types.push_back(file_type);
		}
	}
	else
	{
		std::uniform_int_distribution<int> dist128(0, 127);
		std::uniform_int_distribution<int> dist49(0, 48);
		std::uniform_int_distribution<int> dist17(0, 16);
		std::uniform_int_distribution<int> dist7(1, 7);
		FO_file_amount = dist7(rng6);
		file_size_restriction = foldersize / FO_file_amount;

		for (int i = 1; i <= FO_file_amount; i++)
		{
			file_name = FileNames[dist128(rng3)]; // Use `dist26` to transform the random unsigned int generated by rng into an int in [0, 25]
			FO_file_names.push_back(file_name);
			file_size_str = FileSizes[dist49(rng3)];
			while (stoi(file_size_str) > file_size_restriction)
			{
				file_size_str = FileSizes[dist49(rng3)];
			}
			FO_file_sizes.push_back(stoi(file_size_str)); 
			file_type = FileTypes[dist17(rng3)];
			FO_file_types.push_back(file_type);
		}
	}

	FO_occup_memory = folder_totalmemory(FO_file_sizes);

	for (int i = 0; i < FO_file_amount; i++) // creation of new folders like a objects
	{
		temp_type = FO_file_types[i];
		temp_name = FO_file_names[i];
		temp_size = FO_file_sizes[i];
		files.push_back(File(temp_size, temp_name, temp_type));
	}
}

void Folder::FO_Print()
{
	std::cout << "Disk name: " << FO_folder_name << "\t Disk size: " << FO_folder_size << std::endl;
}
