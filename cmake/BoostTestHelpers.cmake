# This code has been modified. The original source is:
# https://eb2.co/blog/2015/06/driving-boost.test-with-cmake/

find_package(Boost COMPONENTS unit_test_framework REQUIRED)

function(add_boost_test SOURCE_FILE_NAME DEPENDENCY_LIB)
    get_filename_component(TEST_EXECUTABLE_NAME ${SOURCE_FILE_NAME} NAME_WE)

    add_executable(${TEST_EXECUTABLE_NAME} ${SOURCE_FILE_NAME})
    target_link_libraries(${TEST_EXECUTABLE_NAME} 
                          ${DEPENDENCY_LIB} ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})

    # Two ways of running tests and reporting depend on `RUNTEST_ONESHOT`
    #   - if TRUE  : Run all the tests in a binary together and report the whole result
    #   - if FALSE : Run each test(BOOST_AUTO_TEST_CASE) and report individually
    if(${RUNTEST_ONESHOT})
        add_test(NAME "${TEST_EXECUTABLE_NAME}"
                 COMMAND ${TEST_EXECUTABLE_NAME} --catch_system_error=yes)
    else()
        # NOTE BOOST_AUTO_TEST_SUITE is UNSUPPORTED.
        #      DO NOT use it in the test source or all tests will fail to run.

        file(READ "${SOURCE_FILE_NAME}" SOURCE_FILE_CONTENTS)
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
