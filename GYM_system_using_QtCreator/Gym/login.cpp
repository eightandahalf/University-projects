#include "login.h"
#include "ui_login.h"
#include <QMessageBox>
#include <sstream>
login::login(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::login)
{
    ui->setupUi(this);
}

login::~login()
{
    delete ui;
}

void login::on_login_button_clicked(login * verification)
{
    while(ui->username_line->text() != "login" || ui->password_line->text() != "password")
    {
        std::stringstream mistake_text;
        mistake_text << "you enter incorrect data: login - " << (ui->username_line->text()).toStdString()
                << " and password - " << (ui->password_line->text()).toStdString();
        std::string to_convert = mistake_text.str();
        QString text = QString::fromStdString(to_convert);
        QMessageBox::warning(this, "Next step", text);
        if(verification->exec() == QDialog::Accepted)
        {
            ;
        }
        else
        {
            exit(0);
        }
    }
}

