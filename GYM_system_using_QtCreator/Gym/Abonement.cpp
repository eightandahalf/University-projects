#pragma once
#include "Abonement.h"
#include <cstdlib>
#include <time.h>
#include <iostream>
#include <random>
#include "Names.h"
#include <sstream>
#include <QMessageBox>
#include <QTextStream>

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
    AB_Id = ids[random_number];
    it = ids.begin() + random_number;
    ids.erase(it);
    AB_Remaining_Num = 8;
    AB_Name = names[AB_Id - 1]; // we use argument [AB_id - 1], because it has every time different value
    AB_Surname = surnames[AB_Id - 1];
    AB_Third_Name = thirdnames[AB_Id - 1];
    AB_Address = addresses[AB_Id - 1];
    AB_Instagram_Account = accounts[AB_Id - 1];
    AB_Phone_Number = phone_numbers[AB_Id - 1];
    std::cout << AB_Name << ' ' << AB_Surname << ' ' << AB_Third_Name << ' ' << AB_Address
        << ' ' << AB_Instagram_Account << ' ' << AB_Phone_Number << ' ' << std::endl;
}

Abonement::Abonement(const char* Name, const char* Surname, const char* ThirdName,
    int Id, const char* Address, const char* Inst, const char* Phone, int RemainNum)
{
    AB_Name = (new std::string(Name))->c_str();
    AB_Surname = (new std::string(Surname))->c_str();
    AB_Third_Name = (new std::string(ThirdName))->c_str();
    AB_Id = Id;
    AB_Address = (new std::string(Address))->c_str();
    AB_Instagram_Account = (new std::string(Inst))->c_str();
    AB_Phone_Number = (new std::string(Phone))->c_str();
    AB_Remaining_Num = RemainNum;
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
    AB_Remaining_Num = AB_Remaining_Num - 1;
}

int Abonement::AB_check()
{
    if (AB_Remaining_Num < 1) // person doesn't have any remaining classes
    {
        return -1;
    }
    else{
        return 100; // 100.. doesn't matter person has more than 1 available lesson
    }
}

const char* Abonement::name()
{
    return AB_Name;
}

const char* Abonement::surname()
{
    return AB_Surname;
}

const char* Abonement::thirdname()
{
    return AB_Third_Name;
}

int Abonement::id() const
{
    return AB_Id;
}

const char* Abonement::address()
{
    return AB_Address;
}

const char* Abonement::instagram_account()
{
    return AB_Instagram_Account;
}

const char* Abonement::phone_number()
{
    return AB_Phone_Number;
}

int Abonement::remaining_lessons() const
{
    return AB_Remaining_Num;
}

void Abonement::remain_num(int remain_num)
{
    AB_Remaining_Num = remain_num;
}
