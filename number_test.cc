#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE Main
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE(Test1)
{
    BOOST_CHECK(2 < 1); // FAIL
}

BOOST_AUTO_TEST_CASE(Test2)
{
    BOOST_CHECK(2 < 4);
}

BOOST_AUTO_TEST_CASE(Test3)
{
    BOOST_CHECK(2 == 4); // FAIL
}

