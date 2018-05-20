#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE Main
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE(Add1)
{
    BOOST_CHECK(10 + 20 == 30);
}

BOOST_AUTO_TEST_CASE(Add2)
{
    BOOST_CHECK(10 + 20 == 20 + 10);
}

BOOST_AUTO_TEST_CASE(Add3)
{
    BOOST_CHECK(1 + 2 + 3 == 6);
}

BOOST_AUTO_TEST_CASE(Mul1)
{
    BOOST_CHECK(2 * 2 * 2 == 8);
}

