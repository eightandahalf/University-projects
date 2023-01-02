#include "choice_of_client_with_low_visits.h"
#include "ui_choice_of_client_with_low_visits.h"
#include "dialog.h"

Dialog* d;

choice_of_client_with_low_visits::choice_of_client_with_low_visits(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::choice_of_client_with_low_visits)
{
    ui->setupUi(this);
}

choice_of_client_with_low_visits::~choice_of_client_with_low_visits()
{
    delete ui;
}

int choice_of_client_with_low_visits::on_OK_btn_clicked()
{
    // i should ..как-то.. return to new window with creating acc
    if(ui->first_check->isChecked() && !ui->second_check->isChecked() && !ui->third_check->isChecked())
    {
        QMessageBox::information(this, "Next step", "Good job. Let's go!");
        return 1; // first accept
    }
    if(!ui->first_check->isChecked() && ui->second_check->isChecked() && !ui->third_check->isChecked())
    {
        QMessageBox::information(this, "Next step", "Good job. Let's go!");
        return 2; // second accept
    }
    if(!ui->first_check->isChecked() && !ui->second_check->isChecked() && ui->third_check->isChecked())
    {
        QMessageBox::information(this, "Next step", "Good job. Let's go!");
        return 3; // third accept
    }
    if(ui->first_check->isChecked() && ui->second_check->isChecked() && ui->third_check->isChecked())
    {
        QMessageBox::warning(this, "Next step", "You marked all the boxes. Mark only one!");
        return 4;
    }
    else{
        QMessageBox::warning(this, "Next step", "You made a mistake. Mark only one choice!");
        return 5;
    }
}

