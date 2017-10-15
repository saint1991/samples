#include <array>
#include <iostream>
#include <vector>
#include <tuple>

namespace sample {


    // Insert sort repeatedly insert current target to the first found place the value is not larger than that of target in the sorted part.
    // O(n^2)
    template <int N>
    std::array<int, N> InsertSorted(const std::array<int, N>& input) {

        std::array<int, N> ret;
        std::copy(std::begin(input), std::end(input), std::begin(ret));

        for (int i = 1; i < input.size(); i++) {
            int target = ret[i];
            int j;
            for (j = i - 1; j >= 0 && ret[j] > target; j--) {
                ret[j + 1] = ret[j];
            }
            ret[j + 1] = target;
        }
        return ret;
    };

    // Bubble sort repeatedly swap target with the before one
    // Sorted part is created from left to right
    // O(n^2)
    std::vector<int> BubbleSorted(const std::vector<int>& input) {

        std::vector<int> ret(std::begin(input), std::end(input));

        bool isReverseExist = true;
        while (isReverseExist) {
            isReverseExist = false;
            for (unsigned long j = ret.size() - 1; j >= 1; j--) {
                if (ret[j] < ret[j - 1]) {
                    std::swap(ret[j], ret[j - 1]);
                    isReverseExist = true;
                }
            }
        }
        return ret;
    };

    // Selection sort repeatedly swap ith elements with the minimum number whose index is larger than i
    std::vector<int> SelectionSorted(const std::vector<int>& input) {

        std::vector<int> ret(std::begin(input), std::end(input));

        for (int i = 0; i < ret.size(); i++) {
            int minj = i;
            int j = i;
            for (; j < ret.size(); j++) {
                if (ret[minj] > ret[j]) minj = j;
            }
            std::swap(ret[i], ret[minj]);
        }
        return ret;
    }


   void MergeSortInner(std::vector<int> &in, long left, long right) {
       long n = right - left;
       if (n < 1) return;

       long mid = (left + right) / 2;
       MergeSortInner(in, left, mid);
       MergeSortInner(in, mid + 1, right);

       std::vector<int> leftVec(in.begin() + left, in.begin() + mid + 1);
       std::vector<int> rightVec(in.begin() + mid + 1, in.begin() + right + 1);
       unsigned long leftIndex = 0;
       unsigned long rightIndex = 0;
       for (auto i = left; i <= right; i++) {
           if (rightIndex >= rightVec.size() || leftVec[leftIndex] <= rightVec[rightIndex]) {
               in.at(i) = leftVec[leftIndex];
               leftIndex++;
           } else {
               in.at(i) = rightVec[rightIndex];
               rightIndex++;
           }
       }

   }

    std::vector<int> MergeSorted(const std::vector<int>& input) {
        std::vector<int> ret(std::begin(input), std::end(input));
        MergeSortInner(ret, 0, ret.size() - 1);
        return ret;
    }

    long Partition(std::vector<int>& input, long from, long to) {
        int pivot = input.at(to);
        long target = from - 1;
        for (long i = from; i < to; i++) {
            if (input.at(i) <= pivot) {
                target++;
                std::swap(input[target], input[i]);
            }
        }
        std::swap(input[target + 1], input[to]);
        return target + 1;
    }

    void QuickSortInner(std::vector<int>& input, long from, long to) {
        if (to - from < 1) return;
        long pivotIndex = Partition(input, from, to);
        QuickSortInner(input, from, pivotIndex - 1);
        QuickSortInner(input, pivotIndex + 1, to);
    }

    std::vector<int> QuickSorted(const std::vector<int>& input) {
        std::vector<int> ret(std::begin(input), std::end(input));
        QuickSortInner(ret, 0, input.size() - 1);
        return ret;
    }

}
