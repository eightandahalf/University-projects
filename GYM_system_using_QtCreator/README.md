# GYM system using QtCreator
Conditionally, the system can work in a fitness center. The main task of the information system is to track visits, transfer sessions missed for a valid reason, issuing 
new and closing of completed subscriptions, storing statistics and information about visitors.
I implement the object "Abonement", containing the number of remaining visits (maximum number 8) and a unique identifier of the owner. On the main screen add a check 
box "all arrived", a drop-down list, a text output field and 2 buttons: "hold a session", "missing", "refill the season ticket". For the first job, it is assumed that 
the class has 6 people and at the start of the program all new subscriptions (8 sessions). The drop-down list must contain the identifiers of visitors. The "None" button 
releases the person whose ID is selected in the list from attending the class without losing him/her in the subscription. After pressing the "hold a class" button, one 
attendance is removed from all season tickets (people who attended the class). If the "all present" box is selected, the class is taken off for all people, even if 
someone was considered absent. The text box should display the number of visits in the subscription of the person selected in the list. The "refill season ticket" 
button only works if the person has less than three sessions left and refills the number of sessions to 8 (this cruel life). If the person has more than 2 classes, 
the refill error message should be displayed in the text output field.  If the person tries to attend a class with an empty season ticket, the error message should 
appear in the text output field.
Also I implement storing information about IDs and subscriptions in a MySQL and loading it when the program starts.
