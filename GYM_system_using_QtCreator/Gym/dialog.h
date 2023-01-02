#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QtWidgets>
#include "Abonement.h"

QT_BEGIN_NAMESPACE
namespace Ui { class Dialog; }
QT_END_NAMESPACE

class Dialog : public QDialog
{
    Q_OBJECT

public:
    Dialog(QWidget *parent = nullptr);
    ~Dialog();
    void add_clients_to_combobox(std::vector<Abonement*>& users);
    bool push_btn_make_lesson();
    bool check_box_if_all_came();
    void print_table_from_mysql(const char* table);
    int choice_of_user_with_low_classes(Abonement& user);
    std::vector<int> get_mess_values();
    void add_one_to_combobox(Abonement * user);
    void delete_one_to_combobox(int index);

private slots:
    void on_make_lesson_clicked();
    void on_miss_button_clicked();
    void on_add_new_client_clicked();
    void on_add_money_clicked();

private:
    Ui::Dialog *ui;
};

std::vector<Abonement *> get_users(std::string table);
void query_update(Abonement* account, QString column_name, QString column_value, QString clients_database);
void query_create_account(Abonement* account, QString database);
void query_delete(Abonement* account, QString clients_database);
size_t Size_Of_All_Users(const std::vector<Abonement*>& actual_users, const std::vector<Abonement*>& hidden_users);
void update_of_Miss_parametr(int number_to_set, int id, std::string database);

#endif // DIALOG_H
