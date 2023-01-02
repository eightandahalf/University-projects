#ifndef NUMBER_OF_CLIENTS_CHOICE_H
#define NUMBER_OF_CLIENTS_CHOICE_H

#include <QDialog>

namespace Ui {
class number_of_clients_choice;
}

class number_of_clients_choice : public QDialog
{
    Q_OBJECT

public:
    explicit number_of_clients_choice(QWidget *parent = nullptr);
    ~number_of_clients_choice();
    QString on_buttonBox_accepted();
    void print_table_in_mysql(const char* table);

private slots:

private:
    Ui::number_of_clients_choice *ui;
};

#endif // NUMBER_OF_CLIENTS_CHOICE_H
