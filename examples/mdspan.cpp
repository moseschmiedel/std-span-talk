#include <print>
#include <vector>
#include <mdspan>

int main() {
  std::vector d{1,0,0,1};

  auto m2by2 = std::mdspan(d.data(), 2, 2);
  auto m2by1by2 = std::mdspan(d.data(), 2, 1, 2);

  std::println("{}", m2by2[1,1]);
  std::println("{}", m2by1by2[1,0,1]);
}