#include "number_of_clients_choice.h"
#include "ui_number_of_clients_choice.h"
#include <QString>
#include <QSqlTableModel>
number_of_clients_choice::number_of_clients_choice(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::number_of_clients_choice)
{
    ui->setupUi(this);
}

number_of_clients_choice::~number_of_clients_choice()
{
    delete ui;
}

QString number_of_clients_choice::on_buttonBox_accepted()
{
    QString to_return = ui->lineEdit->text();
    return to_return;
}

void number_of_clients_choice::print_table_in_mysql(const char* table)
{
    QSqlTableModel* tableModel = new QSqlTableModel();
    tableModel->setTable(table);
    tableModel->select();

    ui->tableView->setModel(tableModel);

}
