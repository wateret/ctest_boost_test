# This code has been modified. The original source is:
# https://eb2.co/blog/2015/06/driving-boost.test-with-cmake/

find_package(Boost COMPONENTS unit_test_framework REQUIRED)

# add_boost_test(<source> [DEPENDENCIES <library> ...])
#
# Add a target executable of a test source file and add a CTest test.
# This can be either one of two - one-shot or individual.
#   - one-shot   : One source one `add_test`. All cases will be run all at once.
#   - individual : One source has many `add_test`. Each case will be run one at once.
#
# NOTE
#   Multiple source file is unsupported (yet).

function(add_boost_test)
    # Parse arguments

    set(OPTIONS "")
    set(ONE_VALUE_ARGS "")
    set(MULTI_VALUE_ARGS DEPENDENCIES)
    cmake_parse_arguments(add_boost_test "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    list(LENGTH add_boost_test_UNPARSED_ARGUMENTS NUM_SOURCE_FILES)
    if(NOT ${NUM_SOURCE_FILES} EQUAL 1)
        message(SEND_ERROR "Invalid number of arguments. Only 1 source file allowed.")
        return()
    endif()

    set(SOURCE_FILE "${add_boost_test_UNPARSED_ARGUMENTS}")
    set(DEPENDENCIES "${add_boost_test_DEPENDENCIES}")

    # Function content begins

    get_filename_component(TEST_EXECUTABLE_NAME ${SOURCE_FILE} NAME_WE)

    add_executable(${TEST_EXECUTABLE_NAME} ${SOURCE_FILE})
    target_link_libraries(${TEST_EXECUTABLE_NAME} 
                          ${DEPENDENCIES} ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})

    # Two ways of running tests and reporting depend on `RUNTEST_ONESHOT`
    #   - if TRUE  : Run all the tests in a binary together and report the whole result
    #   - if FALSE : Run each test(BOOST_AUTO_TEST_CASE) and report individually
    if(${RUNTEST_ONESHOT})
        add_test(NAME "${TEST_EXECUTABLE_NAME}"
                 COMMAND ${TEST_EXECUTABLE_NAME} --catch_system_error=yes)
    else()
        # NOTE BOOST_AUTO_TEST_SUITE is UNSUPPORTED.
        #      DO NOT use it in the test source or all tests will fail to run.

        file(READ "${SOURCE_FILE}" SOURCE_FILE_CONTENTS)
        string(REGEX MATCHALL "BOOST_AUTO_TEST_CASE\\( *([A-Za-z_0-9]+) *\\)" 
               FOUND_TESTS ${SOURCE_FILE_CONTENTS})

        foreach(HIT ${FOUND_TESTS})
            string(REGEX REPLACE ".*\\( *([A-Za-z_0-9]+) *\\).*" "\\1" TEST_NAME ${HIT})
            add_test(NAME "${TEST_EXECUTABLE_NAME}.${TEST_NAME}" 
                     COMMAND ${TEST_EXECUTABLE_NAME}
                     --run_test=${TEST_NAME} --catch_system_error=yes)
        endforeach()
    endif()
endfunction(add_boost_test)
