#include <print>
#include <span>

// simple (instantiated) span usage
void foo(std::span<int, 10> s);
void bar(std::span<int, std::dynamic_extent> s);

// generic span usage
template <typename T, size_t E> void f(std::span<T, E> s);

template <typename T, size_t E> void f(std::span<T, E> s) {
  std::println("{}", s);
}