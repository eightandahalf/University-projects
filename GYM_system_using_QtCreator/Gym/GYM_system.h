#ifndef GYM_SYSTEM_H
#define GYM_SYSTEM_H
#include <Abonement.h>
#include <vector>
#include <QtSql/QSqlQuery>
#include <QString>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include <QString>
#include "dialog.h"

class Gym_system
{
public:
    int GYM_user_amount = 6;
    Gym_system(QString HOST, QString USER, QString PASSWORD, QString DATABASE);
    void GY_main_menu();
    void GY_print(QString users, std::vector<Abonement*>& check_amount);
    void GY_admin_check();
    void query_create_account(Abonement* account, QString database);
    void query_update(Abonement* account, QString column_name, QString column_value, QString clients_database);
    void query_delete(Abonement* account, QString clients_database);
    void create_actual_database();
    void create_hidden_database();
    bool database_availability_a(QString);
    bool database_availability_h(QString);
    const char* check_input(wchar_t data[], int amount_bytes, int order_num);
    size_t Size_Of_All_Users(const std::vector<Abonement*>& actual_users, const std::vector<Abonement*>& hidden_users);
    int id_verification(int number, std::vector<Abonement*>& actual_users, std::vector<Abonement*>& hidden_users, int high_range, size_t low_range);
private:
//    MYSQL* db_conn;
    QSqlQuery* mysqlquery;
    QSqlDatabase db_conn;
};

std::string TakeAutentificationDataFromUser();

#endif // GYM_SYSTEM_H
