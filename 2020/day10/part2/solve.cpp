#include <iostream>
#include <fstream>
#include <algorithm>
#include <map>
#include <string>
#include <vector>
#include <set>

typedef std::map<int, std::vector<int>> AdapterMap;

int get_option(std::vector<int> *adapters, std::vector<int> *options, int current_adapter);
bool in_range(int check, int lower, int upper);
void get_options(std::vector<int> *adapters, std::vector<int> *options, int current_adapter);
void print(AdapterMap *adapter_map);
void print_vec(std::vector<int> vec);
void get_permutations(AdapterMap *adapter_map, int current_adapter, int current_index);
std::string create_key(int key, int option);
void get_something(AdapterMap *adapter_map, std::vector<int> *current_adapters, int key);

#define JOLT_CONVERSION 3

/**
 * store adapter with all possible adapters
 * map<int, vector<int>>
 **/

int main(void)
{
    std::ifstream infile("../input.txt");
    std::string line;
    std::vector<int> adapters;
    AdapterMap adapter_map;
    int max_adapter = 0;

    while (std::getline(infile, line))
    {
        int adapter = std::stoi(line);
        adapter_map.insert({adapter, std::vector<int>()});
        adapters.push_back(adapter);
    }
    adapters.insert(adapters.begin(), 0);
    std::sort(adapters.begin(), adapters.end());
    max_adapter = adapters.at(adapters.size() - 1);

    adapter_map[0] = std::vector<int>();
    adapter_map[max_adapter] = std::vector<int>({max_adapter + 3});

    // populate map.
    for (auto &[current_adapter, map_options] : adapter_map)
    {
        if (current_adapter == max_adapter)
            break;
        get_options(&adapters, &map_options, current_adapter);
    }

    print(&adapter_map);

    std::cout << "___________ \n";

    get_permutations(&adapter_map, 0, 0);

    // for (int current_adapter : adapters)
    // {
    //     if (current_adapter == max_adapter)
    //         break;
    //     int opt = get_option(&adapters, &options, current_adapter);
    //     choices.push_back(opt);

    //     options.clear();
    // }

    // for (int opt : choices)
    //     std::cout << "opt :: " << opt << std::endl;

    // std::cout << "total :: " << one_jolts_variance * three_jolts_variance << std::endl;
}

void get_permutations(AdapterMap *adapter_map, int key, int idx)
{
    // std::cout << "current_adapter :: " << current_adapter << " current_idx :: " << current_idx << std::endl;

    std::vector<int> *current_adapters = &adapter_map->at(key);

    for (auto &[adapter, map_options] : *adapter_map)
    {
        if (current_adapters->size() > 1)
        {
            std::cout << current_adapters->at(idx) << std::endl;
            print_vec(*current_adapters);
            get_something(adapter_map, current_adapters, key);
        }
    }
}

void get_something(AdapterMap *adapter_map, std::vector<int> *current_adapters, int key)
{
    std::cout << "key :: " << key << std::endl;
    std::vector<int> copy(*current_adapters);
    int current_adapter = current_adapters->at(key);
    std::cout << "current_adapter :: " << current_adapter << std::endl;

    adapter_map->erase(key);

    print(adapter_map);

    for (auto &[adapter, map_options] : *adapter_map)
    {
        // else
        // std::cout << "adapter :: " << adapter << std::endl;
    }

    adapter_map->insert({key, copy});
    print(adapter_map);
}

std::string create_key(int key, int option)
{
    return std::to_string(key) + "__" + std::to_string(option);
}

void print(AdapterMap *adapter_map)
{
    std::cout << "{ " << std::endl;
    for (auto &[current_adapter, map_options] : *adapter_map)
    {
        std::cout << "  "
                  << current_adapter
                  << ": ";
        print_vec(map_options);
    }

    std::cout << " };" << std::endl;
}

void print_vec(std::vector<int> vec)
{
    std::cout << "[";
    for (int opt : vec)
        std::cout << opt << ",";
    std::cout << "] \n";
}

int get_option(std::vector<int> *adapters, std::vector<int> *options, int current_adapter)
{
    get_options(adapters, options, current_adapter);
    return *std::min_element(options->begin(), options->end());
}

void get_options(std::vector<int> *adapters, std::vector<int> *options, int current_adapter)
{
    for (int maybe : *adapters)
        if (in_range(maybe, current_adapter + 1, current_adapter + 3))
            options->push_back(maybe);
}

bool in_range(int check, int lower, int upper)
{
    return (check >= lower && check <= upper);
}
