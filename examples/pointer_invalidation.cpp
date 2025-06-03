#include <cstdlib>
#include <span>
#include <print>

template<class T, std::size_t E>
void f(std::span<T,E> s) {}

void main() {
    int arr[] = {1,2,3};
    std::span foo{arr};

    arr = nullptr;

    return EXIT_SUCCESS;
}