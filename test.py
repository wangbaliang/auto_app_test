import unittest, time, re
from test_case.base import BaseLogic

db_session = 5555

class JdRegister(BaseLogic, unittest.TestCase):
    def __init__(self):
        super(JdRegister, self).__init__(db_session)
    def setUp(self):
        print(1111)
    def test_one(self):
        one = self._db()
        print(one)
    def tearDown(self):
        print(333)


if __name__ == '__main__':
    unittest.main()

# kill = 111
#
# class B(object):
#     def __init__(self, kill):
#         print(3333, kill)
#
# class A(object):
#     pass
#
# class C(A, B):
#     def __init__(self):
#         super(C, self).__init__(222222)
# a = C()
