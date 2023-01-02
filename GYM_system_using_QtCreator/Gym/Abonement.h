#ifndef ABONEMENT_H
#define ABONEMENT_H
#include <string>
#include <fcntl.h>
#include <io.h>

#pragma warning(disable:4996)

class Dialog;

class Abonement
{
private:
    int AB_Id;
    const char* AB_Name;
    const char* AB_Surname;
    const char* AB_Third_Name;
    const char* AB_Address;
    const char* AB_Instagram_Account;
    const char* AB_Phone_Number;
    int AB_Remaining_Num; // remaining num of
    int AB_miss_check = 1;
public:
    Abonement();
    Abonement(const char* Name, const char* Surname, const char* ThirdName, int Id,
        const char* Address, const char* Inst, const char* Phone, int RemainNum);
    void Miss(); // func save previous amount of remaining lessons
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

#endif // ABONEMENT_H
