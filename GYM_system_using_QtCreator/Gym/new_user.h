#ifndef NEW_USER_H
#define NEW_USER_H

#include "Abonement.h"
#include <QDialog>

namespace Ui {
class new_user;
}

class new_user : public QDialog
{
    Q_OBJECT

public:
    explicit new_user(QWidget *parent = nullptr);
    ~new_user();
    Abonement* on_buttonBox_accepted(size_t size_of_all_users, new_user * temp);
    void set_text_to_range(QString text);
    void on_name_textEdited(const QString &arg1);

private slots:

private:
    Ui::new_user *ui;

};

#endif // NEW_USER_H
