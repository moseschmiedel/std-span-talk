cmake_minimum_required(VERSION 3.24)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED true)

project(std-span-examples LANGUAGES CXX)

add_executable(simple_function simple_function.cpp)
install(TARGETS simple_function DESTINATION bin)

# Generate the `compile_commands.json` file.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()