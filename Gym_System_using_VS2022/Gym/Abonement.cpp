#pragma once
#include "Abonement.h"
#include <cstdlib>
#include <time.h>
#include <iostream>
#include <random>
#include "Names.h"

Abonement::Abonement()
{
	std::vector<int>::iterator it;
	std::random_device dev;
	std::mt19937 rng(dev());
	std::uniform_int_distribution<std::mt19937::result_type> dist6(0, 5); // distribution in range [0, 5]
	/*for (int i = 0; i < ids.size(); i++)
	{
		std::cout << ids[i] << std::endl;
	}*/
	// in second iteration size will be 5, and we can get 5 like a random number
	int random_number = dist6(rng); // while 5 => 5 -> we will make new random num, like a 3. while 3 => 5
	while (random_number >= ids.size()) // 5 - 1 > 5
	{
		random_number = dist6(rng);
	}
	AB_id = ids[random_number];
	it = ids.begin() + random_number;
	ids.erase(it);
	AB_remaining_num = 8;
	AB_name = names[AB_id - 1]; // we use argument [AB_id - 1], because it has every time different value
	AB_surname = surnames[AB_id - 1];
	AB_third_name = thirdnames[AB_id - 1];
	AB_address = addresses[AB_id - 1];
	AB_instagram_account = accounts[AB_id - 1];
	AB_phone_number = phone_numbers[AB_id - 1];
}

Abonement::Abonement(char* name, char* surname, char* third_name, int id,
	char* address, char* instagram_account, char* phone_number, int remain_num)
{
	AB_name = name;
	AB_surname = surname;
	AB_third_name = third_name;
	AB_id = id;
	AB_address = address;
	AB_instagram_account = instagram_account;
	AB_phone_number = phone_number;
	AB_remaining_num = remain_num;
}

void Abonement::Miss()
{
	AB_miss_check = 0;
}

int Abonement::miss_check()
{
	return AB_miss_check;
}

void Abonement::unmiss()
{
	AB_miss_check = 1;
}
void Abonement::Visit()
{
	AB_remaining_num = AB_remaining_num - 1;
}

int Abonement::AB_check()
{
	int choice;
	if (AB_remaining_num < 1) // person doesn't have any remaining classes
	{
		std::cout << "Conductor, we have a problem, that person:" << std::endl << std::endl;
		std::cout << "=======Name==========Surname========Thirdname=======Id:=================Address====================Instagram account=======Phone number==============Remaining lessons:========\n\n";
		std::cout << "**  " << name() << "\t**  "
			<< surname() << "\t**  " << thirdname()
			<< "\t**  " << id() << "  **  " << address()
			<< "\t**  " << instagram_account()
			<< "\t**  " << phone_number() << "\t**\t    " << remaining_lessons()
			<< "\t\t*******\n" << std::endl;
		std::cout << "was taking all the classes" << std::endl;
		std::cout << "So, we have 3 ways: "
			<< "\n1. That person will add money to his gym card"
			<< "\n2. Class will start without one person"
			<< "\n3. You can add someone new\n";
		std::cin >> choice;
		while (choice < 1 && choice > 3)
		{
			std::cin.clear();
			std::cout << "Try again\n";
			std::cin >> choice;
		}
		if (choice == 1) // person will add money to him gym card
		{
			AB_remaining_num = 8;
			return 1;
		}
		if (choice == 2) { return 2; } // class will start without one person*
		if (choice == 3) { return 3; } // we will add someone new to our class
	}
}

const char * Abonement::name()
{	
	return AB_name;
}

const char* Abonement::surname()
{
	return AB_surname;
}

const char* Abonement::thirdname() 
{
	return AB_third_name;
}

int Abonement::id() const
{
	return AB_id;
}

const char* Abonement::address() 
{
	return AB_address;
}
 
const char* Abonement::instagram_account() 
{
	return AB_instagram_account;
}

const char* Abonement::phone_number() 
{
	return AB_phone_number;
}

int Abonement::remaining_lessons() const
{
	return AB_remaining_num;
}

void Abonement::remain_num(int remain_num)
{
	AB_remaining_num = remain_num;
}