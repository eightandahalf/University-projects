#pragma once
#include "Abonement.h"
#include "vector"
#include "mysql.h"

class Gym_system
{
public:
	int GYM_user_amount = 6;
	Gym_system(std::string HOST, std::string USER, std::string PASSWORD, std::string DATABASE);
	void GY_main_menu();
	void GY_print(std::string users, std::vector<Abonement>& check_amount);
		//void check_4(std::vector<Abonement>& users, int table_number);
	void GY_admin_check();
	void query_create_account(Abonement* account, std::string clients_database);
	void query_update(Abonement* account, std::string column_name, std::string column_value, std::string clients_database);
	void query_delete(Abonement* account, std::string clients_database);
	void create_actual_database();
	void create_hidden_database();
	bool database_availability_a(std::string);
	bool database_availability_h(std::string);
	void check_input(char data[], int amount_bytes, int order_num);
	size_t Size_Of_All_Users(const std::vector<Abonement>& actual_users, const std::vector<Abonement>& hidden_users);
	int id_verification(int number, std::vector<Abonement>& actual_users, std::vector<Abonement>& hidden_users, int high_range, size_t low_range);
private:
	MYSQL* db_conn;
};

std::string TakeAutentificationDataFromUser();
