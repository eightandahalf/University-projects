#pragma once
#ifndef BANKTRANSACTION_H
#define BANKTRANSACTION_H

#include <mysql.h>
#include <string>

using std::string;

class BankAccount;

class BankTransaction
{
public:
	BankTransaction(string = "localhost", string = "",
		string = "", string = "");
	~BankTransaction();
	void createAccount(BankAccount*);
	void closeAccount(int);
	void deposit(int, double);
	void withdraw(int, double);
	BankAccount* getAccount(int);
	void printAllAccounts();
	void message(string);
private:
	MYSQL* db_conn;
};

#endif // !BANKTRANSACTION_H
