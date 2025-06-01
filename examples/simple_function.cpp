#include <cstdlib>
#include <span>
#include <print>
#include <vector>
#include <array>

template <typename T, size_t E>

void info(std::span<T, E> s) {
    switch (s.extent) {
        case std::dynamic_extent:
            std::println("std::span<std::dynamic_extent>({})", s);
        break;
        default:
            std::println("std::span<std::static_extent>({})", s);
        break;
    }
}

int main() {
    std::vector<int> vector({4,2,3,1});
    std::array<int, 4> array({4,2,3,1});
    info(std::span{vector});
    info(std::span{array});

    return EXIT_SUCCESS;
}