#pragma once
#include <string>

class Abonement
{
private:
	int AB_id;
	int AB_remaining_num; // remaining num of 
	const char* AB_name;
	const char* AB_surname;
	const char* AB_third_name;
	const char* AB_address;
	const char* AB_instagram_account;
	const char* AB_phone_number;
	int AB_miss_check = 1;
public:
	Abonement();
	Abonement(char* name, char* surname, char* third_name, int id,
		char* address, char* instagram_account, char* phone_number, int remain_num);
	void Miss(); // func save previous amoung of remaining lessons 
	int miss_check(); // func return check value of our miss_function
	void unmiss(); // func which will return AB_miss_check in default condition
	void Visit(); // func decrease remaining lessons in 1(remain lessons - 1)
	int AB_check(); // func that give for us opportuninity to check amount of remaining lessons of our users
	int id() const; // func returning id
	const char* name();
	const char* surname();
	const char* thirdname();
	const char* address();
	const char* instagram_account();
	const char* phone_number();
	int remaining_lessons() const; // func returning remaining lessons
	void remain_num(int new_remain_num); // func that set new remain num
};

