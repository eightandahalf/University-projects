#ifndef _NAMES2_H_
#define _NAMES2_H_
#include <ctime>
#include <cstdlib>
#include <vector>
#include <iostream>

int folder_repeat_control(std::string& name, std::vector<std::string>& names)
{
	for (int i = 0; i < names.size(); i++)
	{
		if (name == names[i]) { return 1; }
	}
	return 2;
}

int folder_size_control(int& size, std::string& name, int& folder_size_restriction)
{
	std::cout << "Please enter a size of folder " << name << std::endl;
	std::cin >> size;
	while (size < 1 || size > folder_size_restriction)
	{
		std::cout << "The size of the folder is larger than you are allowed Try again: " << std::endl;
		std::cin.clear();
		std::cin.ignore(INT_MAX, '\n');
		std::cin >> size;
	}
	return size;
}

const char* FolderNames[] = { "Stuff", "Work", "Home", "Travel", "Family", "Hobby","Self_Education", "BSUIR", "OSAP", "TRPOSU", "SVSU", "TVIMS", "MATH", "Cherno",
"Download", "Windows", "Program Files", "Documents", "Desktop", "Pictures", "Videos", "Adobe Photoshop", "Visual Studio", "History", "Health", "Literature",
"World", "Study", "School", "People", "Job", "Government", "Thought", "Technology", "Army", "Environment", "Marketing", "News"
};

const char* FolderSizes[] = { "1", "5", "2", "3", "4", "6", "7", "8", "9", "11", "12", "14", "10", "15", "20", "25", "30", "35", "40", "45", 
"50", "55", "60", "65", "70", "75", "42", "34", "22", "33", "44", "54", "61", "15", "12", "17", "13", "23", "14", "18", "19", "21", "16", "26", "37", 
"43", "53", "56", "65" };

#endif // !_NAMES2_H_