#include <iostream>
#include <iomanip>
#include <string>
#include <random>
#include "Names.cpp"
#include "Surnames.cpp"
#include "Midnames.cpp"
#include "Addresses.cpp"
#include "Phone_numbers.cpp"
#include "Diagnosis.cpp"

class Patient
{
private:
	int p_id;
	std::string p_name;
	std::string p_surname;
	std::string p_midname;
	std::string p_address;
	std::string p_phone_number;
	int p_med_card_number;
	std::string p_diagnosis;
public:
	Patient() : p_id(0), p_name("None"), p_surname("None"), p_midname("None"), p_address("None"), p_phone_number("None"), // default constructor - methods which runs when you create instance of a class
		p_med_card_number(0), p_diagnosis("None") {} 

	Patient(int id, std::string name, std::string surname, std::string midname, std::string address, std::string phone_number,
		int med_card_number, std::string diadnosis) // default constructor with parametrs
	{
		p_id = id;
		p_name = name;
		p_surname = surname;
		p_midname = midname;
		p_address = address;
		p_phone_number = phone_number;
		p_med_card_number = med_card_number;
		p_diagnosis = diadnosis;
	}

	void create_random_patient()
	{
		std::random_device rd; // random-number generator. and rd(random-number) take a random number as a seed
		std::mt19937 mt(rd()); // pseudorandom number generator which take the rd like a argument. mt - class of mersenne twister 

		// id
		std::uniform_int_distribution<> dist_id(1, 100); // dist_id - instance of class un._int_dist. which defines the closed interval (1, 100) over which
														 // we wish to sample integer values

		// med_card_number 
		std::uniform_int_distribution<> dist_med_card_number(1, 100);

		// Key for names 
		std::uniform_int_distribution<> dist_name(0, names_number - 1);

		// Key for surnames 
		std::uniform_int_distribution<> dist_surname(0, surnames_number - 1);

		// Key for midnames 
		std::uniform_int_distribution<> dist_midname(0, midnames_number - 1);

		// Key for addresses 
		std::uniform_int_distribution<> dist_address(0, addresses_number - 1);

		// Key for phone_numbers 
		std::uniform_int_distribution<> dist_phone_number(0, phone_numbers_number - 1);

		// Key for diagnosis 
		std::uniform_int_distribution<> dist_diagnosis(0, diagnosis_number - 1);

		int names_key = dist_name(mt); // we're have dist_name algorithm, and we use mt - random number like key for our algorithm
		int midnames_key = dist_surname(mt);
		int third_names_key = dist_midname(mt);
		int addresses_key = dist_address(mt);
		int phones_num_key = dist_phone_number(mt);
		int diagnosis_key = dist_diagnosis(mt);

		p_id = dist_id(mt);
		p_med_card_number = dist_med_card_number(mt);

		std::string new_name = names[names_key]; // we take name with number "names_key" from Names.cpp
		std::string new_surname = surnames[third_names_key];
		std::string new_midname = midnames[midnames_key];
		std::string new_address = addresses[addresses_key];
		std::string new_phone_number = phone_numbers[phones_num_key];
		std::string new_destination = diagnosis[diagnosis_key];

		p_name = new_name;
		p_surname = new_surname;
		p_midname = new_midname;
		p_address = new_address;
		p_phone_number = new_phone_number;
		p_diagnosis = new_destination;
	}

	void show_information()
	{
		const char separator = ' ';

		std::cout << '|' << std::left << std::setw(3) << std::setfill(separator) << p_id
			<< '|' << std::left << std::setw(14) << std::setfill(separator) << p_name
			<< '|' << std::left << std::setw(15) << std::setfill(separator) << p_surname
			<< '|' << std::left << std::setw(15) << std::setfill(separator) << p_midname
			<< '|' << std::left << std::setw(49) << std::setfill(separator) << p_address
			<< '|' << std::left << std::setw(20) << std::setfill(separator) << p_phone_number
			<< '|' << std::left << std::setw(17) << std::setfill(separator) << p_med_card_number
			<< '|' << std::left << std::setw(23) << std::setfill(separator) << p_diagnosis << '|';
	}

	std::string get_diagnosis() { return p_diagnosis; }
	
	int get_med_card_number() { return p_med_card_number; }

};

class Hospital
{ 
private:
	Patient* p_hospital; // pointer to first patient
	int p_size;
public:
	Hospital(int size)
	{
		p_hospital = new Patient[size]; // arrray of patients
		p_size = size;

		int choice = int();

		for (size_t i = 0; i < size; i++) // size_t - unsigned integer, that i was > 0
		{
			std::cout << "\nSelect the method of adding a train [" << i + 1 << "]:"
				<< "\n1. Enter information by hand"
				<< "\n2. Use random data"
				<< "\n3. Use random data for all remaining patients\n";

			do {
				std::cout << "\nEnter: ";
				std::cin >> choice;
			} while (choice > 3 || choice < 1);

			if (choice == 1)
			{
				int id = int();
				std::string name = std::string();
				std::string surname = std::string();
				std::string midname = std::string();
				std::string address = std::string();
				std::string phone_number = std::string();
				int med_card_number = int();
				std::string diadnosis = std::string();

				std::cout << "\nEnter a id: ";
				std::cin >> id;
				std::cout << "\nEnter a name: ";
				std::cin >> name;
				std::cout << "\nEnter a surname: ";
				std::cin >> surname;
				std::cout << "\nEnter a midname: ";
				std::cin >> midname;
				std::cout << "\nnEnter a address: ";
				std::cin >> address;
				std::cout << "\nnEnter a phone number: ";
				std::cin >> phone_number;
				std::cout << "\nEnter a medical card number : ";
				std::cin >> med_card_number;
				std::cout << "\nnEnter a diadnosis: ";
				std::cin >> diadnosis;

				Patient patient_to_add(id, name, surname, midname, address, phone_number, med_card_number, diadnosis);

				p_hospital[i] = patient_to_add;
			}
			else if (choice == 2)
			{
				Patient random_patient;
				random_patient.create_random_patient();
				p_hospital[i] = random_patient;
			}
			else if (choice == 3)
			{
				for (size_t j = 0; j < size - i; i++)
				{
					Patient random_patient;
					random_patient.create_random_patient();
					p_hospital[i] = random_patient;
				}
				break;
			}
		}
	}

	void show_hospital()
	{
		if (p_hospital == nullptr)
		{
			std::cout << "Hospital is empty.\n";
			return;
		}

		std::cout << "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+"
		          << "\n| # |     Name     |    Surname    |    Midname    |                      Address                    |    Phone number    | Med card number |       Diagnosis       |"
		          << "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";


		for (size_t i = 0; i < p_size; i++)
		{
			p_hospital[i].show_information();
			std::cout << "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";
		}
	}

	void show_diagnosed(std::string diagnosis)
	{
		std::cout << "\nList of patients with " << diagnosis << ":"
			<< "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";
		for (size_t i = 0; i < p_size; i++)
		{
			if (p_hospital[i].get_diagnosis() == diagnosis)
			{
				p_hospital[i].show_information();
				std::cout << "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";
			}
		}
	}

	void show_given_interval(int from, int until)
	{
		std::cout << "\nList of patients whose medical record number is higher than " << from << " and lower than " << until << ":"
			<< "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";
		for (size_t i = 0; i < p_size; i++)
		{
			Patient patient = p_hospital[i];
			if (patient.get_med_card_number() > from && patient.get_med_card_number() < until)
			{
				p_hospital[i].show_information();
				std::cout << "\n+---+--------------+---------------+---------------+-------------------------------------------------+--------------------+-----------------+-----------------------+\n";
			}
		}
	}

	Hospital() : p_hospital(nullptr), p_size(0)
	{}

	~Hospital()
	{
		delete[] p_hospital;
	}
};


int main()
{
	int size = int();

	do {
		std::cout << "Enter the number of patients you want to add: ";
		std::cin >> size;
	} while (size <= 0);

	Hospital hospital(size);

	hospital.show_hospital();
	hospital.show_diagnosed("Asthma");
	hospital.show_given_interval(5, 50);

	return 0;
}