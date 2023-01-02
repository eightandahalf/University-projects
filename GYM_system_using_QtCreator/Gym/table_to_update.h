#ifndef TABLE_TO_UPDATE_H
#define TABLE_TO_UPDATE_H

#include <QDialog>

namespace Ui {
class table_to_update;
}

class table_to_update : public QDialog
{
    Q_OBJECT

public:
    explicit table_to_update(QWidget *parent = nullptr);
    ~table_to_update();
    int on_buttonBox_accepted();

private slots:

private:
    Ui::table_to_update *ui;
};

#endif // TABLE_TO_UPDATE_H
