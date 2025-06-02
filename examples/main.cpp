#include <cstdlib>
#include <span>
#include <print>
#include <string>
#include <vector>
#include <array>

const size_t WIDTH_L = 27;
const size_t WIDTH_C = 19;
const size_t WIDTH_R = 12;

#include "table.cpp"
#include "simple_function.cpp"

int main() {
    std::println("std::vector:");
    table_limit();
    table_header("Constructor", "Extent", "data");
    #include "vector.cpp"
    table_limit();
    std::println();

    std::println("std::array:");
    table_limit();
    table_header("Constructor", "Extent", "data");
    #include "array.cpp"
    table_limit();
    std::println();


    std::println("C-style array:");
    table_limit();
    table_header("Constructor", "Extent", "data");
    #include "c_array.cpp"
    table_limit();
    std::println();


    std::println("Iterators:");
    table_limit();
    table_header("Constructor", "Extent", "data");
    #include "iterator.cpp"
    table_limit();

    return EXIT_SUCCESS;
}