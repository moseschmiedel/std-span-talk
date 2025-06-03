cmake_minimum_required(VERSION 3.24)
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED true)

project(std-span-examples LANGUAGES CXX)

add_executable(std-span-examples main.cpp)
install(TARGETS std-span-examples DESTINATION bin)

add_executable(std-span-pointer-invalidation pointer_invalidation.cpp)
install(TARGETS std-span-pointer-invalidation DESTINATION bin)

add_executable(std-span-my-container my_container.cpp)
install(TARGETS std-span-my-container DESTINATION bin)

add_executable(std-span-mdspan mdspan.cpp)
install(TARGETS std-span-mdspan DESTINATION bin)

# Generate the `compile_commands.json` file.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()