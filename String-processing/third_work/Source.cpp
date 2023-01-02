#include <iostream> // # file inclusion Preprocessor Directive  // this type of PD tells the computer to include a file in source code.
					// PD also tells the compiler that certain information in our code marked with PD need to be pre-
					// processed before compilation
#include <fstream>
#include <string>   // with that header file we can use string class and create string object

class File {
private:
	std::fstream file; // fstream - class to read and write from/to file. object
	std::string f_file_name; // f_file_name is object of std::string class that use char as its character type
	std::string f_file_data;
public:
	File(const char* filename) // file name is pointer to const(string) literal; string literal is a sequence of char enclosed within double quotation marks ""
							   // in C string literals is an array of char but in c++ they are constant array of char
	{
		file.open(filename, std::fstream::in | std::fstream::out);  // opening file for reading and writing
										  // we need associate our object with real file. we will make this by opening file
										  // open file or object of class fstream represented like stream and any input or output
										  // operation perfomed on stream object will applied to our physical file.
										  // And to open our file we use member function of our class
		f_file_name = filename;

		if (file.fail()) {
			std::cerr << "There is not option to open " << filename << " file"; // "std" is a namespace; the "::" operator is the scope resolution operator, which tells the compiler which class
																				// to look in for an identifier; namespace is a container of identifiers.
																				// If a class having the same name exists inside two namespace we can use the namespace name with 
																				// the scope resolution operator to refer that class without any conflicts


			exit(-1);
		}
	}
	void read_from_file() {
		file.seekg(0, file.end); // zero position from the end of file
		size_t length = file.tellg(); // tellg return current position of the pointer
									  // in our case it is the last position in file and also it is length. unsigned integer type. 
		f_file_data.reserve(length);
		file.seekg(0, file.beg);
		while (file) // true if stream ready for more operations and false if either the end of file has been reached
		{
			std::string line_buffer;
			getline(file, line_buffer);
			f_file_data.append(line_buffer);
		}
		std::cout << "Info that we got: " << f_file_data << std::endl << std::endl; // we use std::to chech functionality of our function cout
	}
	std::string get_file_data()
	{
		return f_file_data;
	}

	void individual_task(const std::string& filedata)
	{
		std::string new_string;
		new_string.reserve(filedata.size());
		std::cout << "new_file: " << std::endl;
		for (size_t i = 0; i < filedata.size(); i++)
		{
			if (filedata[i] == 97 && filedata[i - 1] == 112) // if current char is "a" and previous symbol is "p"
			{
				char c = 'o';
				new_string.push_back(c);
				std::cout << c;
			}
			else {
				char c = filedata[i];
				new_string.push_back(c);
				std::cout << c;
			}
		}
		std::cout << std::endl << std::endl;
		f_file_data = new_string;
	}

	void write_to_file() {
		std::string new_string;
		int main_counter = 0; // count of all symbols
		int counter = 0; // counter of symbols in one line
		int letter_counter = 0; // counter of letters in word
		for (size_t i = 0; i < f_file_data.size(); i++) {
			char c = f_file_data[i];
			if (main_counter > 710 && c == '.') { // if number of symbols is more than 730 than we make \n and \n
				new_string.push_back('.');
				new_string.push_back('\n');
				new_string.push_back('\n');
				/*file << ".";
				file << "\n" << "\n";*/
				main_counter = 0;
				letter_counter = 0;
				counter = 0;
			} 
			else if (c == 32 && main_counter == 0) {
				letter_counter = 0;
			}
			else if (counter > 70 && c == 32) { // \n of words around 70 words
				new_string.push_back(c);
				new_string.push_back('\n');
				/*file << c;
				file << "\n";*/
				counter = 0;
				main_counter = main_counter + 1;
			}
			else if (c == 32) { // if space - letter counter in word equal to zero
				letter_counter = 0;
				counter = counter + 1;
				main_counter = main_counter + 1;
				new_string.push_back(c);
				/*file << c;*/
			}	
			else { // if average symbol in word
				new_string.push_back(c);
				/*file << c;*/
				counter = counter + 1;
				main_counter = main_counter + 1;
				letter_counter = letter_counter + 1;
			}
		}
	}

	void encrypt()
	{
		std::string new_string;
		int main_counter = 0; // count of all symbols
		int counter = 0; // counter of symbols in one line
		int letter_counter = 0; // counter of letters in word
		new_string.reserve(f_file_data.size());
		for (size_t i = 0; i < f_file_data.size(); i++)
		{
			char c = f_file_data[i] + 1;
			if (main_counter > 710 && c == '.') { // if number of symbols is more than 730 than we make \n and \n
				new_string.push_back('.');
				new_string.push_back('\n');
				new_string.push_back('\n');
				file << ".";
				file << "\n" << "\n";
				main_counter = 0;
				letter_counter = 0;
				counter = 0;
			}
			else if (counter > 70) { // \n of words around 70 words
				new_string.push_back('\n');
				new_string.push_back(c);
				file << "\n";
				file << c;
				counter = 0;
				main_counter = main_counter + 1;
			}
			else { // if average symbol in word
				new_string.push_back(c);
				file << c;
				counter = counter + 1;
				main_counter = main_counter + 1;
				letter_counter = letter_counter + 1;
			}
		}
		std::cout << "Our text file before encryption: " << f_file_data << std::endl << std::endl;
		f_file_data = new_string;
		std::cout << "Our text file after enctyption: " << f_file_data << std::endl << std::endl;
	}

	void decrypt()
	{
		std::string new_string;
		new_string.reserve(f_file_data.size());
		for (size_t i = 0; i < f_file_data.size(); i++)
		{
			char c = f_file_data[i] - 1;
			new_string.push_back(c);
		}
		std::cout << "Our text file before decryption: " << f_file_data << std::endl << std::endl;
		f_file_data = new_string;
		std::cout << "Our text file after decryption: " << f_file_data << std::endl << std::endl;
	}

	~File() //A destructor is a member function that is invoked automatically when we're stop using our object and destroyed by a call to delete
	{
		file.close(); // streams member function close
	}
};

int main() {
	File input_file("TEXT_with_mistake.txt");
	File output_file("TEXT_without_mistake.txt");

	input_file.read_from_file();

	output_file.individual_task(input_file.get_file_data());
	output_file.write_to_file();
	output_file.encrypt();

	return 0;
}

// contemparary paint. scholarchip - last word in the last line of first part which contain 730 symbols