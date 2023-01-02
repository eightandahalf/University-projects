#include "new_user.h"
#include "qmessagebox.h"
#include "ui_new_user.h"
#include <string>
#include "Abonement.h"
#include <QString>
#include <sstream>
#include <stdlib.h>

new_user::new_user(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::new_user)
{
    ui->setupUi(this);
}

new_user::~new_user()
{
    delete ui;
}

Abonement* new_user::on_buttonBox_accepted(size_t size_of_all_users, new_user * temp)
{
    std::stringstream to_label;
    while(ui->name->text() == "" || ui->surname->text() == "" || ui->thirdname->text() == ""
      || ui->id->text() == "" || ui->address->text() == "" || ui->inst->text() == ""
      || ui->name->text() == "")
    {
        QMessageBox::warning(this, tr("User input"), tr("Not all rows contain text"));
        temp->setModal(true);
        to_label << "Please, enter id of a new member in a range between (" << size_of_all_users
             << "; 1000]: ";
        std::string to_convert = to_label.str();
        QString text = QString::fromStdString(to_convert);
//        new_user* user = new new_user;
        temp->set_text_to_range(text);
        if(temp->exec() == QDialog::Accepted)
        {
            ;
        }
        else
        {
            return nullptr;
        }
    }
    std::string name = ui->name->text().toStdString();
    std::string surname = ui->surname->text().toStdString();
    std::string thirdname = ui->thirdname->text().toStdString();
    std::string id = ui->id->text().toStdString();
    int Id = atoi(id.c_str());
    std::string address = ui->address->text().toStdString();
    std::string inst = ui->inst->text().toStdString();
    std::string phone = ui->phone->text().toStdString();
    int remain_num = 8;
    Abonement* to_return = new Abonement(name.c_str(), surname.c_str(), thirdname.c_str(), Id,
                         address.c_str(), inst.c_str(), phone.c_str(), remain_num);
    return to_return;
}

void new_user::set_text_to_range(QString text)
{
    ui->range->setText(text);
}

void new_user::on_name_textEdited(const QString &arg1)
{

}





