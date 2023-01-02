#ifndef _NAMES_H
#define _NAMES_H

#include <ctime>
#include <cstdlib>
#include <vector>
#include <iostream>
#include "Disk.h"

const char* DiskNames[] = { "A", "B", "C", "D", "E", "F","G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
"R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

int disk_repeat_control(std::string& name, std::vector<std::string>& names)
{
	for (int i = 0; i < names.size(); i++)
	{
		if (name == names[i]) { return 1; }
	}
	return 2;
}

const char* DiskSizes[] = { "60", "65", "70", "75", "80", "85", "90", "95", "100", "105", "110",
"115", "120", "125", "130", "135", "140", "145", "150", "155", "160", "165", "170", "175", "180", "185", "190", "195" };

int disk_size_control(int& size, std::string& name)
{
	std::cout << "Please enter a size of disk " << name << " in the range of 1 and 200 GB" << std::endl;
	std::cout << "Your input: ";
	std::cin >> size;
	while (size < 1 || size > 200)
	{
		std::cout << "Uncorrect input! Try again: " << std::endl;
		std::cin.clear();
		std::cin.ignore(INT_MAX, '\n');
		std::cout << "Your input: ";
		std::cin >> size;
	}
	return size;
}

#endif // !_NAMES_H