#include "max_diff.h"

namespace sample {

    // seek max difference from left to right
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
}
