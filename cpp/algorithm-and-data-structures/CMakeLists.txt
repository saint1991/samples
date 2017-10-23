cmake_minimum_required(VERSION 3.8)
project(algorithm_and_data_structures)

set(CMAKE_CXX_STANDARD 17)

set(SOURCE_FILES main.cpp sort.hpp sort.h max_diff.cpp max_diff.h eval.cpp eval.h strings.cpp strings.h search.cpp search.h)
add_executable(algorithm_and_data_structures ${SOURCE_FILES})