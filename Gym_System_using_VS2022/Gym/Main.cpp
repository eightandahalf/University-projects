#include "GYM_system.h"
#include <iostream>

#include <fcntl.h>
#include <io.h>

int main()
{
	_setmode(_fileno(stdout), _O_U16TEXT);
	
	Gym_system* gs = new Gym_system("localhost", "root", "TUAPSE2015", "gym");

	gs->GY_main_menu();

	/*gs->GY_create_account(new Abonement(6, "mikita", "homuyakob", "nikolaevich", "minsc sdfsf334", "svytoyyyyyy", "+375445136332"), 1);
	std::cin.get();*/
}