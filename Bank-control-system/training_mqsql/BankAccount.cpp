#include "BankAccount.h"

#include <string>
#include <cstring>

using std::string;

BankAccount::BankAccount(int accnu, string fname, string lname, double bal)
{
	setAccountNumber(accnu);
	setFirstName(fname);
	setLastName(lname);
	setBalance(bal);
}

void BankAccount::setAccountNumber(int accnu)
{
	accountNumber = accnu;
}

void BankAccount::setFirstName(string fname)
{
	const char* fn = fname.data(); // COPYING DATA FROM STRING TO CONST CHAR
	size_t len = fname.size(); // GETTING SIZE OF STRING
	len = (len < MAX_SIZE ? len : MAX_SIZE - 1); // IF STRING LEN < 30, THEN LEN = LEN, ELSE LEN = 30 - 1
	strncpy_s(firstName, fn, len);
	firstName[len] = '\0'; // THE LASTEST ELEMENT IN ARRAY IS NULL CHARACTER
}

void BankAccount::setLastName(string lname)
{
	const char* ln = lname.data();
	size_t len = lname.size();
	len = (len < MAX_SIZE ? len : MAX_SIZE - 1);
	strncpy_s(lastName, ln, len);
	lastName[len] = '\0';
}

void BankAccount::setBalance(double bal)
{
	balance = bal;
}

int BankAccount::getAccountNumber() const
{
	return accountNumber;
}

string BankAccount::getFirstName() const
{
	return firstName;
}

string BankAccount::getLastName() const
{
	return lastName;
}

double BankAccount::getBalance() const
{
	return balance;
}

BankAccount::~BankAccount()
{

}