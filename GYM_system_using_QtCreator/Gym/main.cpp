#include <QApplication>

#include <QCoreApplication>
#include <QtSql/QtSql>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

#include <iostream>

#include "GYM_system.h"

#include <fcntl.h>
#include <io.h>
#include <stdio.h>
#include <windows.h>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    Gym_system* gs = new Gym_system("localhost", "root", "TUAPSE2015", "gym");

    gs->GY_main_menu();

//    Dialog g;
//    g.set_data_to_app();
//    g.exec();


//    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
//    db.setHostName("localhost");
//    db.setUserName("root");
//    db.setPassword("TUAPSE2015");
//    db.setDatabaseName("gym");

//    if(db.open()){
//            std::cout << "so cool" << std::endl;
//    }
//    else{
//        std::cout << "so bad" << std::endl;
//    }

    // w.show();
    return a.exec();
}
