#include "GYM_system.h"
#include <iostream>
#include <vector>
#include <iomanip>		/* setw, setfill*/
#include <sstream>      /* stringstream*/
#include <stdlib.h>     /* atoi */
#include <conio.h>      /* getch */
#include "defines_and_includes.h"
#include <limits.h>       /* value for cin.ignore()*/
#include <ios>

enum IN // check using in user autentification
{
	BACK_SPACE = 8,
	CAR_RETURN = 13
};

int Gym_system::id_verification(int number, std::vector<Abonement>& actual_users, std::vector<Abonement>& hidden_users, int high_range, size_t low_range)
{
#undef max
	bool check = false;
	int count;
	std::vector<Abonement> temp;
	for (int i = 0; i < actual_users.size(); i++) { temp.push_back(actual_users[i]); }
	for (int i = 0; i < hidden_users.size(); i++) { temp.push_back(hidden_users[i]); }
	while (check == false)
	{
		for (int i = 0; i < temp.size(); i++)
		{
			count = 0;
			while (number == temp[i].id() || number > high_range || number <= low_range) {
				check = true;
				std::cin.clear();
				std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
				std::cout << "Please, enter another id\n";
				std::cin >> number;
				count++;
			}
			if (count == 0) { check = true; }
		}	
	}
	return number;
}

int check_in(int number, int low_range, int high_range)
{
	while ((number < low_range) || (number > high_range))
	{
		std::cin.clear();
		std::cout << "try again\n";
		std::cin >> number;
	}

	return number;
}

Gym_system::Gym_system(std::string HOST, std::string USER, std::string PASSWORD, std::string DATABASE)
{
	db_conn = mysql_init(NULL);
	if (!db_conn) { std::cout << "Initialization of MYSQL* handler was failed\n"; }
	else { std::cout << "Initialization of MYSQL* handler was success\n"; }
	db_conn = mysql_real_connect(db_conn, HOST.c_str(), USER.c_str(), PASSWORD.c_str(), DATABASE.c_str(), 0, NULL, 0);
	if (!db_conn) { std::cout << "Connection error\n"; }
	else { std::cout << "Connection success!!!\n"; }	
}

void Gym_system::GY_main_menu()
{
	std::vector<Abonement>::iterator it;
	std::vector<Abonement> hidden_users;
	std::vector<Abonement> actual_users;
	int checki = 1;
	int checkin;

	//std::vector<Abonement*> hidd_users;
	//Abonement* hidd_point = NULL;

	//hidd_point = new Abonement();
	//hidd_users.push_back(hidd_point);

	//GY_admin_check(); // user verification

	if (mysql_query(db_conn, "select * from actual_users;"))
	{
		create_actual_database();
		for (int i = 0; i < GYM_user_amount; i++)
		{
			actual_users.push_back(Abonement());
			query_create_account(&actual_users[i], "actual_users");
		}
	}
	else // push to vector from database
	{
		MYSQL_RES* res;
		MYSQL_ROW row_act;
		std::vector<char*> names_a, surnames_a, thirdnames_a, ids_a, addresses_a, inst_accounts_a, phone_numbers_a, remain_lessons_a;
		// START //
		res = mysql_use_result(db_conn);
		while (row_act = mysql_fetch_row(res))
		{
			names_a.push_back(row_act[1]);
			surnames_a.push_back(row_act[2]);
			thirdnames_a.push_back(row_act[3]);
			ids_a.push_back(row_act[4]);
			addresses_a.push_back(row_act[5]);
			inst_accounts_a.push_back(row_act[6]);       ///////////   ACTUAL USERS     ///////////
			phone_numbers_a.push_back(row_act[7]);
			remain_lessons_a.push_back(row_act[8]);
		}
		int id_int_a;
		int remain_int_a;
		for (int i = 0; i < names_a.size(); i++)
		{
			id_int_a = (int)ids_a[i];
			remain_int_a = (int)remain_lessons_a[i];
			actual_users.push_back(Abonement(names_a[i], surnames_a[i], thirdnames_a[i], id_int_a, addresses_a[i], inst_accounts_a[i], phone_numbers_a[i], remain_int_a));
		}
		mysql_free_result(res);
	}

	if (mysql_query(db_conn, "select * from hidden_users;"))
	{ // START //
		create_hidden_database();
	}
	else
	{
		MYSQL_RES* res;
		MYSQL_ROW row_hid;
		std::vector<char*> names_h, surnames_h, thirdnames_h, ids_h, addresses_h, inst_accounts_h, phone_numbers_h, remain_lessons_h;
		res = res = mysql_use_result(db_conn);
		bool available_check_hid = database_availability_h("hidden_users");
		while (row_hid = mysql_fetch_row(res))
		{
			names_h.push_back(row_hid[1]);
			surnames_h.push_back(row_hid[2]);
			thirdnames_h.push_back(row_hid[3]);
			ids_h.push_back(row_hid[4]);
			addresses_h.push_back(row_hid[5]);
			inst_accounts_h.push_back(row_hid[6]);            ///////////      HIDDEN USERS       //////////
			phone_numbers_h.push_back(row_hid[7]);
			remain_lessons_h.push_back(row_hid[8]);
		}
		int id_int_h;
		int remain_int_h;
		for (int i = 0; i < names_h.size(); i++)
		{
			id_int_h = (int)ids_h[i];
			remain_int_h = (int)remain_lessons_h[i];
			hidden_users.push_back(Abonement(names_h[i], surnames_h[i], thirdnames_h[i], id_int_h, addresses_h[i], inst_accounts_h[i], phone_numbers_h[i], remain_int_h));
		}
		mysql_free_result(res);
	}

	GY_print("actual_users", actual_users);

	while (checki)
	{
		std::cout << "Hello. Please, choose action which: " << std::endl;
		std::cout << "1. All came. 2. Let's start a training. 3. Miss 4. Add lessons to member 5. Add member"
			<< " 6. Print MEMBERS 7.Exit" << std::endl;

		std::cin >> checkin;
		int choice = check_in(checkin, 1, 7);
		int j = 1;
		if (choice == 1) // all came to our lesson
		{
			for (int i = 0; i < actual_users.size(); i++)
			{
				int check = actual_users[i].AB_check(); // checking of our members to remain lessons

				if (check == 1) {
					actual_users[i].remain_num(8);
					query_update(&actual_users[i], "Remain_lessons", "8", "actual_users");
					actual_users[i].Visit();
					std::stringstream remain;
					std::string remain_s;
					remain << actual_users[i].remaining_lessons();
					remain >> remain_s;
					query_update(&actual_users[i], "Remain_lessons", remain_s, "actual_users");
				} // member doesn't have remain lessons, but he add money to his card
				else if (check == 2)
				{
					it = actual_users.begin() + i;
					hidden_users.push_back(actual_users[i]);
					query_create_account(&actual_users[i], "hidden_users");
					query_delete(&actual_users[i], "actual_users");
					actual_users.erase(it);
					i--;
					//hidden_users.push_back(actual_users.pop_back());
				} // member doesn't have remain lessons and he doesn't add money to his card, 
				  //and we don't have new member to add
				else if (check == 3) // member doesn't have remain lessons and we will add new member
				{
#undef max
					size_t size_of_all_users;
					size_t users_amount = actual_users.size();
					it = actual_users.begin() + i; // hide previous user 
					hidden_users.push_back(actual_users[i]);
					query_create_account(&actual_users[i], "hidden_users");
					query_delete(&actual_users[i], "actual_users");
					actual_users.erase(it);
					i--;
					int id;
					char name[25], surname[25], third_name[30], address[50], instagram_account[30], phone_number[25];
					std::cout << "\nPlease enter name of new member: ";
					check_input(name, 25, 1);
					std::cout << name << std::endl;
					std::cout << "Surname: ";
					check_input(surname, 25, NULL);
					std::cout << surname << std::endl;
					std::cout << "Thirdname: ";
					check_input(third_name, 30, NULL);
					std::cout << third_name << std::endl;
					{
						size_of_all_users = Size_Of_All_Users(actual_users, hidden_users);
						std::cout << "Please, enter id of a new member in a range between (" << size_of_all_users
							<< "; 1000]: " << std::endl;
						std::cin >> checkin;
						id = id_verification(checkin, actual_users, hidden_users, 1000, size_of_all_users);
					}
					std::cout << id << std::endl;
					std::cout << "Address: ";
					check_input(address, 50, 1);
					std::cout << address << std::endl;
					std::cout << "Instagram account: ";
					check_input(instagram_account, 30, NULL);
					std::cout << instagram_account << std::endl;
					std::cout << "Phone number: ";
					check_input(phone_number, 25, NULL);
					std::cout << phone_number << std::endl;
					actual_users.push_back(Abonement(name, surname, third_name, id, address, instagram_account, phone_number, 8));
					query_create_account(&actual_users[users_amount - 1], "actual_users");  // be secure, may be mistake in this place
				}

				if (check == 2 || check == 3 || check == 1) { ; }
				else 
				{ 
					std::stringstream remain;
					std::string remain_s;
					actual_users[i].Visit(); 
					remain << actual_users[i].remaining_lessons();
					remain >> remain_s;
					query_update(&actual_users[i], "Remain_lessons", remain_s, "actual_users"); 
				}
			}
			for (int i = 0; i < actual_users.size(); i++) // that people that mark like a miss, wouldn't be miss lesson
				// twice in two lesson in a row
			{
				actual_users[i].unmiss();
			}
			GY_print("actual_users", actual_users);
		}
		else if (choice == 2) // let's start our lesson
		{
			for (int i = 0; i < actual_users.size(); i++)
			{
				if (actual_users[i].miss_check() == 1)
				{
					actual_users[i].Visit();
					std::stringstream remain;
					std::string remain_s;
					remain << actual_users[i].remaining_lessons();
					remain >> remain_s;
					query_update(&actual_users[i], "Remain_lessons", remain_s, "actual_users");
				}
				else { ; }
			}
			for (int i = 0; i < actual_users.size(); i++)
			{
				actual_users[i].unmiss();
			}
			GY_print("actual_users", actual_users);
		}
		else if (choice == 3) // miss
		{
			int id_miss;
			GY_print("actual_users", actual_users);
			std::cout << "\nPlease, choose a member which will miss our lesson.\n"
				<< "To make this type A NUMBER of that user\n";
			std::cin >> id_miss;
			if (actual_users.size() == 0) { std::cout << "We don't have member to start our lesson\n"; }
			{
				while ((id_miss < 1) && (id_miss > actual_users.size())) // some stuff with ??????? may be more clear
				{
					std::cout << "You make a mistake, please try again\n";
					std::cin.clear();
					std::cin >> id_miss;
				}
				actual_users[id_miss - 1].Miss();
				std::cout << "\nMember " << actual_users[id_miss - 1].name() << " "
					<< actual_users[id_miss - 1].surname() << " "
					<< actual_users[id_miss - 1].thirdname() << " with id "
					<< actual_users[id_miss - 1].id() << " will be miss\n" << std::endl;
			}
		}
		else if (choice == 4) // add new lessons to our members
		{
			int choice;
			std::vector<Abonement>::iterator it_hidden;
			std::cout << "That user locate in our actual table, or that user visited our lessons many days ago?\n"
				<< "Type 1, if in ACTUAL TABLE, or ELSE many days ago\n";
			std::cin >> choice;

			if (choice == 1) // actual table
			{
				int id_add_lessons;
				if (actual_users.size() == 0) { std::cout << "We don't have members from ACTUAL TABLE to add new lessons to them\n"; }
				else {
					GY_print("actual_users", actual_users);
					std::cout << "\nPlease, choose a member which will wanna to add lesson.\n"
						<< "To make this type A NUMBER of that user\n";
					std::cin >> id_add_lessons;
					while ((id_add_lessons < 1) && (id_add_lessons > actual_users.size())) // some stuff with ??????? may be more clear
					{
						std::cout << "You make a mistake, please try again\n";
						std::cin.clear();
						std::cin >> id_add_lessons;
					}
					if (actual_users[id_add_lessons - 1].remaining_lessons() < 3)
					{
						actual_users[id_add_lessons - 1].remain_num(8);
						query_update(&actual_users[id_add_lessons - 1], "Remain_lessons", "8", "actual_users");
						std::cout << "\n The new number of remain lessons of member " << actual_users[id_add_lessons - 1].name() << " "
							<< actual_users[id_add_lessons - 1].surname() << " "
							<< actual_users[id_add_lessons - 1].thirdname() << " with id "
							<< actual_users[id_add_lessons - 1].id() << " will be " << actual_users[id_add_lessons - 1].remaining_lessons()
							<< " lessons\n" << std::endl;
					}
					else { std::cerr << "Mistake. User have more than 3 remain lessons, because you can not add to them new lessons\n"; }
				}
			}
			else // hidden table
			{
				int id_add_lessons;
				if (actual_users.size() == 6)
				{
					std::cout << "Sorry, ACTUAL LESSON is full of members!!!\n";
				}
				else {
					if (hidden_users.size() == 0) { std::cout << "We don't have members from HIDDEN TABLE to add new lessons to them\n"; }
					else {
						GY_print("hidden_users", hidden_users);
						std::cout << "\nPlease, choose a member which will wanna to add lesson.\n"
							<< "To make this type A NUMBER of that user\n";
						std::cin >> id_add_lessons;
						while ((id_add_lessons < 1) && (id_add_lessons > hidden_users.size())) // some stuff with ??????? may be more clear
						{
							std::cout << "You make a mistake, please try again\n";
							std::cin.clear();
							std::cin >> id_add_lessons;
						}
						if (hidden_users[id_add_lessons - 1].remaining_lessons() < 3)
						{
							hidden_users[id_add_lessons - 1].remain_num(8);
							query_update(&hidden_users[id_add_lessons - 1], "Remain_lessons", "8", "hidden_users");
							std::cout << "\n The new number of remain lessons of member " << hidden_users[id_add_lessons - 1].name() << " "
								<< hidden_users[id_add_lessons - 1].surname() << " "
								<< hidden_users[id_add_lessons - 1].thirdname() << " with id "
								<< hidden_users[id_add_lessons - 1].id() << " will be " << hidden_users[id_add_lessons - 1].remaining_lessons()
								<< " lessons\n" << std::endl;
							it_hidden = hidden_users.begin() + id_add_lessons - 1;
							actual_users.push_back(hidden_users[id_add_lessons - 1]);
							query_create_account(&hidden_users[id_add_lessons - 1], "actual_users");
							hidden_users.erase(it_hidden);
							query_delete(&hidden_users[id_add_lessons - 1], "hidden_users");
						}
						else { std::cerr << "Mistake. User have more than 3 remain lessons, because you can not add to them new lessons\n"; }
					}
				}
			}
		}
		else if (choice == 5) // add members
		{
			if (actual_users.size() < 6)
			{
#undef max
				int id;
				size_t size_of_all_users;
				size_t users_amount = actual_users.size();
				char name[25], surname[25], third_name[30], address[50], instagram_account[30], phone_number[25];
				std::cout << "\nPlease enter name of new member: ";
				check_input(name, 25, 1);
				std::cout << name << std::endl;
				std::cout << "Surname: ";
				check_input(surname, 25, NULL);
				std::cout << surname << std::endl;
				std::cout << "Thirdname: ";
				check_input(third_name, 30, NULL);
				std::cout << third_name << std::endl;
				{	
					size_of_all_users = Size_Of_All_Users(actual_users, hidden_users);
					std::cout << "Please, enter id of a new member in a range between (" << size_of_all_users
					<< "; 1000]: " << std::endl;
					std::cin >> checkin; 
					id = id_verification(checkin, actual_users, hidden_users, 1000, size_of_all_users);
				}
				std::cout << id << std::endl;
				std::cout << "Address: ";
				check_input(address, 50, 1);
				std::cout << address << std::endl;
				std::cout << "Instagram account: ";
				check_input(instagram_account, 30, NULL);
				std::cout << instagram_account << std::endl;
				std::cout << "Phone number: ";
				check_input(phone_number, 25, NULL);
				std::cout << phone_number << std::endl;
				actual_users.push_back(Abonement(name, surname, third_name, id, address, instagram_account, phone_number, 8));
				query_create_account(&actual_users[users_amount], "actual_users");
			}
			else if (actual_users.size() == 6)
			{
				std::cout << "Sorry. Our class is full, you can not add new member\n";
			}
		}
		else if (choice == 6) // print table
		{
		GY_print("actual_users", actual_users);
		}
		else if (choice == 7)
		{
			exit(0);
		}
	}
}

void Gym_system::GY_admin_check()
{
	std::vector <std::string> logins = { "gleb", "admin", "couch" };
	std::vector <std::string> passwords = { "iamgleb", "iamadmin", "iamcouch" };
	std::string login;
	std::string password;
	bool admin_check = false;

	while (!admin_check)
	{
		std::cout << "Please, enter login: \n";
		login = TakeAutentificationDataFromUser();
		for (int i = 0; i < logins.size(); i++)
		{
			if(login == logins[i])
			{
				std::cout << "Please, enter password: \n";
				password = TakeAutentificationDataFromUser();
				if (password == passwords[i]) { admin_check = true; }
			}
		}
		if (!admin_check) { std::cout << "\nUncorrect input. Try again.\n\n"; }
	}
}

std::string TakeAutentificationDataFromUser()
{
	char ch;
	std::string data;
	bool loop = true;
	while (loop)
	{
		ch = _getch();
		if ((int)ch == 0)
		{
			ch = _getch();
			switch (ch) {
			case KEY_F1: continue; // f1
			case KEY_F2: continue; // f2
			case KEY_F3: continue; // f3
			case KEY_F4: continue; // f4
			case KEY_F5: continue; // f5
			case KEY_F6: continue; // f6
			case KEY_F7: continue; // f7
			case KEY_F8: continue; // f8
			case KEY_F9: continue; // f9
			case KEY_F10: continue; // f10
			default: continue;
			}
		}
		if ((int)ch == -32) // navigation keys
		{
			ch = _getch();
			switch (ch) {
			case KEY_UP: continue; // up
			case KEY_DOWN: continue; // down
			case KEY_LEFT: continue; // left
			case KEY_RIGHT: continue; // right
			case KEY_DELETE: continue; // delete
			case KEY_INS: continue; // right
			case KEY_PRTSC: continue; // delete
			default: continue;
			}
		}
		else if ((int)ch == KEY_ESCAPE || (int)ch == KEY_SPACE || (int)ch == KEY_TAB) // escape, space, tab
		{
			continue;
		}
		else if (ch == BACK_SPACE && data.size() != 0) // you enter backspace and size of string not equal to zero
		{
			std::cout << "\b \b";
			data.pop_back();
		}
		else if (ch == BACK_SPACE && data.size() == 0) // you enter backspace and size of string equl to zero
		{
			continue;
		}
		else if (ch == CAR_RETURN) // you enter enter
		{
			std::cout << std::endl;
			return data;
		}
		else
		{
			data.push_back(ch);
			std::cout << '*';
		}
	}
	return data;
}


void Gym_system::GY_print(std::string users, std::vector<Abonement>& check_amount)
{
	if (check_amount.size() < 1) { std::cout << "\nSorry, but we can't start our lesson, because there are not members..\n\n"; }
	else {
		std::stringstream sql;
		sql << "select * from " << users << " ;";
		MYSQL_RES* res;
		MYSQL_ROW row;
		if (!mysql_query(db_conn, sql.str().c_str()))
		{
			res = mysql_use_result(db_conn);

			std::cout << std::left << std::setw(9) << std::setfill('-')		// number
				<< '+' << std::left << std::setw(10) << std::setfill('-')	// name
				<< '+' << std::left << std::setw(14) << std::setfill('-')  // surname
				<< '+' << std::left << std::setw(14) << std::setfill('-')   // thirdname
				<< '+' << std::left << std::setw(7) << std::setfill('-')    // id
				<< '+' << std::left << std::setw(59) << std::setfill('-')   // address
				<< '+' << std::left << std::setw(21) << std::setfill('-')   // instagram account
				<< '+' << std::left << std::setw(16) << std::setfill('-')    // phone number
				<< '+' << std::left << std::setw(17) << std::setfill('-') << '+' << '+' << std::endl; // remain lessons
			std::cout << '|' << std::left << std::setfill(' ') << std::setw(8) << "Number"
				<< '|' << std::left << std::setfill(' ') << std::setw(9) << "Name"
				<< '|' << std::left << std::setfill(' ') << std::setw(13) << "Surname"
				<< '|' << std::left << std::setfill(' ') << std::setw(13) << "Thirdname"
				<< '|' << std::left << std::setfill(' ') << std::setw(6) << "Id"
				<< '|' << std::left << std::setfill(' ') << std::setw(58) << "Address"
				<< '|' << std::left << std::setfill(' ') << std::setw(20) << "Instagram_account"
				<< '|' << std::left << std::setfill(' ') << std::setw(15) << "Phone_number"
				<< '|' << std::left << std::setfill(' ') << std::setw(16) << "Remain_lessons"
				<< '|' << std::endl;
			std::cout << std::left << std::setw(9) << std::setfill('-')		// number
				<< '+' << std::left << std::setw(10) << std::setfill('-')	// name
				<< '+' << std::left << std::setw(14) << std::setfill('-')  // surname
				<< '+' << std::left << std::setw(14) << std::setfill('-')   // thirdname
				<< '+' << std::left << std::setw(7) << std::setfill('-')    // id
				<< '+' << std::left << std::setw(59) << std::setfill('-')   // address
				<< '+' << std::left << std::setw(21) << std::setfill('-')   // instagram account
				<< '+' << std::left << std::setw(16) << std::setfill('-')    // phone number
				<< '+' << std::left << std::setw(17) << std::setfill('-') << '+' << '+' << std::endl; // remain lessons
			while (row = mysql_fetch_row(res))
			{
				std::cout << '|' << std::setfill(' ') << std::left << std::setw(8) << row[0]
					<< '|' << std::setfill(' ') << std::left << std::setw(9) << row[1]
					<< '|' << std::setfill(' ') << std::left << std::setw(13) << row[2]
					<< '|' << std::setfill(' ') << std::left << std::setw(13) << row[3]
					<< '|' << std::setfill(' ') << std::left << std::setw(6) << row[4]
					<< '|' << std::setfill('_') << std::left << std::setw(58) << row[5]
					<< '|' << std::setfill(' ') << std::left << std::setw(20) << row[6]
					<< '|' << std::setfill(' ') << std::left << std::setw(15) << row[7]
					<< '|' << std::setfill(' ') << std::left << std::setw(16) << row[8]
					<< '|' << std::endl;
			}
			std::cout << std::left << std::setw(9) << std::setfill('-')		// number
				<< '+' << std::left << std::setw(10) << std::setfill('-')	// name
				<< '+' << std::left << std::setw(14) << std::setfill('-')  // surname
				<< '+' << std::left << std::setw(14) << std::setfill('-')   // thirdname
				<< '+' << std::left << std::setw(7) << std::setfill('-')    // id
				<< '+' << std::left << std::setw(59) << std::setfill('-')   // address
				<< '+' << std::left << std::setw(21) << std::setfill('-')   // instagram account
				<< '+' << std::left << std::setw(16) << std::setfill('-')    // phone number
				<< '+' << std::left << std::setw(17) << std::setfill('-') << '+' << '+' << std::endl; // remain lessons

			mysql_free_result(res);
		}
		else { std::cout << "Error while printing all elements" << std::endl; }
	}
}

void Gym_system::query_create_account(Abonement* account, std::string clients_database)
{
	std::stringstream sql;
	//mysql_set_character_set(db_conn, "utf8");
	//sql << "INSERT INTO " << clients_database << " (Name, Surname, Thirdname, Id, Address, Instagram_account, Phone_number, Remain_lessons) VALUES('ffff','арбузов','николаевич','5','минск, проспект победителей','svytoydavid','+3754451232','8');";
	/*std::cout << account->name() << ".." << sizeof(account->name()) << std::endl;
	std::cout << account->surname() << ".." << sizeof(account->surname()) << std::endl;
	std::cout << account->thirdname() << ".." << sizeof(account->thirdname()) << std::endl;
	std::cout << account->id() << ".." << sizeof(account->id()) << std::endl;
	std::cout << account->address() << ".." << sizeof(account->address()) << std::endl;
	std::cout << account->instagram_account() << ".." << sizeof(account->instagram_account()) << std::endl;
	std::cout << account->phone_number() << ".." << sizeof(account->phone_number()) << std::endl;
	std::cout << account->remaining_lessons() << ".." << sizeof(account->remaining_lessons()) << std::endl;*/


	sql << "INSERT INTO " << clients_database << " (Name, Surname, Thirdname, Id, Address, Instagram_account, Phone_number, Remain_lessons) VALUES('"
		<< account->name() << "','" << account->surname()
		<< "','" << account->thirdname() << "','" << account->id() << "','" << account->address()
		<< "','" << (account->instagram_account()) << "','" << account->phone_number()
		<< "','" << account->remaining_lessons() << "');";
	if (!mysql_query(db_conn, (sql.str().c_str()))) { ; }
	else { std::cout << "USER adding ended unsuccessfully(((" << std::endl; }
}

void Gym_system::query_update(Abonement* account, std::string column_name, std::string column_value, std::string clients_database)
{
	std::stringstream sql;
	int push_int;
	if(column_name == "Remain_lessons") // if column_value is int 
	{ 
		push_int = std::stoi(column_value);
		sql << "UPDATE " << clients_database << " SET " << column_name << " = " << push_int << " WHERE Id = " << account->id() << "; ";
	}
	else  // if column_value string
	{ 
		sql << "UPDATE " << clients_database << " SET " << column_name << " = " << column_value << " WHERE Id = " << account->id() << ";";
	}
	if (!mysql_query(db_conn, (sql.str().c_str()))) { ; }
	else { std::cout << "USER updating ended unsuccessfully(((" << std::endl; }
}

void Gym_system::query_delete(Abonement* account, std::string clients_database)
{
	std::stringstream sql;
	//mysql_set_character_set(db_conn, "utf8");
	//sql << "INSERT INTO clients VALUES('1','глеб','арбузов','николаевич','5','минск, проспект победителей','svytoydavid','+3754451232','8');";
	sql << "DELETE FROM " << clients_database << " WHERE Id = " << account->id() << ";";
	if (!mysql_query(db_conn, (sql.str().c_str()))) { ; }
	else { std::cout << "USER deleting ended unsuccessfully(((" << std::endl; }
}

void Gym_system::create_actual_database()
{
	std::stringstream sql_act;
	sql_act << "CREATE TABLE actual_users"
		" ("
		" Number            INT unsigned AUTO_INCREMENT,"
		" Name              VARCHAR(150),"
		" Surname           VARCHAR(150),"
		" Thirdname         VARCHAR(150),"
		" Id                INT unsigned,"
		" Address           VARCHAR(150),"
		" Instagram_account VARCHAR(150),"
		" Phone_number      VARCHAR(150),"
		" Remain_lessons    INT unsigned,"
		" PRIMARY KEY(Number)"
		" ); ";
	if (!mysql_query(db_conn, sql_act.str().c_str())) { ; }
	else { std::cout << "actual_users doesn't created((((" << std::endl; }
}
void Gym_system::create_hidden_database()
{
	std::stringstream sql_hid;
	sql_hid << "CREATE TABLE hidden_users"
		" ("
		" Number            INT unsigned AUTO_INCREMENT,"
		" Name              VARCHAR(150),"
		" Surname           VARCHAR(150),"
		" Thirdname         VARCHAR(150),"
		" Id                INT unsigned,"
		" Address           VARCHAR(150),"
		" Instagram_account VARCHAR(150),"
		" Phone_number      VARCHAR(150),"
		" Remain_lessons    INT unsigned,"
		" PRIMARY KEY(Number)"
		" ); ";
	if (!mysql_query(db_conn, sql_hid.str().c_str())) { ; }
	else { std::cout << "hidden_users doesn't created((((" << std::endl; }	
}

bool Gym_system::database_availability_a(std::string database)
{
	std::stringstream sql;
	bool available_check = false;
	sql << "\nselect * from " << database << " ;"; // we are trying to check availability of "actual_users" and "hidden_users" databases
	{
		if (!mysql_query(db_conn, sql.str().c_str()))
		{
			std::cout << "aaa" << std::endl;
			available_check = true;
		}
	}
	return available_check;
}

bool Gym_system::database_availability_h(std::string database)
{
	std::stringstream sql;
	bool available_check = false;
	sql << "\nselect * from " << database << " ;"; // we are trying to check availability of "actual_users" and "hidden_users" databases
	{
		if (!mysql_query(db_conn, sql.str().c_str()))
		{
			std::cout << "hhh" << std::endl;
			available_check = true;
		}
	}
	return available_check;
}

void Gym_system::check_input(char data[], int amount_bytes, int order_num)
{
#undef max
	if (order_num == 1)
	{
		std::cin.clear();
		std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
	}
	/*std::string s;
	std::getline(std::cin, s, '\n');
	for (int i = 0; i < s.size(); i++)
	{
		std::cout << s[i];
	}
	const char* str = s.c_str();
	std::cout << str;
	return str;*/
	std::string s;
	std::cin.getline(data, amount_bytes, '\n');
	s = data;
	size_t size = s.size();
	for (int i = 0; i < size; i++)
	{
		std::cout << data[i];
	}
}

size_t Gym_system::Size_Of_All_Users(const std::vector<Abonement>& actual_users, const std::vector<Abonement>& hidden_users)
{
	size_t size;
	size = actual_users.size() + hidden_users.size();
	return size;
}