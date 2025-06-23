#include <chrono>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <numeric>
#include <print>
#include <span>
#include <thread>
#include <vector>

template <typename T>
std::vector<T> concatenate_vectors(const std::vector<std::vector<T>> &vectors);

constexpr std::size_t arr_size = 200'000;
void benchmark(std::string name, auto f(std::array<uint64_t, arr_size> &arr)) {
  // big array
  std::array<uint64_t, arr_size> arr = {0};

  // start time measurement
  auto start = std::chrono::steady_clock::now();
  f(arr);
  auto end = std::chrono::steady_clock::now();

  // validate result
  std::println("Bench: {}", name);
  auto sum = std::reduce(arr.begin(), arr.end());
  std::println("{}", sum);

  std::println(
      "took {} [µs]",
      std::chrono::duration_cast<std::chrono::microseconds>(end - start)
          .count());
  std::println();
}

void parallel_vector(std::array<uint64_t, arr_size> &arr) {
  std::array<std::thread, 10> threads;

  // calculate the size of the subarrays
  const std::size_t sub_size = arr.size() / threads.size();

  auto subs = std::vector<std::vector<uint64_t>>(threads.size());

  int thread_counter = 0;
  for (auto &t : threads) {
    if ((thread_counter + 1) * sub_size > arr.size()) {
      subs[thread_counter] = std::vector<uint64_t>(
          arr.begin() + thread_counter * sub_size, arr.end());
    } else {
      subs[thread_counter] =
          std::vector(arr.begin() + thread_counter * sub_size,
                      arr.begin() + (thread_counter + 1) * sub_size);
    }

    // start thread with vector and function f
    auto &sub = subs[thread_counter];
    t = std::thread([&sub]() {
      // do some work
      for (uint64_t &i : sub) {
        i += 1;
      }
    });

    thread_counter++;
  }

  // wait for all threads to finish
  for (auto &t : threads) {
    t.join();
  }

  auto result = concatenate_vectors(subs);
  for (std::size_t idx = 0; idx < result.size(); idx++) {
    arr[idx] = std::move(result[idx]);
  }
}

void parallel_c_array(std::array<uint64_t, arr_size> &arr) {
  std::array<std::thread, 10> threads;

  // calculate the size of the subarrays
  const std::size_t sub_size = arr.size() / threads.size();

  int thread_counter = 0;
  for (auto &t : threads) {
    uint64_t *sub_arr = arr.begin() + thread_counter * sub_size;
    std::size_t size;
    if ((thread_counter + 1) * sub_size > arr.size()) {
      size = arr.size() - thread_counter * sub_size;
    } else {
      size = sub_size;
    }

    // start thread with vector and function f
    t = std::thread(
        [](uint64_t arr[], std::size_t size) {
          // do some work
          for (std::size_t idx = 0; idx < size; idx++) {
            arr[idx] += 1;
          }
        },
        sub_arr, size);

    thread_counter++;
  }

  // wait for all threads to finish
  for (auto &t : threads) {
    t.join();
  }
}

void parallel_span(std::array<uint64_t, arr_size> &arr) {
  std::array<std::thread, 2> threads;

  // calculate the size of the span
  std::size_t sub_size = arr.size() / threads.size();

  int thread_counter = 0;
  for (auto &t : threads) {
    // construct span as view into big array
    std::span<uint64_t> sub;
    if ((thread_counter + 1) * sub_size > arr.size()) {
      sub = std::span{arr.begin() + thread_counter * sub_size, arr.end()};
    } else {
      sub = std::span{arr.begin() + (thread_counter * sub_size), sub_size};
    }

    // start thread with span and function f
    t = std::thread(
        [](std::span<uint64_t> s) {
          // do some work
          for (uint64_t &i : s) {
            i += 1;
          }
        },
        sub);

    thread_counter++;
  }

  // wait for all threads to finish
  for (auto &t : threads) {
    t.join();
  }
}

int main() {
  std::println();

  benchmark("std::span", parallel_span);

  benchmark("uint64_t[] and size", parallel_c_array);

  benchmark("std::vector", parallel_vector);

  return EXIT_SUCCESS;
}

template <typename T>
std::vector<T> concatenate_vectors(const std::vector<std::vector<T>> &vectors) {
  size_t total_size = 0;
  for (const auto &v : vectors) {
    total_size += v.size();
  }

  std::vector<T> result;
  result.reserve(total_size);

  for (const auto &v : vectors) {
    result.insert(result.end(), v.begin(), v.end());
  }

  return result;
}