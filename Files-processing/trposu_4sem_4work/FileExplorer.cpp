#include <iostream>
#include <string>
#include "Random.h"
#include "Names.h"
#include "FileExplorer.h"

int disk_totalmemory(std::vector<int>& DiskSizes) {
	int result = 0;
	for (int i = 0; i < DiskSizes.size(); i++)
	{
		result += DiskSizes[i];
	}
	return result;
}


void FileExplorer::FE_print()
{
	for (int i = 0; i < FE_disk_names.size(); i++)
	{
		std::cout << "Name of " << i + 1 << " disk: " << FE_disk_names[i] << "\tSize of " << i + 1 << " disk: " << FE_disk_sizes[i];
	}
}

void FileExplorer::FE_disk_printing()
{
	for (int i = 0; i < FE_disk_amount; i++)
	{
		disks[i].DI_Print();
	}
}

FileExplorer::FileExplorer()
{
	std::random_device dev4; // Will be used to obtain a seed for the random number engine
	std::mt19937 rng4(dev4()); // Standard mersenne_twister_engine seeded with rd()

	std::string temp_name;
	int temp_size;
	std::string disk_name, disk_size_str;
	int choice, disk_size; // disk_amount - amount of all disk in our File Explorer; disk_size - size of every single disk

	std::cout << "Hello. Enter 1, if yor wanna type all data by hand, or ELSE for random: \n";

	std::cout << "Your input: ";
	std::cin >> choice;
	
	if (choice == 1) {
		std::cout << "Hey! Enter, how many disks in FILE EXPLORER do you want: " << std::endl;
		std::cout << "Your input: ";
		while (!(std::cin >> FE_disk_amount))
		{
			std::cout << "Uncorrect input! Try again: " << std::endl;
			std::cin.clear();
			std::cin.ignore(INT_MAX, '\n');
			std::cout << "Your input: ";
		}

		for (int i = 1; i <= FE_disk_amount; i++)
		{
			std::cout << "Enter name of " << i << " disk: " << std::endl;
			std::cout << "Your input: ";
			std::cin >> disk_name;
			FE_disk_names.push_back(disk_name);
			disk_size_control(disk_size, disk_name);
			FE_disk_sizes.push_back(disk_size);
		}
	}
	else
	{
		std::uniform_int_distribution<int> dist26(0, 25);
		std::uniform_int_distribution<int> dist28(0, 27);
		std::uniform_int_distribution<int> dist6(1, 6);
		FE_disk_amount = dist6(rng4);
		for (int i = 1; i <= FE_disk_amount; i++)
		{
		again: disk_name = DiskNames[dist26(rng)]; // Use `dist26` to transform the random unsigned int generated by rng into an int in [0, 25]
			if (disk_repeat_control(disk_name, FE_disk_names) == 1) { goto again; };
			FE_disk_names.push_back(disk_name);
			disk_size_str = DiskSizes[dist28(rng)];
			FE_disk_sizes.push_back(stoi(disk_size_str));
		}
		std::cin.clear(); // after NOT 1 choice in FileExplorer.h
		std::cin.ignore(INT_MAX, '\n');
	}

	FE_all_space = disk_totalmemory(FE_disk_sizes);

	for (int i = 0; i < FE_disk_amount; i++) // creation of new disks like a objects
	{
		temp_name = FE_disk_names[i];
		temp_size = FE_disk_sizes[i];
		/*std::cout << "|*********************************|" << std::endl;
		std::cout << "| Disk number | Name |    Size    |\n";
		std::cout << "|-------------+------+------------|" << std::endl;
		std::cout << "|      " << i + 1 << "      |  " << temp_name << "   |    " << temp_size << "GB   |" << std::endl;
		std::cout << "|*********************************|";*/
		disks.push_back(Disk(temp_name, temp_size, i, choice));
	}
}

int FileExplorer::FE_disk_occupied_memory(int Disk_num)
{
	int result = 0;
	for (int i = 0; i < FE_disk_sizes.size(); i++)
	{
		if ((i + 1) == Disk_num) { std::cout << "The size of disk with number " << Disk_num << " is: " << FE_disk_sizes[i] << std::endl; }
	}

	return result;
}

const char* FileTypes2[] = { ".png", ".jpg", ".jpeg", ".gif", ".pdf", ".doc", ".docx", ".xls", ".xlxs", ".ppt", ".pptx", ".txt", ".text", ".rtf", ".zip", ".rar", ".tar" };

void FileExplorer::FE_TZ()
{ 
	int choice;

		std::cout << "So, now we in FILE EXPLORER. You can make some choice: \n"
			<< "1. Find all file of certain extansion in: a)FILE EXPLORER; b)DISK; c)FOLDER\n"
			<< "2. Calculate the amount of memory occupied by files in a folder or disk\n"
			<< "3. View the contents of folders on some disk\n"
			<< "4. Exit\n";

		std::cout << "Your input: ";
		std::cin >> choice;

	do {
		while (choice != 1 && choice != 2 && choice != 3 && choice != 4)
		{
			std::cout << "Uncorrect input! Try again: " << std::endl;
			std::cin.clear();
			std::cin.ignore(INT_MAX, '\n');
			std::cout << "Your input: ";
			std::cin >> choice;
		}

		if (choice == 1) // Find all file of certain extansion in: a)FILE EXPLORER; b)DISK; c)FOLDER
		{
			std::vector<std::string> files;
			int choice2, choice_type;

			std::cout << "Please, choose type of file which you wanna find: \n1. .png    2. .jpg    3. .jpeg    4. .gif    5. .pdf\n"
				<< "6. .doc    7. .docx    8. .xls    9. .xlxs    10. .ppt\n" 
				<< "11. .pptx    12. .txt    13. .text    14. .rtf    15. .zip\n"
				<< "16. .rar    17. .tar\n";

			std::cout << "Your input: ";
			std::cin >> choice_type;
			while (choice_type < 1 || choice_type > 17)
			{
				std::cout << "Uncorrect input. Try again: " << std::endl;
				std::cin.clear();
				std::cin.ignore(INT_MAX, '\n');
				std::cout << "Your input: ";
				std::cin >> choice_type;
			}

			std::cout << "\nWhere you wanna find files?\n"
				<< "Type 1 if in all FILE EXPLORER\n"
				<< "Type 2 if in certain DISK\n"
				<< "Type 3 if in certain FOLDER in certain DISK\n";
			std::cout << "Your input: ";
			std::cin >> choice2;

			while (choice2 != 1 && choice2 != 2 && choice2 != 3)
			{
				std::cout << "Uncorrect input! Try again: " << std::endl;
				std::cin.clear();
				std::cin.ignore(INT_MAX, '\n');
				std::cout << "Your input: ";
				std::cin >> choice2;
			}

			std::cout << "\n|**************************|\n";
			std::cout << "$$$$Files with type " << FileTypes2[choice_type] << "$$$$\n";

			int count = 0;
			if (choice2 == 1)
			{
				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							if (disks[i].filetypes(j)[h] == FileTypes2[choice_type]) // 
							{
								std::cout << "|--------------------------|\n";
								files.push_back(disks[i].filenames(j)[h]);
								std::cout << "\t" << disks[i].filenames(j)[h] << FileTypes2[choice_type] << std::endl;
								count++;
							}
						}
					}
				}
				if (count == 0) { std::cout << "\nSorry(. There are not files with this type\n"; }
				else { std::cout << "|--------------------------|\n"; }
				std::cout << "\n|**************************|\n";
			}
			else if (choice2 == 2)
			{
				int choice3;
				int count1 = 0;
				std::cout << "So, we have " << FE_disk_amount << " disks number\nThey names: \n";
				for (int i = 0; i < FE_disk_amount; i++)
				{
					std::cout << i + 1 << ". " << FE_disk_names[i] << std::endl;
				}
				std::cout << "Enter number in a range [1; " << FE_disk_amount << "] to choose certain DISK\n";

				std::cout << "Your input: ";
				std::cin >> choice3;
				while ((choice3 < 1) || (choice3 > FE_disk_amount))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice3;
				}

				std::cout << "\n|**************************|\n";
				std::cout << "$$$$Files with type " << FileTypes2[choice_type] << "$$$$\n";
				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					if ((i + 1) != choice3) { continue; }
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							if (disks[i].filetypes(j)[h] == FileTypes2[choice_type]) // 
							{
								std::cout << "|--------------------------|\n";
								files.push_back(disks[i].filenames(j)[h]);
								std::cout << "\t" << disks[i].filenames(j)[h] << FileTypes2[choice_type] << std::endl;
								count1++;
							}
						}
					}
				}
				if (count1 == 0) { std::cout << "\nSorry(. There are not files with this type\n"; }
				else { std::cout << "|--------------------------|\n"; }
				std::cout << "\n|**************************|\n";
			}
			else if (choice2 == 3)
			{
				int choice4, choice5;
				int count2 = 0;
				std::cout << "So, we have " << FE_disk_amount << " disks number\nThey names: \n";
				for (int i = 0; i < FE_disk_amount; i++)
				{
					std::cout << i + 1 << ". " << FE_disk_names[i] << std::endl;
				}
				std::cout << "Enter number in a range [1; " << FE_disk_amount << "] to choose certain DISK\n";

				std::cout << "Your input: ";
				std::cin >> choice4;

				while ((choice4 < 1) || (choice4 > FE_disk_amount))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice4;
				}

				std::cout << "So, we have " << disks[choice4].DI_num_of_folder() << " folders in DISK " << disks[choice4].diskname() << "\nThey names : \n";
				for (int i = 0; i < disks[choice4].DI_num_of_folder(); i++)
				{
					std::cout << i + 1 << ". " << disks[choice4].foldername(i) << std::endl;
				}
				std::cout << "Enter number in a range [1; " << disks[choice4].DI_num_of_folder() << "] to choose certain FOLDER\n";

				std::cout << "Your input: ";
				std::cin >> choice5;

				while ((choice5 < 1) || (choice5 > disks[choice4].DI_num_of_folder()))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice5;
				}

				std::cout << "\n|**************************|\n";
				std::cout << "$$$$Files with type " << FileTypes2[choice_type] << "$$$$\n";
				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					if ((i + 1) != choice4) { continue; }
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						if ((j + 1) != choice5) { continue; }
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							if (disks[i].filetypes(j)[h] == FileTypes2[choice_type]) // 
							{
								std::cout << "|--------------------------|\n";
								files.push_back(disks[i].filenames(j)[h]);
								std::cout << "\t" << disks[i].filenames(j)[h] << FileTypes2[choice_type] << std::endl;
								count2++;
							}
						}
					}
				}
				if (count2 == 0) { std::cout << "\nSorry(. There are not files with this type\n"; }
				else { std::cout << "|--------------------------|\n"; }
				std::cout << "\n|**************************|\n";
			}

		}
		if (choice == 2) // Calculate the amount of memory occupied by files in a folder or disk
		{
			std::vector<std::string> files;
			int choice_of_place;

			std::cout << "\nWhere you wanna find occupied memory?\n"
				<< "Type 1 if in all FILE EXPLORER\n"
				<< "Type 2 if in certain DISK\n"
				<< "Type 3 if in certain FOLDER in certain DISK\n";
			std::cout << "Your input: ";
			std::cin >> choice_of_place;

			while (choice_of_place != 1 && choice_of_place != 2 && choice_of_place != 3)
			{
				std::cout << "Uncorrect input! Try again: " << std::endl;
				std::cin.clear();
				std::cin.ignore(INT_MAX, '\n');
				std::cout << "Your input: ";
				std::cin >> choice_of_place;
			}

			int occupied_memory1 = 0;
			if (choice_of_place == 1)
			{
				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							occupied_memory1 += disks[i].filesizes(j)[h];
						}
					}
				}
				std::cout << "\n|**************************************************|\n\n";
				std::cout << "    Ocuppied memory in all FILE EXPLORER: " << occupied_memory1 << "GB" << std::endl;
				std::cout << "\n|**************************************************|\n";
			}
			else if (choice_of_place == 2)
			{
				int occupied_memory2 = 0;
				int choice_disk_only;
				int count1 = 0;
				std::cout << "So, we have " << FE_disk_amount << " disks number\nThey names: \n";
				for (int i = 0; i < FE_disk_amount; i++)
				{
					std::cout << i + 1 << ". " << FE_disk_names[i] << std::endl;
				}
				std::cout << "Enter number in a range [1; " << FE_disk_amount << "] to choose certain DISK\n";

				std::cout << "Your input: ";
				std::cin >> choice_disk_only;
				while ((choice_disk_only < 1) || (choice_disk_only > FE_disk_amount))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice_disk_only;
				}

				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					if ((i + 1) != choice_disk_only) { continue; }
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							occupied_memory2 += disks[i].filesizes(j)[h];
						}
					}
				}
				std::cout << "\n|********************************|\n\n";
				std::cout << "  Ocuppied memory in DISK " << FE_disk_names[choice_disk_only - 1] << ": " << occupied_memory2 << "GB" << std::endl;
				std::cout << "\n|********************************|\n";
			}
			else if (choice_of_place == 3)
			{
				int occupied_memory3 = 0;
				int choice4, choice5;
				std::cout << "So, we have " << FE_disk_amount << " disks number\nThey names: \n";
				for (int i = 0; i < FE_disk_amount; i++)
				{
					std::cout << i + 1 << ". " << FE_disk_names[i] << std::endl;
				}
				std::cout << "Enter number in a range [1; " << FE_disk_amount << "] to choose certain DISK\n";

				std::cout << "Your input: ";
				std::cin >> choice4;

				while ((choice4 < 1) || (choice4 > FE_disk_amount))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice4;
				}

				std::cout << "So, we have " << disks[choice4 - 1].DI_num_of_folder() << " folders in DISK " << disks[choice4 - 1].diskname() << "\nThey names : \n";
				for (int i = 0; i < disks[choice4 - 1].DI_num_of_folder(); i++)
				{
					std::cout << i + 1 << ". " << disks[choice4 - 1].foldername(i) << std::endl;
				}
				std::cout << "Enter number in a range [1; " << disks[choice4 - 1].DI_num_of_folder() << "] to choose certain FOLDER\n";

				std::cout << "Your input: ";
				std::cin >> choice5;

				while ((choice5 < 1) || (choice5 > disks[choice4 - 1].DI_num_of_folder()))
				{
					std::cout << "Uncorrect input! Try again: " << std::endl;
					std::cin.clear();
					std::cin.ignore(INT_MAX, '\n');
					std::cout << "Your input: ";
					std::cin >> choice5;
				}

				for (int i = 0; i < FE_disk_amount; i++) // we in one of disk
				{
					if ((i + 1) != choice4) { continue; }
					for (int j = 0; j < disks[i].DI_num_of_folder(); j++) // we in one of folder
					{
						if ((j + 1) != choice5) { continue; }
						for (int h = 0; h < disks[i].fileamount(j); h++) // we in certain folder and we see files in this folder
						{
							occupied_memory3 += disks[i].filesizes(j)[h];
						}
					}
				}
				std::cout << "\n|********************************************************|\n\n";
				std::cout << "   Ocuppied memory in DISK " << FE_disk_names[choice4 - 1] 
					<< " in FOLDER " << disks[choice4 - 1].foldername(choice5 - 1) << ": " << occupied_memory3 << "GB" << std::endl;
				std::cout << "\n|********************************************************|\n";
			}
		}
		if (choice == 3) // View the contents of folders on some disk
		{
			int disk_choice, folder_choice;
			std::cout << "So, we have " << FE_disk_amount << " disks number\nThey names: \n";
			std::cout << "|*********************************|" << std::endl;
			std::cout << "| Disk number | Name |    Size    |\n";
			std::cout << "|-------------+------+------------|" << std::endl;
			for (int i = 0; i < FE_disk_amount; i++)
			{
				std::cout << "|      " << i + 1 << "      |  " << FE_disk_names[i] << "   |    " << FE_disk_sizes[i] << "GB   |" << std::endl;
				std::cout << "|*********************************|\n";
			}

			std::cout << "\nWhich one do you wanna open?\n";
			std::cout << "Your input: ";
			std::cin >> disk_choice;

			while ((disk_choice < 1) || (disk_choice > FE_disk_amount))
			{
				std::cout << "Uncorrect input! Try again: " << std::endl;
				std::cin.clear();
				std::cin.ignore(INT_MAX, '\n');
				std::cout << "Your input: ";
				std::cin >> disk_choice;
			}

			std::cout << "\n|*********************************************|\n";
			std::cout << "| Disk name: " << FE_disk_names[disk_choice - 1] << "\t Disk size: " << FE_disk_sizes[disk_choice - 1] << "GB" << std::endl;
			for (int i = 0; i < disks[disk_choice - 1].DI_num_of_folder(); i++)
			{
				std::cout << "|---------------------------------------------|\n";
				std::cout << "| " << i + 1 << ".\n";
				std::cout << "| Folder name: " << disks[disk_choice - 1].foldername(i) << "\n| Folder size: " 
					<< disks[disk_choice - 1].foldersize(i) << "GB\t\t\t      |" << std::endl;
			}
			std::cout << "|*********************************************|\n";

			std::cout << "\nWhich one do you wanna open?\n";
			std::cout << "Your input: ";
			std::cin >> folder_choice;

			while ((folder_choice < 1) || (folder_choice > disks[disk_choice - 1].DI_num_of_folder()))
			{
				std::cout << "Uncorrect input! Try again: " << std::endl;
				std::cin.clear();
				std::cin.ignore(INT_MAX, '\n');
				std::cout << "Your input: ";
				std::cin >> folder_choice;
			}

			std::cout << "\n|*********************************************|\n";
			std::cout << "| Folder name: " << disks[disk_choice - 1].foldername(folder_choice - 1) 
				<< "\t Folder size: " << disks[disk_choice - 1].foldersize(folder_choice - 1) << "GB" << std::endl;
			for (int i = 0; i < disks[disk_choice - 1].fileamount(folder_choice - 1); i++)
			{
				std::cout << "|---------------------------------------------|\n";
				std::cout << "| " << i + 1 << ".\n";
				std::cout << "| File name: " << disks[disk_choice - 1].filenames(folder_choice - 1)[i] << "\n| File size: "
					<< disks[disk_choice - 1].filesizes(folder_choice - 1)[i] << "GB\t\t\t      |" << std::endl;
			}
			std::cout << "|*********************************************|\n";
		}
		if (choice == 4)
		{
			std::cout << "Have a good day! See you later!\n";
			break;
		}

		std::cout << "\nYou can make some choice : \n"
			<< "1. Find all file of certain extansion in: a)FILE EXPLORER; b)DISK; c)FOLDER\n"
			<< "2. Calculate the amount of memory occupied by files in a folder or disk\n"
			<< "3. View the contents of folders on some disk\n"
			<< "4. Exit\n";
		std::cout << "Your input: ";
		std::cin >> choice; 

		while (choice != 1 && choice != 2 && choice != 3 && choice != 4)
		{
			std::cout << "Uncorrect input! Try again: " << std::endl;
			std::cin.clear();
			std::cin.ignore(INT_MAX, '\n');
			std::cin >> choice;
		}
	} while (choice != 4);
}

int FileExplorer::FE_disk_size()
{
	return FE_disk_amount;
}

