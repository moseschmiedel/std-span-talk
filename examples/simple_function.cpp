#include <cstdlib>
#include <span>
#include <print>
#include <vector>

template <typename T>

void f(std::span<T> s) {
    std::println("called f({})", s);
}

int main() {
    std::vector<int> buffer({4,2,3,1});
    f(std::span{buffer});

    return EXIT_SUCCESS;
}