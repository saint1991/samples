#include "strings.h"

namespace sample {

    std::vector<std::string> Split(const std::string& input, char delimiter) {

        std::vector<std::string> ret;

        std::stringstream ss(input);
        std::string item;
        while (std::getline(ss, item, delimiter)) {
            ret.push_back(item);
        }
        return ret;
    }
}