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
#include <comdef.h>       /* from const wchar_t* to const char* */
#include <locale>
#include <array>

#include <fcntl.h>
#include <io.h>

#include "dialog.h"

#include <QCoreApplication>
#include <QtSql/QtSql>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

#include <QString>
#include <QTextStream>

#include <QMessageBox>
#include "login.h"

#pragma warning(disable:4996)

enum IN // check using in user autentification
{
    BACK_SPACE = 8,
    CAR_RETURN = 13
};

int Gym_system::id_verification(int number, std::vector<Abonement*>& actual_users, std::vector<Abonement*>& hidden_users, int high_range, size_t low_range)
{
#undef max
    bool check = false;
    int count;
    std::vector<Abonement> temp;
    for (int i = 0; i < actual_users.size(); i++) { temp.push_back(*actual_users[i]); }
    for (int i = 0; i < hidden_users.size(); i++) { temp.push_back(*hidden_users[i]); }
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
        if (temp.size() == 0)
        {
            check = true;
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

Gym_system::Gym_system(QString HOST, QString USER, QString PASSWORD, QString DATABASE)
{
    QByteArray bbb = HOST.toLocal8Bit();
    const char *host = bbb.data();

    QByteArray ccc = USER.toLocal8Bit();
    const char *user = ccc.data();

    QByteArray ddd = PASSWORD.toLocal8Bit();
    const char *password = ddd.data();

    QByteArray eee = DATABASE.toLocal8Bit();
    const char *database = eee.data();

    db_conn = QSqlDatabase::addDatabase("QMYSQL");
    db_conn.setHostName(host);
    db_conn.setUserName(user);
    db_conn.setPassword(password);
    db_conn.setDatabaseName(database);

    if(db_conn.open()){
            std::cout << "so cool" << std::endl;
    }
    else{
        std::cout << "so bad" << std::endl;
    }
}

void Gym_system::GY_main_menu()
{

    std::vector<Abonement*>::iterator it;
    std::vector<Abonement*> hidden_users;
    std::vector<Abonement*> actual_users;
    Dialog* window = new Dialog;

    //GY_admin_check(); // user verification


    // func that i can create in main window but she will get info from another object

    QSqlQuery act_query, hid_query;

    //
    // LOGIN
    //

    login * user_verification = new login();
    user_verification->setModal(true);
    if(user_verification->exec() == QDialog::DialogCode::Accepted){
        user_verification->on_login_button_clicked(user_verification);
    }
    else
    {
        exit(0);
    }

    if(!act_query.exec("select * from actual_users;"))
    {
        create_actual_database();

        for (int i = 0; i < GYM_user_amount; i++)
        {
            actual_users.push_back(new Abonement());
            query_create_account(actual_users[i], "actual_users");
        }
        window->print_table_from_mysql("actual_users");
        window->add_clients_to_combobox(actual_users);
    }
    else
    {
        std::vector<QString*> names_AR, surnames_AR, thirdnames_AR, addresses_AR, insts_AR,
            phones_AR, ids_AR, remains_AR;

        // START //
//        res = mysql_use_result(db_conn);

        QSqlQuery act_query("select * from actual_users");
        // std::cout << "so fun;" << std::endl;
        while (act_query.next())
        {
            QString* Name = new QString(act_query.value(0).toString());
            QString* Surname = new QString(act_query.value(1).toString());
            QString* ThirdName = new QString(act_query.value(2).toString());
            QString* Id = new QString(act_query.value(3).toString());
            QString* Address = new QString(act_query.value(4).toString());
            QString* Inst = new QString(act_query.value(5).toString());
            QString* Phone = new QString(act_query.value(6).toString());
            QString* Rem = new QString(act_query.value(7).toString());

            names_AR.push_back(Name);
            surnames_AR.push_back(Surname);
            thirdnames_AR.push_back(ThirdName);
            ids_AR.push_back(Id);
            addresses_AR.push_back(Address);
            insts_AR.push_back(Inst);
            phones_AR.push_back(Phone);
            remains_AR.push_back(Rem);
        }

                //mysql_free_result(res);

                for (int i = 0; i < names_AR.size(); i++)
                {
                    int id_int_a;
                    id_int_a = (*ids_AR[i]).toInt();
                    int remain_int_a;
                    remain_int_a = (*remains_AR[i]).toInt();

                    QString aaa = *names_AR[i];
                    QByteArray bbb = aaa.toLocal8Bit();
                    const char *ccc = bbb.data();

                    QString aab = *surnames_AR[i];
                    QByteArray bba = aab.toLocal8Bit();
                    const char *cca = bba.data();

                    QString aba = *thirdnames_AR[i];
                    QByteArray bab = aba.toLocal8Bit();
                    const char *cac = bab.data();

                    QString abb = *addresses_AR[i];
                    QByteArray baa = abb.toLocal8Bit();
                    const char *cbc = baa.data();

                    QString abc = *insts_AR[i];
                    QByteArray bac = abc.toLocal8Bit();
                    const char *ccb = bac.data();

                    QString acb = *phones_AR[i];
                    QByteArray bca = acb.toLocal8Bit();
                    const char *cab = bca.data();

                    // std::cout << *names_AR[i] << " " << *surnames_AR[i] << " " << *thirdnames_AR[i] << " " << id_int_a << " "
                       // << *addresses_AR[i] << " " << *insts_AR[i] << " " << *phones_AR[i] << " " << remain_int_a << std::endl;
                    actual_users.push_back(new Abonement(ccc, cca, cac, id_int_a, cbc, ccb, cab, remain_int_a));
                }

                window->print_table_from_mysql("actual_users");
                window->add_clients_to_combobox(actual_users);
                // if i go off from this cycle on next line, then temp_users will crush!!!
    }


    if(!hid_query.exec("select * from hidden_users;"))
    {
        create_hidden_database();
    }
    else // push to vector from database
    {
        std::vector<QString*> names_AR, surnames_AR, thirdnames_AR, addresses_AR, insts_AR,
            phones_AR, ids_AR, remains_AR;

        QSqlQuery hid_query("select * from hidden_users");
        // std::cout << "so fun;" << std::endl;
        while (hid_query.next())
        {
            QString* Name = new QString(hid_query.value(1).toString());
            QString* Surname = new QString(hid_query.value(2).toString());
            QString* ThirdName = new QString(hid_query.value(3).toString());
            QString* Id = new QString(hid_query.value(4).toString());
            QString* Address = new QString(hid_query.value(5).toString());
            QString* Inst = new QString(hid_query.value(6).toString());
            QString* Phone = new QString(hid_query.value(7).toString());
            QString* Rem = new QString(hid_query.value(8).toString());

            names_AR.push_back(Name);
            surnames_AR.push_back(Surname);
            thirdnames_AR.push_back(ThirdName);
            ids_AR.push_back(Id);
            addresses_AR.push_back(Address);
            insts_AR.push_back(Inst);
            phones_AR.push_back(Phone);
            remains_AR.push_back(Rem);
        }

                //mysql_free_result(res);

                for (int i = 0; i < names_AR.size(); i++)
                {
                    int id_int_a;
                    id_int_a = (*ids_AR[i]).toInt();
                    int remain_int_a;
                    remain_int_a = (*remains_AR[i]).toInt();

                    QString aaa = *names_AR[i];
                    QByteArray bbb = aaa.toLocal8Bit();
                    const char *ccc = bbb.data();

                    QString aab = *surnames_AR[i];
                    QByteArray bba = aab.toLocal8Bit();
                    const char *cca = bba.data();

                    QString aba = *thirdnames_AR[i];
                    QByteArray bab = aba.toLocal8Bit();
                    const char *cac = bab.data();

                    QString abb = *addresses_AR[i];
                    QByteArray baa = abb.toLocal8Bit();
                    const char *cbc = baa.data();

                    QString abc = *insts_AR[i];
                    QByteArray bac = abc.toLocal8Bit();
                    const char *ccb = bac.data();

                    QString acb = *phones_AR[i];
                    QByteArray bca = acb.toLocal8Bit();
                    const char *cab = bca.data();

                    // std::cout << *names_AR[i] << " " << *surnames_AR[i] << " " << *thirdnames_AR[i] << " " << id_int_a << " "
                       // << *addresses_AR[i] << " " << *insts_AR[i] << " " << *phones_AR[i] << " " << remain_int_a << std::endl;
                    hidden_users.push_back(new Abonement(ccc, cca, cac, id_int_a, cbc, ccb, cab, remain_int_a));
                }
    }

    window->exec();

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
            if (login == logins[i])
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
            std::wcout << std::endl;
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

void Gym_system::query_create_account(Abonement* account, QString database)
{
    std::stringstream sql;
    int miss = 2; // по дефолту мисс 2 - у человека есть доступные посещения для пропуска
                  // 1 - человек пропускает занятие
                  // 0 - у человека нет доступных занятий для пропуска
    sql << "INSERT INTO " << database.toStdString() << " (Name, Surname, Thirdname, Id, Address, Instagram_account, Phone_number, Remain_lessons, Miss) VALUES ('"
        << account->name() << "','" << account->surname() << "','" 	<< account->thirdname() << "','"
        << account->id() << "','" << account->address()	<< "','" << account->instagram_account()
        << "','" << account->phone_number() << "','" << account->remaining_lessons() << "','"
        << miss << "');";

    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery create_acc;
    if(create_acc.exec(convert_from_string_to_qstring))    {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while creating account");
        create_acc_mistake.exec();
    }
}

void Gym_system::create_actual_database()
{
    std::stringstream sql_act;
    sql_act << "CREATE TABLE actual_users"
       "("
         "Name              VARCHAR(150),"
         "Surname           VARCHAR(150),"
         "Thirdname         VARCHAR(150),"
         "Id                INT unsigned,"
         "Address           VARCHAR(150),"
         "Instagram_account VARCHAR(150),"
         "Phone_number      VARCHAR(150),"
         "Remain_lessons    INT unsigned,"
         "Miss		  INT unsigned"
       ") DEFAULT CHARSET=utf8;";

    std::string temp = sql_act.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery create_database;
    if(create_database.exec(convert_from_string_to_qstring))
    {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while creating actual database");
        create_acc_mistake.exec();
    }
}

void Gym_system::create_hidden_database()
{
    std::stringstream sql_hid;
    sql_hid << "CREATE TABLE hidden_users"
       "("
         "Name              VARCHAR(150),"
         "Surname           VARCHAR(150),"
         "Thirdname         VARCHAR(150),"
         "Id                INT unsigned,"
         "Address           VARCHAR(150),"
         "Instagram_account VARCHAR(150),"
         "Phone_number      VARCHAR(150),"
         "Remain_lessons    INT unsigned,"
         "Miss		  INT unsigned"
       ") DEFAULT CHARSET=utf8;";
    std::string temp = sql_hid.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery create_database;
    if(create_database.exec(convert_from_string_to_qstring))    {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while creating hidden database");
        create_acc_mistake.exec();
    }
}

bool Gym_system::database_availability_a(QString database)
{
    std::stringstream sql;
    bool available_check = false;
    sql << "\nselect * from " << database.toStdString() << " ;"; // we are trying to check availability of "actual_users" and "hidden_users" databases
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery availabiity_to_actual;
    if(availabiity_to_actual.exec(convert_from_string_to_qstring))    {
        available_check = true;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("#actual_users# database doesn't available");
        create_acc_mistake.exec();
    }
    return available_check;
}

bool Gym_system::database_availability_h(QString database)
{
    std::stringstream sql;
    bool available_check = false;
    sql << "\nselect * from " << database.toStdString() << " ;"; // we are trying to check availability of "actual_users" and "hidden_users" databases
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery availabiity_to_hidden;
    if(availabiity_to_hidden.exec(convert_from_string_to_qstring))    {
        available_check = true;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("#hidden_users# database doesn't available");
        create_acc_mistake.exec();
    }
    return available_check;
}

//const char* Gym_system::check_input(wchar_t data[], int amount_bytes, int order_num)
// if this function will return char*
// than i will have opportunity to make my code some short
//{
//#undef max
//    (void)freopen("", "w", stdout);
//    setlocale(LC_ALL, "en_US.UTF-8");

//    if (order_num == 1)
//    {
//        std::wcin.clear();
//        std::wcin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
//    }

//    int i = -1;
//    do
//    {
//        i++;
//        data[i] = _getwch();

//        if ((data[i] >= 1040 && data[i] <= 1103) || (data[i] == 44) || (data[i] >= 49 && data[i] <= 58) || (data[i] == 32))
//        {
//            std::wcout << data[i];
//        }
//        else if (data[i] == '\b' && i == 0) { i--; continue; }
//        else if (data[i] == '\b' && i != 0) { std::wcout << "\b \b"; i--; i--; } // be secure with this line
//        else if (data[i] == 13) { break; }
//        else { i--; continue; }
//    } while (i < (amount_bytes - 1));

//    data[i] = '\0';

//    (void)freopen("", "w", stdout);

//    _bstr_t a(data);

//    const char* by_check = a;

//    return by_check;
//}

//size_t Gym_system::Size_Of_All_Users(const std::vector<Abonement*>& actual_users, const std::vector<Abonement*>& hidden_users)
//{
//    size_t size;
//    size = actual_users.size() + hidden_users.size();
//    return size;
//}
