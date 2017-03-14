# -*- coding: utf-8 -*-
import unittest


# 定义测试用例的目录
test_dir = 'test_case'

# 匹配加载目录下的测试用例
discover = unittest.defaultTestLoader.discover(test_dir, pattern='jd*.py')

if __name__ == '__main__':
    # 执行测试集
    runner = unittest.TextTestRunner()
    runner.run(discover)
