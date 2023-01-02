#ifndef CHOICE_OF_CLIENT_WITH_LOW_VISITS_H
#define CHOICE_OF_CLIENT_WITH_LOW_VISITS_H

#include <QDialog>

namespace Ui {
class choice_of_client_with_low_visits;
}

class choice_of_client_with_low_visits : public QDialog
{
    Q_OBJECT

public:
    explicit choice_of_client_with_low_visits(QWidget *parent = nullptr);
    ~choice_of_client_with_low_visits();
    int on_OK_btn_clicked();

private slots:

private:
    Ui::choice_of_client_with_low_visits *ui;
};

#endif // CHOICE_OF_CLIENT_WITH_LOW_VISITS_H
