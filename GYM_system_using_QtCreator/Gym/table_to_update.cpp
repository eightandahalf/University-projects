#include "table_to_update.h"
#include "ui_table_to_update.h"
#include <QMessageBox>

table_to_update::table_to_update(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::table_to_update)
{
    ui->setupUi(this);
}

table_to_update::~table_to_update()
{
    delete ui;
}


int table_to_update::on_buttonBox_accepted()
{
    if(ui->main_table->isChecked() && ui->hidden_table->isChecked())
    {
        QMessageBox::warning(this, "Next step", "You marked all the boxes. Mark only one!");
        return 1;
    }
    if(ui->main_table->isChecked() && !ui->hidden_table->isChecked())
    {
        QMessageBox::information(this, "Next step", "Good work. Let's go!");
        return 2;
    }
    if(!ui->main_table->isChecked() && ui->hidden_table->isChecked())
    {
        QMessageBox::information(this, "Next step", "Good work. Let's go!");
        return 3;
    }
    else{
        QMessageBox::warning(this, "Next step", "You made a mistagke. Mark only one!");
        return 4;
    }

}

