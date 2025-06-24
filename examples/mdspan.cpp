#include <mdspan>
#include <print>
#include <vector>

int main() {
  std::vector d{1, 0, 0, 1};

  auto m2by2 = std::mdspan(d.data(), 2, 2);
  auto m2by1by2 = std::mdspan(d.data(), 2, 1, 2);

  std::println("{}", m2by2[1, 1]);
  for (std::size_t i = 0; i < m2by1by2.extent(0); i++) {
    for (std::size_t j = 0; j < m2by1by2.extent(1); j++) {
      for (std::size_t k = 0; k < m2by1by2.extent(2); k++) {
        std::print("{},", m2by1by2[i, j, k]);
      }
    }
  }
}