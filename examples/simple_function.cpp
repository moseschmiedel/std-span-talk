#include <cstdlib>
#include <span>
#include <print>
#include <string>

template <typename T, size_t E>
void info(std::string var_name, std::span<T, E> s);

template <typename T, size_t E>
void info(std::string var_name, std::span<T, E> s) {
    size_t spaces_amount = WIDTH_L - var_name.size();
    std::string spaces(spaces_amount, ' ');
    switch (s.extent) {
        case std::dynamic_extent:
            std::println("| {}{} | std::dynamic_extent | {} |", var_name, spaces,  s);
        break;
        default:
            std::println("| {}{} |          {}          | {} |", var_name, spaces, s.extent, s);
        break;
    }
}
