#include <iostream>
#include <vector>

int SearchMaxDifference(const std::vector<int>& input) {
    if (input.size() < 2) throw std::invalid_argument("input size should be larger than 1");

    int min = INT_MAX;
    int max_diff = INT_MIN;
    for (const auto& iter : input) {
        if (max_diff < iter - min) max_diff = iter - min;
        if (iter < min) min = iter;
    }
    return max_diff;
}

int main() {
    std::vector<int> input {6, 5, 3, 1, 3, 4, 3};
    std::cout << std::to_string(SearchMaxDifference(input)) << std::endl;

    std::vector<int> input2 {3, 4, 3, 2};
    std::cout << std::to_string(SearchMaxDifference(input2)) << std::endl;

    std::vector<int> input3 {5, 4, 3, 2, 1};
    std::cout << std::to_string(SearchMaxDifference(input3)) << std::endl;
}

