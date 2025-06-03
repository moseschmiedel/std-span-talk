#include <cstdlib>
#include <span>
#include <print>


std::span<int> s;
void f() {
    int arr[] = {1,2};
    s = arr;
    std::println("{}", s);
}

int main() {
    f();
    std::println("{}", s);

    return EXIT_SUCCESS;
}