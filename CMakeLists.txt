cmake_minimum_required(VERSION 3.8)
project(gpdb)
set(CMAKE_CXX_STANDARD 11)
include_directories(src/include
	src/backend/gp_libpq_fe)
file(GLOB_RECURSE SOURCE_FILES "src" "*.c" "*.h")
add_executable(gpdb ${SOURCE_FILES})
