#include <cstdlib>
#include <cstring>
#include <numeric>
#include <print>
#include <span>
#include <thread>

void f1(std::span<int> s) {
  // do some work
  for (int &i : s) {
    i += 1;
  }
}

void parallel_span(auto arr) {
  std::array<std::thread, 10> threads;

  // start time measurement
  auto start = std::chrono::high_resolution_clock::now();

  // calculate the size of the span
  std::size_t span_size = arr.size() / threads.size();

  int thread_counter = 0;
  for (auto &t : threads) {

    // construct span as view into big array
    std::span<int> s;
    if ((thread_counter + 1) * span_size > arr.size()) {
      s = std::span{arr.begin() + thread_counter * span_size, span_size};
    } else {
      s = std::span{arr.begin() + thread_counter * span_size, arr.end()};
    }

    // start thread with span and function f
    t = std::thread(f1, s);

    thread_counter++;
  }

  // wait for all threads to finish
  for (auto &t : threads) {
    t.join();
  }
}

void f2(std::vector<int> v) {
  // do some work
  for (int &i : v) {
    i += 1;
  }
}

void parallel_vector(auto arr) {
  std::array<std::thread, 10> threads;

  // calculate the size of the subarrays
  const std::size_t subarr_size = arr.size() / threads.size();

  int thread_counter = 0;
  std::vector<int> v;
  for (auto &t : threads) {
    // construct span as view into big array
    if ((thread_counter + 1) * subarr_size > arr.size()) {
      v = std::vector{arr.begin() + thread_counter * subarr_size,
                      arr.begin() + (thread_counter + 1) * subarr_size};
    } else {
      v = std::vector{arr.begin() + thread_counter * subarr_size, arr.end()};
    }

    // start thread with span and function f
    t = std::thread(f2, v);

    thread_counter++;
  }

  // wait for all threads to finish
  for (auto &t : threads) {
    t.join();
  }
}

int main() {
  // big array
  std::array<int, 1'000'000> arr;

  /* ========= */
  /* std::span */
  /* ========= */

  // start time measurement
  auto start = std::chrono::high_resolution_clock::now();
  parallel_span(arr);
  auto end = std::chrono::high_resolution_clock::now();

  // validate result
  std::print("with std::span");
  auto sum = std::reduce(arr.begin(), arr.end());
  std::print("{}", sum);

  std::print("took {} [µs]",
             std::chrono::duration_cast<std::chrono::microseconds>(end - start)
                 .count());

  /* ========== */
  /* std::array */
  /* ========== */

  // start time measurement
  start = std::chrono::high_resolution_clock::now();
  parallel_vector(arr);
  end = std::chrono::high_resolution_clock::now();

  // validate result
  std::print("with std::span");
  sum = std::reduce(arr.begin(), arr.end());
  std::print("{}", sum);

  std::print("took {} [µs]",
             std::chrono::duration_cast<std::chrono::microseconds>(end - start)
                 .count());

  return EXIT_SUCCESS;
}