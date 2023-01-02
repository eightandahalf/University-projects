QT       += core gui
QT += sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

win32: LIBS += -L'C:/Program Files/MySQL/MySQL Server 5.7/lib/' -llibmysql

INCLUDEPATH += 'C:/Program Files/MySQL/MySQL Server 5.7/include'
DEPENDPATH += 'C:/Program Files/MySQL/MySQL Server 5.7/include'

SOURCES += \
    Abonement.cpp \
    GYM_system.cpp \
    choice_of_client_with_low_visits.cpp \
    login.cpp \
    main.cpp \
    dialog.cpp \
    new_user.cpp \
    number_of_clients_choice.cpp \
    table_to_update.cpp

HEADERS += \
    Abonement.h \
    GYM_system.h \
    Names.h \
    choice_of_client_with_low_visits.h \
    defines_and_includes.h \
    dialog.h \
    login.h \
    new_user.h \
    number_of_clients_choice.h \
    table_to_update.h

FORMS += \
    choice_of_client_with_low_visits.ui \
    dialog.ui \
    login.ui \
    new_user.ui \
    number_of_clients_choice.ui \
    table_to_update.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    to_delet.qmodel

