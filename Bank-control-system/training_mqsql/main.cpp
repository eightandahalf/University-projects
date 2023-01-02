#include <iostream>

#include "BankTransaction.h"
#include "BankAccount.h"



enum Options { PRINT = 1, NEW, WITHDRAW, DEPOSIT, CLOSE, END };

int mainMenu()
{
	std::cout << "\nMenu Options" << std::endl
		<< "1 - Print All Accoun" << std::endl
		<< "2 - Open New Account" << std::endl
		<< "3 - Withdraw" << std::endl
		<< "4 - Deposit" << std::endl
		<< "5 - Close Account" << std::endl
		<< "6 - End Transaction" << std::endl;
	int choice;
	std::cin >> choice;
	return choice;
}

int main(int argc, char** argv)
{
	BankTransaction* bt = new BankTransaction("localhost", "root", "TUAPSE2015", "mybank");
	
	int choice;
	int acnu;
	string fname, lname;
	double bal;

	while (1)
	{
		choice = mainMenu();
		if (choice == END) { break; }
		switch(choice)
		{
		case PRINT:
			bt->printAllAccounts();
			break;
		case NEW:
			std::cout << "Please Enter Account Number: \n";
			std::cin >> acnu;
			if (acnu < 1) { break; }
			std::cout << "Enter First Name: \n";
			std::cin >> fname;
			std::cout << "Enter Last Name: \n";
			std::cin >> lname;
			std::cout << "Enter Balance: \n";
			std::cin >> bal;
			bt->createAccount(new BankAccount(acnu, fname, lname, bal));
			break;
		case WITHDRAW:
			double wit_dr;
			std::cout << "Please Enter Amount Of Money To Withdraw: \n";
			std::cin >> wit_dr;
			if (wit_dr < 0) { break; }
			std::cout << "Enter Account Number: \n";
			std::cin >> acnu;
			bt->withdraw(acnu, wit_dr);
			break;
		case DEPOSIT:
			double de_si;
			std::cout << "Please Enter Amount Of Money To Deposit: \n";
			std::cin >> de_si;
			std::cout << "Enter Account Number: \n";
			std::cin >> acnu;
			bt->deposit(acnu, de_si);
			break;
		case CLOSE:
			std::cout << "Enter Account Number To Close: \n";
			std::cin >> acnu;
			bt->closeAccount(acnu);
			break;
		default:
			std::cerr << "Incorrect Input\n";
			break;
		}
	}
	return 0;
}