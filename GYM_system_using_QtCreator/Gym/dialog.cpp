#include "dialog.h"
#include "ui_dialog.h"
#include <QMessageBox>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include "choice_of_client_with_low_visits.h"

#include <QCoreApplication>
#include <QtSql/QtSql>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

#include <iostream>
#include <sstream>
#include "new_user.h"

#include <comdef.h>

#include "table_to_update.h"
#include "number_of_clients_choice.h"

Dialog::Dialog(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::Dialog)
{
    ui->setupUi(this);
}

Dialog::~Dialog()
{
    delete ui;
}

int Dialog::choice_of_user_with_low_classes(Abonement& user) // from this func i should get VARIANT to func on_make_button
{
    std::stringstream sql;
    sql << "Conductor, we have a problem, that person:\n" << user.name() << " " << user.surname() << " "
           << user.surname() << " with id: -" << user.id() << "-, address: " << user.address() << ", instagram:  "
           << user.instagram_account() << ", and phone number: " << user.phone_number() << " was taking all the classes!!!";
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QMessageBox::warning(this, "Next step", convert_from_string_to_qstring);

    choice_of_client_with_low_visits* sec_window = new choice_of_client_with_low_visits;
    sec_window->setModal(true);
    sec_window->exec();

    int to_print_value = sec_window->on_OK_btn_clicked();
    //
    // я могу считать сумму выделеных чекбоксов. если сумма два, то сразу заново. и только в случае единицы я могу извлекать
    // чекбокс в котором был нажат крестик
    // и по сути мне нужно это окно, чтобы просто получить значение. поэтому окно может иметь сигнал reject при нажатии на обе
    // кнопки. оно только должно возвращать значения выделенных чекбоксов
    //
    //

    while(to_print_value > 3)
    {
        QMessageBox::warning(this, "Next step", "Let's try again!");
        sec_window->setModal(true);
        sec_window->exec();
        to_print_value = sec_window->on_OK_btn_clicked();
    }

    // step of what we will doing later is STEP

    int STEP = to_print_value;

    return STEP;
}

void Dialog::on_make_lesson_clicked() // make_lesson "провести занятие"
{
    std::vector<Abonement *> actual_users = get_users("actual_users");
    std::vector<Abonement *> hidden_users = get_users("hidden_users");
    {
        std::vector<int> miss_values = get_mess_values();
        if(ui->all_came->isChecked())
        {

            //
            // check box all_came is clicked, then i should set MISS parametr in mysql to default
            // and set minus 1 lessons to every clients
            //
            // if check boxx all came is not clicked, then i should minus 1 lessons for one clients
            // and miss some others clients
            //
            // to this i anymore should make query and get all value to sort of vector with this values
            //
            for(int i = 0; i < actual_users.size(); i++)
            {
                miss_values[i] = 0; // 2 value in miss. is constant like a 0. it doesn't play role in our game.
            }
        }


//        for(int i = 0; i < actual_users.size(); i++)
//        {
//            update_of_Miss_parametr(0, actual_users[i]->id(), "actual_users"); // set all values for next lessons to default
//        }

        std::vector<int> miss_values_correct = get_mess_values();
        for (int i = 0; i < actual_users.size(); i++)
        {
            if(miss_values[i] != 0 && miss_values[i] != 2) // will be miss
            {
                update_of_Miss_parametr(0, actual_users[i]->id(), "actual_users"); // set all values for next lessons to default
                continue; // this user will be miss our lesson

                ///
                /// miss_values = 1 in this case
                ///
            }
            else{
                ; // do nothing. what_to_do_with_miss_clients = 0;
            }

            if(miss_values_correct[i] == 1)
            {
                update_of_Miss_parametr(0, actual_users[i]->id(), "actual_users");
            }

            if(actual_users[i]->remaining_lessons() == 3)
            {
                std::stringstream sql;
                sql << "Conductor, that person:\n" << actual_users[i]->name() << " " << actual_users[i]->surname() << " "
                    << actual_users[i]->surname() << " with id: -" << actual_users[i]->id() << "-, address: " << actual_users[i]->address() << ", instagram:  "
                    << actual_users[i]->instagram_account() << ", and phone number: " << actual_users[i]->phone_number() << " has only 3 visits available. Warning him!!!!";
                std::string temp = sql.str();
                QString convert_from_string_to_qstring = QString::fromStdString(temp);
                QMessageBox::warning(this, "Next step", convert_from_string_to_qstring);
            }

            int variant = 0; // true
            int check = actual_users[i]->AB_check(); // checking of our members to remain lessons
            if(check == -1) // free classes < than 1
            {
                variant = choice_of_user_with_low_classes(*actual_users[i]);
                if (variant == 1) // person will add money to him gym card
                {
                    actual_users[i]->remain_num(8);
                    query_update(actual_users[i], "Remain_lessons", "8", "actual_users"); // 2
                    actual_users[i]->Visit();
                    std::stringstream remain;
                    remain << actual_users[i]->remaining_lessons();
                    std::string temp = remain.str();
                    QString remain_s = QString::fromStdString(temp);

                    query_update(actual_users[i], "Remain_lessons", remain_s, "actual_users");
                    ///
                    ///
                    ///
                    /// update miss
                    update_of_Miss_parametr(2, actual_users[i]->id(), "actual_users");
                    ///
                    ///
                    ///
                }
                if (variant == 2) // member doesn't have remain lessons, but he add money to his card
                {
                    std::vector<Abonement*>::iterator it;
                    it = actual_users.begin() + i;
                    hidden_users.push_back(actual_users[i]);
                    query_create_account(actual_users[i], "hidden_users");
                    query_delete(actual_users[i], "actual_users"); // 5
                    delete_one_to_combobox(i);
                    actual_users.erase(it);
                    i--;
                } // class will start without one person*
                if (variant == 3)
                {
                    std::vector<Abonement*>::iterator it;
                    it = actual_users.begin() + i; // hide previous user
                    hidden_users.push_back(actual_users[i]);
                    query_create_account(actual_users[i], "hidden_users");
                    query_delete(actual_users[i], "actual_users"); // 7
                    delete_one_to_combobox(i);
                    actual_users.erase(it);
                    i--;
                    //
                    // delete one from combobox
                    //



                    size_t size_of_all_users;
                    size_t users_amount = actual_users.size();
                    std::vector<std::string> data;
                    // wchar_t name[25], surname[25], third_name[30], address[50], instagram_account[30], phone_number[25];

                    // id = id_verification(checkin, actual_users, hidden_users, 1000, size_of_all_users);


                    size_of_all_users = Size_Of_All_Users(actual_users, hidden_users);
                    std::stringstream temp;
                    temp << "Please, enter id of a new member in a range between (" << size_of_all_users
                         << "; 1000]: ";
                    std::string to_convert = temp.str();
                    QString text = QString::fromStdString(to_convert);
                    new_user* user = new new_user;

                    user->setModal(true);
                    user->set_text_to_range(text);
                    user->exec();

                    Abonement * new_client = user->on_buttonBox_accepted(size_of_all_users, user);

                    const char* Name = new_client->name();
                    const char* Surname = new_client->surname();
                    const char* Thirdname = new_client->thirdname();
                    int Id = new_client->id();
                    const char* Address = new_client->address();
                    const char* Phone = new_client->phone_number();
                    const char* Inst = new_client->instagram_account();
                    int Remain_num = new_client->remaining_lessons();

                    data.push_back(Name);
                    data.push_back(Surname);
                    data.push_back(Thirdname);
                    data.push_back(Address);
                    data.push_back(Phone);
                    data.push_back(Inst);

//                    data.push_back(check_input(name, 25, 1));
//                    data.push_back(check_input(surname, 25, NULL));
//                    data.push_back(check_input(third_name, 30, NULL));
//                    data.push_back(check_input(address, 50, NULL));
//                    data.push_back(check_input(instagram_account, 30, NULL));
//                    data.push_back(check_input(phone_number, 25, NULL));

                    actual_users.push_back(new Abonement(data[0].c_str(), data[1].c_str(), data[2].c_str(),
                        Id, data[3].c_str(), data[4].c_str(), data[5].c_str(), Remain_num));
                    query_create_account(actual_users[users_amount], "actual_users"); // 8
                    //
                    //
                    // add one user to combobox
                    add_one_to_combobox(actual_users[users_amount]);
                    //
                    //
                } // we will add someone new to our class
            }
            if (variant == 2 || variant == 3 || variant == 1) { ; }
            else
            {
                std::stringstream remain;
                actual_users[i]->Visit();
                remain << actual_users[i]->remaining_lessons();
                std::string temp = remain.str();
                QString remain_s = QString::fromStdString(temp);
                query_update(actual_users[i], "Remain_lessons", remain_s, "actual_users");  // 9
            }


        }
        for (int i = 0; i < actual_users.size(); i++) // that people that mark like a miss, wouldn't be miss lesson
            // twice in two lesson in a row
        {
            actual_users[i]->unmiss();
        }
    }
    print_table_from_mysql("actual_users");
}

void Dialog::on_add_new_client_clicked()
{
    std::vector<Abonement*> actual_userss = get_users("actual_users");
    std::vector<Abonement*> hidden_userss = get_users("hidden_users");

    if(actual_userss.size() == 6)
    {
        QMessageBox::warning(this, "Warning", "Our class is full, you can not add somebody new");
    }
    else{
        size_t size_of_all_users;
        size_t users_amount = actual_userss.size();
        std::vector<std::string> data;
        // wchar_t name[25], surname[25], third_name[30], address[50], instagram_account[30], phone_number[25];

        // id = id_verification(checkin, actual_users, hidden_users, 1000, size_of_all_users);


        size_of_all_users = Size_Of_All_Users(actual_userss, hidden_userss);
        std::stringstream temp;
        temp << "Please, enter id of a new member in a range between (" << size_of_all_users
             << "; 1000]: ";
        std::string to_convert = temp.str();
        QString text = QString::fromStdString(to_convert);
        new_user* user = new new_user;
        user->setModal(true);
        user->set_text_to_range(text);
        if(user->exec() == QDialog::Accepted)
        {
            Abonement * new_client = user->on_buttonBox_accepted(size_of_all_users, user);
            if(new_client != nullptr)
            {
                const char* Name = new_client->name();
                const char* Surname = new_client->surname();
                const char* Thirdname = new_client->thirdname();
                int Id = new_client->id();
                const char* Address = new_client->address();
                const char* Phone = new_client->phone_number();
                const char* Inst = new_client->instagram_account();
                int Remain_num = new_client->remaining_lessons();

                data.push_back(Name);
                data.push_back(Surname);
                data.push_back(Thirdname);
                data.push_back(Address);
                data.push_back(Phone);
                data.push_back(Inst);

                actual_userss.push_back(new Abonement(data[0].c_str(), data[1].c_str(), data[2].c_str(),
                    Id, data[3].c_str(), data[4].c_str(), data[5].c_str(), Remain_num));
                query_create_account(actual_userss[users_amount], "actual_users"); // 8
                print_table_from_mysql("actual_users");
            }
        }
        add_one_to_combobox(actual_userss[users_amount]);
    }
    //
    //
    // add one user to combobox
    //
    //
}

void Dialog::add_clients_to_combobox(std::vector<Abonement*>& users)
{
    for(int i = 0; i < users.size(); i++)
    {
        std::stringstream sql;
        sql << users[i]->name() << " " <<  users[i]->surname() << " "
               <<  users[i]->thirdname() << " with id: " <<  users[i]->id();
        std::string temp = sql.str();
        QString convert_from_string_to_qstring = QString::fromStdString(temp);
        ui->clients_list->addItem(convert_from_string_to_qstring);
    }
}

void Dialog::add_one_to_combobox(Abonement * user)
{
    std::stringstream sql;
    sql << user->name() << " " <<  user->surname() << " "
           <<  user->thirdname() << " with id: " <<  user->id();
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    ui->clients_list->addItem(convert_from_string_to_qstring);
}

void Dialog::delete_one_to_combobox(int index)
{
    ui->clients_list->removeItem(index);
}

bool Dialog::push_btn_make_lesson()
{
    if(ui->make_lesson->isChecked())
    {
        return true;
    }
    else{
        return false;
    }
}

bool Dialog::check_box_if_all_came()
{
    if(ui->all_came->isChecked())
    {
        return true;
    }
    else{
        return false;
    }
}

std::vector<Abonement *> get_users(std::string table)
{
    std::vector<QString*> names_AR, surnames_AR, thirdnames_AR, addresses_AR, insts_AR,
        phones_AR, ids_AR, remains_AR;
    std::vector<Abonement *> actual_users;
    // START //
//        res = mysql_use_result(db_conn);
    std::stringstream sql;
    sql << "select * from " << table << ";";
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);

    QSqlQuery act_query(convert_from_string_to_qstring);
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

                actual_users.push_back(new Abonement(ccc, cca, cac, id_int_a, cbc, ccb, cab, remain_int_a));
    }
    return actual_users;
}

void query_update(Abonement* account, QString column_name, QString column_value, QString clients_database)
{
    std::stringstream sql;
    int push_int;
    if (column_name == "Remain_lessons") // if column_value is int
    {
        push_int = (column_value).toInt();
        sql << "UPDATE " << clients_database.toStdString() << " SET " << column_name.toStdString() << " = "
            << push_int << " WHERE Id = " << account->id() << "; ";
    }
    else  // if column_value string
    {
        sql << "UPDATE " << clients_database.toStdString() << " SET " << column_name.toStdString() << " = "
            << column_value.toStdString() << " WHERE Id = " << account->id() << ";";
    }
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery update_acc;
    if(update_acc.exec(convert_from_string_to_qstring))    {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while updating account");
        create_acc_mistake.exec();
    }
}

void query_create_account(Abonement* account, QString database)
{
    std::stringstream sql;
    int miss = 2;  // по дефолту мисс 2 - у человека есть доступные посещения для пропуска
    // 1 - человек пропускает занятие
    // 0 - у человека нет доступных занятий для пропуска
    sql << "INSERT INTO " << database.toStdString() << " (Name, Surname, Thirdname, Id, Address, Instagram_account, Phone_number, Remain_lessons, Miss) VALUES ('"
        << account->name() << "','" << account->surname() << "','" 	<< account->thirdname() << "','"
        << account->id() << "','" << account->address()	<< "','" << account->instagram_account()
        << "','" << account->phone_number() << "','" << account->remaining_lessons() << "','" << miss << "');";

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

void query_delete(Abonement* account, QString clients_database)
{
    std::stringstream sql;
    //sql << "INSERT INTO clients VALUES('1','глеб','арбузов','николаевич','5','минск, проспект победителей','svytoydavid','+3754451232','8');";
    sql << "DELETE FROM " << clients_database.toStdString() << " WHERE Id = " << account->id() << ";";
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery delete_acc;
    if(delete_acc.exec(convert_from_string_to_qstring)) {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while deleting account");
        create_acc_mistake.exec();
    }
}

size_t Size_Of_All_Users(const std::vector<Abonement*>& actual_users, const std::vector<Abonement*>& hidden_users)
{
    size_t size;
    size = actual_users.size() + hidden_users.size();
    return size;
}

//const char* check_input(wchar_t data[], int amount_bytes, int order_num)
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

void Dialog::on_miss_button_clicked()
{
    //
    // I check, if nothing selected in combobox, then i create warning message, and nothing happend
    // Else, if something selected, then i get info about users from mysql, and get #id# of user that
    // selected in combobox by his index.
    // And then i set 1 to Miss parametr in mysql. And when admin select button Make_lesson,
    // program will check that parametr, and then, after success lesson, then parametr will
    // be return to default
    //

    if(ui->clients_list->currentIndex() == -1)
    {
        QMessageBox::warning(this, "Warning", "Please, select something in the combobox");
    }
    else // some user will be miss lesson
    {
        std::vector<Abonement*> miss_person = get_users("actual_users"); // i shoulg send or change some info after that, like query.update
        int index = ui->clients_list->currentIndex();
        int id = miss_person[index]->id();
        //
        // по дефолту мисс 2 - у человека есть доступные посещения для пропуска
         // 1 - человек пропускает занятие
         // 0 - у человека нет доступных занятий для пропуска
        std::vector<int> miss_values = get_mess_values(); // from actual_users anymore

        if(miss_values[index] == 2) {
            update_of_Miss_parametr(1, id, "actual_users"); // человек пропустит занятие
        }
        else
        {
            QMessageBox::warning(this, "Warning", "This client has already missed a class!");
        }
    }
    print_table_from_mysql("actual_users");
}

void update_of_Miss_parametr(int number_to_set, int id, std::string database)
{
    std::stringstream sql;
    sql << "UPDATE " << database << " SET Miss = " << number_to_set << " WHERE Id = " << id << ";";
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);
    QSqlQuery update_acc;
    if(update_acc.exec(convert_from_string_to_qstring))    {
        ;
    }
    else
    {
        QMessageBox create_acc_mistake;
        create_acc_mistake.setText("Mistake while updating account");
        create_acc_mistake.exec();
    }
}

void Dialog::on_add_money_clicked()
{
    //
    // create window which will create choice for our user, to add money to actual_users, or hidden
    //
    std::vector<Abonement*> actual_users = get_users("actual_users");
    std::vector<Abonement*> hidden_users = get_users("hidden_users");

    table_to_update * question = new table_to_update();
    question->setModal(true);
    if(question->exec() == QDialog::DialogCode::Accepted)
    {

        int table = question->on_buttonBox_accepted(); // 2 - if main; 3 - if hidden

        while((table == 1) || (table == 4))
        {
            question->setModal(true);
            question->exec();
            table = question->on_buttonBox_accepted();
        }


        if(table == 2) // в основной таблице
        {
            number_of_clients_choice * choice = new number_of_clients_choice();
            choice->setModal(true);
            choice->print_table_in_mysql("actual_users");
            bool correct_input = false;
            int remain_lessons;

            if(choice->exec() == QDialog::DialogCode::Accepted)
            {
                QString number_of_client = choice->on_buttonBox_accepted();
                int number = number_of_client.toInt();
                for(int i = 0; i < actual_users.size(); i++)
                {
                    if(number == actual_users[i]->id())
                    {
                        correct_input = true;
                        remain_lessons = actual_users[i]->remaining_lessons();
                    }
                }
                while(correct_input == false)
                {
                    QMessageBox::warning(this, "Warning", "Incorrect input! Try again!");
                    choice->print_table_in_mysql("actual_users");
                    if(choice->exec() == QDialog::Accepted)
                    {
                        QString number_of_client = choice->on_buttonBox_accepted();
                        int number = number_of_client.toInt();
                        for(int i = 0; i < actual_users.size(); i++)
                        {
                            if(number == actual_users[i]->id())
                            {
                                correct_input = true;
                                remain_lessons = actual_users[i]->remaining_lessons();
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }
                if(remain_lessons > 2)
                {
                    QMessageBox::warning(this, "Warning", "This user has more than two lessons. you cannot top up your subscription!");
                }
                else
                {
                    std::stringstream add_user_lesson;
                    add_user_lesson << "UPDATE actual_users SET Remain_lessons = " << 8 << " WHERE Id = " << number << ";";
                    std::string temp = add_user_lesson.str();
                    QString convert_from_string_to_qstring = QString::fromStdString(temp);
                    QSqlQuery update_acc;
                    if(update_acc.exec(convert_from_string_to_qstring))    {
                        ;
                    }
                    else
                    {
                        QMessageBox create_acc_mistake;
                        create_acc_mistake.setText("Mistake while updating clients lessons amount");
                        create_acc_mistake.exec();
                    }
                }
                print_table_from_mysql("actual_users");
            }
        }
        else if(table == 3) // в скрытой таблице
        {
            if(actual_users.size() > 5)
            {
                QMessageBox::warning(this, "Warning", "The main group is already full, you can't add anyone!");
            }
            else
            {
                number_of_clients_choice * choice = new number_of_clients_choice();
                choice->setModal(true);
                choice->print_table_in_mysql("hidden_users");
                bool correct_input = false;
                int remain_lessons;

                if(choice->exec() == QDialog::Accepted)
                {
                    QString number_of_client = choice->on_buttonBox_accepted();
                    int number = number_of_client.toInt();
                    for(int i = 0; i < hidden_users.size(); i++)
                    {
                        if(number == hidden_users[i]->id())
                        {
                            correct_input = true;
                            remain_lessons = hidden_users[i]->remaining_lessons();
                        }
                    }
                    while(correct_input == false)
                    {
                        QMessageBox::warning(this, "Warning", "Incorrect input! Try again!");
                        choice->print_table_in_mysql("hidden_users");
                        if(choice->exec() == QDialog::Accepted)
                        {
                            QString number_of_client = choice->on_buttonBox_accepted();
                            int number = number_of_client.toInt();
                            for(int i = 0; i < hidden_users.size(); i++)
                            {
                                if(number == hidden_users[i]->id())
                                {
                                    correct_input = true;
                                    remain_lessons = hidden_users[i]->remaining_lessons();
                                }
                            }
                        }
                        else
                        {
                            break;
                        }
                    }
                    if(remain_lessons > 2)
                    {
                        QMessageBox::warning(this, "Warning", "This user has more than two lessons. you cannot top up your subscription!");
                    }
                    else
                    {
                        ///
                        /// add to main group
                        ///
                        std::stringstream add_user_lesson, update_lesson_amount, delete_user;
                        add_user_lesson << "INSERT INTO actual_users SELECT * FROM hidden_users WHERE Id = " << number << ";";
                        update_lesson_amount << "UPDATE actual_users SET Remain_lessons = " << 8 << " WHERE Id = " << number << ";";
                        delete_user << "DELETE FROM hidden_users WHERE Id = " << number << ";";
                        std::string temp_add = add_user_lesson.str();
                        std::string temp_update = update_lesson_amount.str();
                        std::string temp_delete = delete_user.str();

                        QString add_user_lesson_qstring = QString::fromStdString(temp_add);
                        QString update_user_lesson_qstring = QString::fromStdString(temp_update);
                        QString delete_user_lesson_qstring = QString::fromStdString(temp_delete);

                        QSqlQuery add_acc, update_acc, delete_acc;


                        if(add_acc.exec(add_user_lesson_qstring)) {  ;  }
                        else
                        {
                            QMessageBox::warning(this, "Warning", "Mistake while updating clients lessons amount!");
                        }

                        if(update_acc.exec(update_user_lesson_qstring)) {  ;  }
                        else
                        {
                            QMessageBox::warning(this, "Warning", "Mistake while updating clients lessons amount!");
                        }

                        if(delete_acc.exec(delete_user_lesson_qstring)) {  ;  }
                        else
                        {
                            QMessageBox::warning(this, "Warning", "Mistake while deleting clients from hidden_users!");
                        }

                        std::vector<Abonement*> actuall_users = get_users("actual_users");
                        for(int i = 0; i < actuall_users.size(); i++)
                        {
                            if(actuall_users[i]->id() == number)
                            {
                                add_one_to_combobox(actuall_users[i]);
                            }
                        }
                    }
                    print_table_from_mysql("actual_users");
                }
            }
        }
        else{ // cross in the upper right corner
            ;
        }
    }
}


void Dialog::print_table_from_mysql(const char* table)
{
    QSqlTableModel* tableModel = new QSqlTableModel();
    tableModel->setTable(table);
    tableModel->select();

    ui->tableView->setModel(tableModel);
}

std::vector<int> Dialog::get_mess_values()
{
    std::vector<int> miss_values;
    std::stringstream sql;
    sql << "select Miss from actual_users;";
    std::string temp = sql.str();
    QString convert_from_string_to_qstring = QString::fromStdString(temp);

    QSqlQuery act_query(convert_from_string_to_qstring);
    while (act_query.next())
    {
        QString value = act_query.value(0).toString();
        int value_to_push = value.toInt();
        miss_values.push_back(value_to_push);
    }

    return miss_values;
}


