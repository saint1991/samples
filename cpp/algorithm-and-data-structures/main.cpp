#include <iostream>
#include <vector>
#include "max_diff.h"
#include "sort.h"
#include "eval.h"

using namespace sample;

int main() {

    std::cout << "--MAX PROFIT--" << std::endl;
    std::vector<int> input {6, 5, 3, 1, 3, 4, 3};
    std::cout << std::to_string(SearchMaxDifference(input)) << std::endl;

    std::cout << "--INSERT SORT--" << std::endl;
    std::array<int, 7> input_array {6, 5, 3, 1, 3, 4, 3};
    std::array<int, 7> insert_sorted = InsertSorted<7>(input_array);
    for (auto iter : insert_sorted) {
        std::cout << std::to_string(iter) << std::endl;
    }

    std::cout << "--BUBBLE SORT--" << std::endl;
    std::vector<int> bubble_sorted = BubbleSorted(input);
    for (auto iter : bubble_sorted) {
        std::cout << iter << std::endl;
    }

    std::cout << "--SELECTION SORT--" << std::endl;
    std::vector<int> selection_sorted = SelectionSorted(input);
    for (auto iter : selection_sorted) {
        std::cout << iter << std::endl;
    }

    std::cout << "--REVERSE POLISH NOTATION--" << std::endl;
    const std::string& notation = "12 3 - 5 2 + *";
    int result = EvalReversePolishNotation(notation);
    std::cout << result << std::endl;

    std::cout << "--MERGE SORT--" << std::endl;
    std::vector<int> merge_sorted = MergeSorted(input);
    for (auto iter : merge_sorted) {
        std::cout << iter << std::endl;
    }

    std::cout << "--QUICK SORT--" << std::endl;
    std::vector<int> quick_sorted = QuickSorted(input);
    for (auto iter : quick_sorted) {
        std::cout << iter << std::endl;
    }
}

