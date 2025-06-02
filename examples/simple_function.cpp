#include <cstdlib>
#include <span>
#include <print>
#include <string>

template <typename T, size_t E>

void info(std::string var_name, std::span<T, E> s) {
    std::println("{}", var_name);
    switch (s.extent) {
        case std::dynamic_extent:
            std::println("\tstd::span<std::dynamic_extent>({})", var_name, s);
        break;
        default:
            std::println("\tstd::span<{}>({})", var_name, s.extent, s);
        break;
    }
}