#include <array>
#ifndef ALGORITHM_AND_DATA_STRUCTURES_SORT_H
#define ALGORITHM_AND_DATA_STRUCTURES_SORT_H

namespace sample {
    template <int N> std::array<int, N> InsertSorted(const std::array<int, N>& input);
    std::vector<int> BubbleSorted(const std::vector<int>& input);
    std::vector<int> SelectionSorted(const std::vector<int>& input);
    std::vector<int> MergeSorted(const std::vector<int>& input);
    std::vector<int> QuickSorted(const std::vector<int>& input);
}

#include "sort.hpp"
#endif //ALGORITHM_AND_DATA_STRUCTURES_SORT_H

