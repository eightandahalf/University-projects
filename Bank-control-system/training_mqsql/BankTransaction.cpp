#include <iostream>
#include <sstream>
#include <iomanip>

#include "BankAccount.h"
#include "BankTransaction.h"

BankTransaction::BankTransaction(string HOST, string USER,
	string PASSWORD, string DATABASE)
{
	db_conn = mysql_init(NULL);
	if (!db_conn) { std::cout << "Initialization of MYSQL* handler was failed\n"; }
	db_conn = mysql_real_connect(db_conn, HOST.c_str(), USER.c_str(), PASSWORD.c_str(), DATABASE.c_str(), 0, NULL, 0);
	if (!db_conn)
	{
		message("Connection error\n");
	}
}

BankTransaction::~BankTransaction()
{
	mysql_close(db_conn);
}

void BankTransaction::createAccount(BankAccount* account)
{
	std::stringstream sql;

	sql << "INSERT INTO clients VALUES ('" << account->getAccountNumber()
		<< "','" << account->getFirstName() << "','" << account->getLastName()
		<< "','" << account->getBalance() << "');";

	if (!mysql_query(db_conn, (sql.str().c_str()))) { message("USER adding ended successfully!!!"); }
	else { message("USER adding ended unsuccessfully((("); }
}

BankAccount* BankTransaction::getAccount(int accnu) // pointer of type BankAccount to function that return info about account 
{
	BankAccount* b = NULL; // pointer of type BankAccount
	MYSQL_RES* res; // this structure represents the result of a query that returns a row
	MYSQL_ROW row; // representation of one row of data
	unsigned int col_num;
	std::stringstream sql; 
	sql << "SELECT * FROM clients WHERE account_number='"
		<< accnu << "';";

	if (!mysql_query(db_conn, (sql.str()).c_str())) // mysql_quere: 0 if success, nonzero if error
	{
		b = new BankAccount();
		res = mysql_use_result(db_conn); // retrieves a result set
		col_num = mysql_num_fields(res); // return the number of column in a mysql database
		row = mysql_fetch_row(res); // retrieves the next row from a result set	
		b->setAccountNumber(atoi(row[col_num - 4]));
		b->setFirstName(row[col_num - 3]);
		b->setLastName(row[col_num - 2]);
		b->setBalance(atof(row[col_num - 1]));
		mysql_free_result(res); // frees memory allocated for a res set by mysql_use_result
	}
	return b;
}

void BankTransaction::printAllAccounts()
{
	std::stringstream sql;
	BankAccount* b = NULL;
	sql << "SELECT * FROM clients;";
	MYSQL_RES* res;
	MYSQL_ROW row;
	if (!mysql_query(db_conn, (sql.str().c_str())))
	{
		res = mysql_use_result(db_conn);

		std::cout << std::left << std::setw(10) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< '+' << '+' << std::endl;

		std::cout << '|' << std::internal << std::setfill(' ') << std::setw(9)
			<< "Account" << '|' << std::internal << std::setfill(' ') << std::setw(20)
			<< "First Name" << '|' << std::internal << std::setfill(' ') << std::setw(20)
			<< "Last Name" << '|' << std::internal << std::setfill(' ') << std::setw(20)
			<< "Balance" << '|' << std::endl;

		std::cout << std::left << std::setw(10) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< '+' << '+' << std::endl;

		while (row = mysql_fetch_row(res))
		{
			std::cout << '|' << std::internal << std::setfill(' ') << std::setw(9)
				<< row[0] << '|' << std::internal << std::setfill(' ') << std::setw(20)
				<< row[1] << '|' << std::internal << std::setfill(' ') << std::setw(20)
				<< row[2] << '|' << std::internal << std::setfill(' ') << std::setw(20)
				<< row[3] << '|' << std::endl;
		}

		std::cout << std::left << std::setw(10) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< std::left << '+' << std::setw(21) << std::setfill('-')
			<< '+' << '+' << std::endl;

		mysql_free_result(res);
	}
	else { message("Error while printing all elements"); }
}

void BankTransaction::withdraw(int accnu, double amount)
{
	BankAccount* b = getAccount(accnu);
	if (b != NULL) {
		double prior_balance = b->getBalance();
		if (prior_balance < amount) { std::cout << "Cannot withdraw. Try lower amount\n"; } // 50 we have - 100 i wanna to get
		else
		{
			b->setBalance(b->getBalance() - amount);
			std::stringstream sql;
			sql << "UPDATE clients SET balance='" << b->getBalance() << "' WHERE account_number='" << accnu << "';";

			if (!mysql_query(db_conn, (sql.str()).c_str())) { message("Successfully update!"); }
			else { message("We have problems with WITHRDRAW!"); }
		}
	}
}

void BankTransaction::closeAccount(int accnu)
{
	BankAccount* b = getAccount(accnu);
	std::stringstream sql;
	sql << "DELETE FROM clients WHERE account_number='" << accnu << "';";
	if (!mysql_query(db_conn, (sql.str().c_str()))) { message("USER was deleted successfully!!!"); }
	else { message("USER wasn't deleted successfully(."); }
}

void BankTransaction::deposit(int accnu, double amount)
{
	std::stringstream sql;
	sql << "UPDATE clients SET balance=balance+'" << amount << "' WHERE account_number='" << accnu << "';";
	if (!mysql_query(db_conn, (sql.str().c_str()))) { message("DEPOSIT added succesfully!!!"); }
	else { message("DEPOSIT doesn't updated(."); }
}

void BankTransaction::message(string print_info)
{
	std::cout << print_info << std::endl;
}