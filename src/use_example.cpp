#include <cstdlib>
#include <span>
#include <print>
#include <vector>

template <typename T>

void sort(std::span<T> s) {
    std::sort(s.begin(), s.end());
}

int main() {
    std::vector<int> buffer({4,2,3,1});
    std::println(buffer);
    sort(std::span{buffer});
    std::println(buffer);

    return EXIT_SUCCESS;
}