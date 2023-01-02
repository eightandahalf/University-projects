#include <conio.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <chrono>
#include <thread>
#include <stdlib.h>
 
using namespace std::this_thread;     // sleep_for, sleep_until
using namespace std::chrono_literals; // ns, us, ms, s, h, etc.
using std::chrono::system_clock;
using namespace std;

int number_length(int &num) { // this function return length of our number
    int temp_num = num; // we create variable which will contain our number 
    int counter = 0; // this variable will contain amount of all elements in our number
    while ((temp_num / 10) != 0) { // we divide our number to 10, and if int_part of new number not equal not zero than we increase counter variable on 1
        counter = counter + 1;
        temp_num = temp_num / 10;
    }
    counter = counter + 1; // this operation we make to the case when we divide int number on 10, but result = 0, and cycle while we skip
    return counter;
}
void correct_input(char &c, int &res, int num_counter, string &esc_check) {
    int num = 0;
    bool minus = false;
    int counter_minus = 0;
    cout << "Please, enter a number: \n";
    c = _getch();
    int counter = 0;
    while (num_counter != 0 && int(c) == 13) {
        c = _getch();
    }
    if (int(c) == 27 && num_counter != 0) {
        esc_check = "exit";
         return;
    }
    while (c < '1' || c >'9') {
        if (int(c) == 45 && counter_minus == 0) {
            _putch(c);
            minus = true;
            counter_minus = 1;
        }
        c = _getch();
    }
    while (int(c) != 13 && int(c) != 27) { // 13 - carrige return. 27 - esc
        if (c >= '1' && c <= '9') {
            counter = counter + 1;
            _putch(c);
            num = num * 10 + int(c) - 48;
        }
        c = _getch();
    } 
    if (minus) {
        num = num * -1;
    }
    res = num;
    cout << endl << "Your input is: " << res << endl;
}

struct node {
    int number_block;
    int num_length_block;
    node* next;
};
int main() {
    tryagain1:
    tryagain2:
    int i = 0; // var to count output element which length more than mid length
    int j = 0; // var to count output element which length less than mid length
    bool in_more = false;
    bool in_less = false;
    int counter_more_than_mid = 0;
    int counter_less_than_mid = 0;
    char c_choice;
    int middle_length = 0; // this variable we use to calculate middle length of all our numbers
    int counter = 0;
    node* head_item = NULL; // we create head node, that will always point to first element
    node* temp_item; // this pointer will define variable that will always contain data-block that we create now
    bool boolean = true; // this variable we use to find a moment when user wanna to stop adding numbers
    int res, num_length; // var res will contain number which input user; var num_length contain length of number
    int num_counter = 0; // this variable contain amount of all numbers which add user 
    char c; // this variable we use to realise cymbol-by-cymbol input
    string esc_check; // this variable we use to define moment when user wanna to stop adding numbers if amount of all number are more than 1 
    cout << "Now, you have a opportunity to enter a number!!\n Enter -Exit- to stop input numbers.\n Enter -Enter- to enter new number\n" << endl;
    do {
        correct_input(c, res, num_counter, esc_check); // we call this function that user could add numbers
        if (esc_check == "exit") { // we stop adding numbers if user enter Escape and amount of all number are more than 1
            break;
        }
        num_counter = num_counter + 1; // this variable we use to give opportunity to user to stop input number if amount of number are more than 1
        num_length = number_length(res); // this varibale get length of input number
        temp_item = new node; // we create temp block or node to add to him number and number_length
        temp_item->number_block = res; // we're adding number into our node
        temp_item->num_length_block = num_length; // we're adding number length into our node
        temp_item->next = head_item; // we point next_pointer of our temprorary node to place where point head pointer
        head_item = temp_item; // head pointer begin point to block which we add 5 second ago..
        cout << "Length of number: " << temp_item->number_block << " is " << temp_item->num_length_block << endl;
    } while (int(c) != 27);
    temp_item = head_item; // we declare that our temp_pointer point to start of list
    cout << "\n";
    while (temp_item != NULL) {
        cout << counter << " element in our linked list is: " << temp_item->number_block << " and his length is " << temp_item->num_length_block << endl;
        temp_item = temp_item->next;
        counter = counter + 1;
    }
    temp_item = head_item; // we declare that our temp_pointer point to start of list
    while (temp_item != NULL) {
        middle_length = middle_length + temp_item->num_length_block;
        temp_item = temp_item->next;
    }
    cout << "\nAll amount of our elements is: " << counter << endl;
    middle_length = middle_length / counter;
    cout << "\nMiddle length of all our elements is: " << middle_length << endl;
    cout << endl << "Now we will print elements which length is more or less than middle length\n\n";
    cout << "Enter 1, to print elements which length is more than middle length of all elements, or Else to print elements which length is less than middle lenth of all elements\n";
    cin >> c_choice;
    temp_item = head_item; // we declare that our temp_pointer point to start of list
    if (int(c) == 49) {
        cout << "\nWE WILL PRINT ELEMENTS WHICH LENGTH less THAN MIDDLE LENGTH = " << middle_length << endl;
        while (temp_item != NULL) {
            if (temp_item->num_length_block > middle_length) {
                cout << i << " element = " << temp_item->number_block << "   length = " << temp_item->num_length_block << endl;
                counter_more_than_mid = counter_more_than_mid + 1;
            }
            in_more = true;
            temp_item = temp_item->next;
            i = i + 1;
        }
    }
    else {
        cout << "\nWE WILL PRINT ELEMENTS WHICH more LESS THAN MIDDLE LENGTH = " << middle_length << endl;
        while (temp_item != NULL) {
            if (temp_item->num_length_block < middle_length) {
                cout << j << " element = " << temp_item->number_block << "   length = " << temp_item->num_length_block << endl;
                counter_less_than_mid = counter_less_than_mid + 1;
            }
            in_less = true;
            temp_item = temp_item->next;
            j = j + 1;
        }
    }

    if (in_more) {
        if (counter_more_than_mid == 0) {
            cout << endl << "There are't element which length more than middle length!!\nPlease try again: \n\n";
            sleep_for(3s);
            system("CLS");
            goto tryagain1;
        }
    }
    if (in_less) {
        if (counter_less_than_mid == 0) {
            cout << endl << "There are't element which length less than middle length!!\nPlease try again: \n\n";
            sleep_for(3s);
            system("CLS");
            goto tryagain2;
        }
    }
    cout << endl << "Created by Hleb Arbuzau.\n" << "Got the job: \n" << "The work was handed: \n";
    return 0;
}