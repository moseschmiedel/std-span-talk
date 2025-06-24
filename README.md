# `std::span` talk

This talk was prepared during the course C133 OS "Modern C++ in Action" in the summer semester 2025 at HTWK Leipzig (Leipzig University of Applied Sciences).

In this repository all relevant files for the examples in the talk and the source of the slides can be found.

## Building and Running the Examples

The examples in this repository demonstrate various uses of `std::span` in C++20. You can build and run these examples using either Nix or CMake.

### Using Nix

If you have Nix installed with flakes enabled:

1. To enter a development shell:
   ```
   nix develop
   ```

2. To build and run a specific example:
   ```
   nix run .#construction     # Constructs std::span in different ways
   nix run .#dangling-span    # Shows the danger of dangling spans
   nix run .#my-container     # Demonstrates conversion from custom container to std::span
   nix run .#mdspan           # Demonstrates simple std::mdspan usage
   nix run .#parallel         # Compares performance of std::span, std::vector and raw c arrays
   ```

### Using CMake

To build with CMake directly:

1. Create a build directory and configure the project:
   ```
   cmake -B build -S examples -G Ninja    # Or use -G "Unix Makefiles" if you prefer
   ```

2. Build all examples:
   ```
   cmake --build build
   ```

3. Run a specific example:
   ```
   ./build/std-span-construction
   ./build/std-span-dangling-span
   ./build/std-span-my-container
   ./build/std-span-mdspan
   ./build/std-span-parallel
   ```

Requirements:
- C++23 compatible compiler (e.g., GCC 13+, Clang 17+)
  - `std::span` just needs C++20, but code uses `std::println` too, which is only available in C++23
- CMake 3.24 or newer
- Ninja build system (optional but recommended)
