#include "search.h"

namespace sample {

    int FirstIndexOf(const std::vector<int>& vec, const int& target) {
        int index = -1;
        for (const auto& element : vec) {
            index++;
            if (element == target) {
                return index;
            }
        }
        return -1;
    }
    
}