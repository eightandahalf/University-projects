#ifndef _NAMES3_H_
#define _NAMES3_H_
#include <ctime>
#include <cstdlib>
#include <vector>
#include <iostream>

int file_size_control(int& size, std::string& name, int& file_size_restriction)
{
	std::cout << "Please enter a size of folder " << name << std::endl;
	std::cin >> size;
	while (size < 0 || size > file_size_restriction)
	{
		std::cout << "The size of the folder is larger than you are allowed Try again: " << std::endl;
		std::cin.clear();
		std::cin.ignore(INT_MAX, '\n');
		std::cin >> size;
	}
	return size;
}

int file_type_control()
{
	int choice;

	std::cout << "Please, choose one of this types for your file: \n1. .png\n2. .jpg\n3. .jpeg\n4. .gif\n5. .pdf\n6. .doc\n7. .docx\n8. .xls\n9. .xlxs\n" <<
		"10. .ppt\n 11. .pptx\n12. .txt\n13. .text\n14. .rtf\n15. .zip\n16. .rar\n17. .tar\n";

	std::cin >> choice;
	while (choice < 0 || choice > 17)
	{
		std::cout << "Uncorrect input. Try again: " << std::endl;
		std::cin.clear();
		std::cin.ignore(INT_MAX, '\n');
		std::cin >> choice;
	}
	
	return choice;
}

const char* FileTypes[] = { ".png", ".jpg", ".jpeg", ".gif", ".pdf", ".doc", ".docx", ".xls", ".xlxs", ".ppt", ".pptx", ".txt", ".text", ".rtf", ".zip", ".rar", ".tar" };

const char* FileNames[] = { "although", "always", "AM", "amazing", "American", "among", "amount", "analysis", "analyst", "analyze", "ancient", "anger", "angle", "angry", "animal", 
"anniversary", "announce", "annual", "another", "answer", "anticipate", "anxiety", "any", "anybody", "anymore", "anyone", "anything", "anyway", "anywhere", "apart", "apartment", 
"apparent", "apparently", "appeal", "appear", "appearance", "apple", "application", "apply", "appoint", "appointment", "appreciate", "approach", "appropriate", "approval", "approve", 
"approximately", "Arab", "architect", "area", "argue", "argument", "arise", "arm", "armed", "army", "around", "arrange", "arrangement", "arrest", "arrival", "arrive", "art", "article", 
"artist", "artistic", "as", "Asian", "aside", "ask", "asleep", "aspect", "assault", "assert", "assess", "assessment", "asset", "assign", "assignment", "assist", "assistance", "assistant",
"associate", "association", "assume", "assumption", "assure", "at", "athlete", "athletic", "atmosphere", "attach", "attack", "attempt", "attend", "attention", "attitude", "attorney", 
"attract", "attractive", "attribute", "audience", "author", "authority", "available", "average", "avoid", "award", "aware", "awareness", "away", "awful", "baby", "back", "background", 
"bad", "badly", "bag", "bake", "balance", "ball", "ban", "band", "bank", "football", "guidance", "owner", "priority"};

const char* FileSizes[] = { "2.1", "2.5", "2.2", "2.3", "2.4", "2.6", "1.7", "1.8", "1.9", "1.1", "1.2", "1.4", "1.5", "1.6", "2", "2.5", "3", "3.5", "4", "4.5",
"5", "5.5", "6", "6.5", "7", "7.5", "4.2", "3.4", "2.2", "3.3", "4.4", "5.4", "6.1", "15", "12", "1.7", "1.3", "2.3", "1.4", "1.8", "1.9", "2.1", "16", "2.6", "3.7",
"4.3", "5.3", "5.6", "6.5" };

#endif // !_NAMES3_H_