#include <fstream>
#include <string>
#include <set>
#include <list>
#include <map>

#define END_OF_GROUP ""

int get_char_count(std::list<std::string> *string_list);
int get_char_count(std::map<int, std::string> *group_to_chars, int group_count);
int get_total(std::list<int> *total_count);

int main(void)
{
    std::list<std::string> string_list;
    std::list<int> total_count;
    std::ifstream infile("input.txt");
    std::string line;

    while (std::getline(infile, line))
    {
        if (line == END_OF_GROUP)
        {
            int char_count = get_char_count(&string_list);
            total_count.push_back(char_count);
            string_list.clear();
            continue;
        }

        string_list.push_back(line);
    }

    int last_group = get_char_count(&string_list);
    total_count.push_back(last_group);
}

int get_char_count(std::list<std::string> *string_list)
{
    std::map<int, std::string> group_to_chars;
    int current_group = 0;

    for (auto &entry : *string_list) {
        group_to_chars.insert({current_group, entry});
        ++current_group;
    }

    return get_char_count(&group_to_chars, string_list->size());
}

int get_char_count(std::map<int, std::string> *group_to_chars, int group_count)
{
    std::set<std::string> matched_characters;
    int char_count = 0;
    int matches = 0;

    if (group_count == 1)
    {
        for (auto &entry : *group_to_chars)
        {
            for (char &character : entry.second)
            {
                matched_characters.insert(std::to_string(character));
            }
        }
    }
    else
    {
        int counter = 0;
        while (counter < group_count)
        {
            std::string letters = group_to_chars->at(counter);
            
            for (char &character : letters)
            {
                int checkIdx = 0;
                int char_count = 0;

                while (checkIdx < group_count)
                {
                    std::string str_to_check = group_to_chars->at(checkIdx);
                    if (str_to_check.find(character) != std::string::npos)
                    {
                        ++char_count;
                    }
                    ++checkIdx;
                }

                if (char_count == group_count)
                {
                    matched_characters.insert(std::to_string(character));
                }
            }

            ++counter;
        }
    }

    return matched_characters.size();
}

int get_total(std::list<int> *total_count)
{
    int counter = 0;

    for (auto &total : *total_count)
    {
        counter += total;
    }

    return counter;
}