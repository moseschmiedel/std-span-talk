#include <cstdlib>
#include <span>
#include <print>


std::span<int> s;
void f() {
    int arr[] = {1,2};
    s = arr;
    std::println("{}", arr);
}

int main() {
    f();
    int bar[] = {2,4};
    std::println("{}", s);

    return EXIT_SUCCESS;
}