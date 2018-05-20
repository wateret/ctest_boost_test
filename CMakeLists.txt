cmake_minimum_required(VERSION 3.10)


# Include helpers

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(BoostTestHelpers)

# Add tests

enable_testing()

add_boost_test(number_test.cc "")
add_boost_test(arith_test.cc "")

