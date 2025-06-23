#include <cstdlib>
#include <print>
#include <span>

std::span<int> s;
void f() {
  int arr[] = {1, 2};
  s = arr;
}

int main() {
  f();
  std::println("{}, {}", s, s.size());

  return EXIT_SUCCESS;
}