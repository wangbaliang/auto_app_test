# -*- coding: utf-8 -*-
import unittest
import time
import os
from HTMLTestRunner import HTMLTestRunner

from test_case import invite_code

from tool.mail_helper import send_email
from tool.config_helper import config


# 构造测试集
suite = unittest.TestSuite()
suite.addTest(invite_code.JdRegister("test_invite_code"))
config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'default.yml')
config.load_config_file(config_path)

if __name__ == '__main__':

    # 执行测试集
    runner = unittest.TextTestRunner()

    now = time.strftime("%Y_%m_%d_%H_%M_%S")
    file_name = 'report\\' + now + 'result.html'
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), file_name)
    with open(path, 'wb') as f:
        runner = HTMLTestRunner(stream=f, title=u'简单课堂APP邀请码注册测试', description=u'用例执行情况：')
        runner.run(suite)

    with open(path, 'r') as f:
        content = f.read()
        send_email(config.data['report_email'], u'简单课堂APP邀请码注册测试数据', content=content, file_path=path)
