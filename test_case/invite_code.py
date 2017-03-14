# -*- coding: utf-8 -*-

from appium import webdriver
from selenium.webdriver.common.by import By
from time import sleep
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import unittest, time, re

import os
import sys

from sqlalchemy import func, or_, not_, and_

parentdir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parentdir)

from tool.mail_helper import send_email
from tool.config_helper import config
from tool.logging_helper import logger

config_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'default.yml')
config.load_config_file(config_path)

from tool.mobile_web import get_validate_code, delete_validate_code
from common.db import (db_session_manager as session_manager)
session_manager.register_db(config.data['mysql_db']['easyweb'], 'easyweb')

from models import (W_UserBaseInfo, W_R_User_InviteCodeRec, W_UserValidateRecord)

class JdRegister(unittest.TestCase):
    u"""测试邀请码"""

    def setUp(self):
        self.verificationErrors = []
        self.now = time.strftime("%Y_%m_%d_%H_%M_%S")

        # 获取准备的用户测试数据
        path_user = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                                 'test_data\\user_info\\user.txt')
        with open(path_user, 'r') as f:
            lines = f.readlines()
            user_data = lines[0].split(',')
            self.user_name = user_data[0]
            self.pwd = user_data[1]
            self.phone = user_data[2]

        # 获取测试包数据列表
        self.path = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + '\\test_data\\pacakge'
        self.file_list = os.listdir(self.path)

        # 设置真机设备驱动参数
        self.desired_caps = {}
        self.desired_caps['platformName'] = 'Android'
        self.desired_caps['platformVersion'] = '4.4.4'
        self.desired_caps['deviceName'] = 'ebf2de74'
        self.desired_caps['appPackage'] = 'com.jiandan.mobilelesson'
        # #已登录的情况
        # desired_caps['appWaitActivity']='com.jiandan.mobilelesson.ui.MainActivity_New'
        # desired_caps['appActivity']='.InstallOpenActivity'
        # 未登录的情况
        self.desired_caps['appWaitActivity'] = 'com.jiandan.mobilelesson.ui.LoginActivity'
        self.desired_caps['appActivity'] = '.InstallOpenActivity'

        # # 中文输入
        # self.desired_caps['unicodeKeyboard'] = True
        # 隐藏键盘
        self.desired_caps['resetKeyboard'] = True

    def test_invite_code(self):
        u"""注册流程"""

        with session_manager.with_session('easyweb') as db:
            for file_name in self.file_list:
                self.test_num = self.file_list.index(file_name) + 1
                logger.info(u'  Test  Start %s: %s ' % (self.test_num, file_name))

                # 判断用户是否已存在,存在则删除
                user_info = self.is_user_exist(db, self.user_name, self.phone)
                if user_info:
                    for info in user_info:
                        db.delete(info)
                    db.commit()

                # 删除已存在该号码的验证码记录
                delete_validate_code(self.phone)

                # 安装包及获取邀请码
                page_name = file_name
                file_path = self.path + '\\' + file_name
                invite_code = page_name.split('_')[1]

                self.desired_caps['app'] = file_path

                # 建立链接会话 驱动设备
                self.driver = webdriver.Remote('http://localhost:4723/wd/hub', self.desired_caps)
                self.driver.implicitly_wait(30)

                # 以下为注册流程操作
                try:
                    driver = self.driver
                    driver.find_element_by_id("regist_user").click()

                    driver.find_element_by_id("user_name").clear()
                    driver.find_element_by_id("user_name").send_keys(self.user_name)
                    try:
                        driver.hide_keyboard()
                    except:
                        pass
                    # self.user_name = driver.find_element_by_id("user_name").get_attribute("value")
                    # 有时真是注册时 首字母被大写了，故此获取一下真实输入的用户名
                    user_name = driver.find_element_by_id("user_name").text

                    driver.find_element_by_id("password").clear()
                    driver.find_element_by_id("password").send_keys(self.pwd)
                    try:
                        driver.hide_keyboard()
                    except:
                        pass
                    pwd = driver.find_element_by_id("password").text

                    driver.find_element_by_id('gradetv').click()
                    grade = ".//android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.ListView[1]/android.widget.TextView[1]"
                    driver.find_element_by_xpath(grade).click()
                    year = ".//android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.ListView[2]/android.widget.TextView[2]"
                    element1 = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.XPATH, year)))
                    element1.click()

                    driver.find_element_by_id("school").click()
                    element2 = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.ID, "confirm")))
                    element2.click()
                    driver.find_element_by_id("cellphone").clear()
                    driver.find_element_by_id("cellphone").send_keys(self.phone)
                    try:
                        driver.hide_keyboard()
                    except:
                        pass
                    driver.find_element_by_id("getcheckcode").click()
                    sleep(3)
                    # 获取验证码
                    message_code = get_validate_code(self.phone)
                    if not message_code:
                        logger.info(u'未获取到短信验证码:%s' % message_code)
                        return
                    driver.find_element_by_id("checkcode").clear()
                    driver.find_element_by_id("checkcode").send_keys(message_code)
                    try:
                        driver.hide_keyboard()
                    except:
                        pass
                    element3 = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.ID, "use_regist")))
                    element3.click()

                    # 判断注册成功
                    self.driver.find_element(by='id', value='yes_update_btn')

                    #  写入本次测试信息到文件
                    real_invite_code = self.__get_res_code(db, user_name)
                    record = [page_name, user_name, pwd, self.phone, message_code, invite_code, real_invite_code]
                    driver.remove_app('com.jiandan.mobilelesson')
                    driver.quit()
                    logger.info(u'本次测试信息：', record)
                    self.assertEqual(invite_code, real_invite_code)
                    logger.info(u'---------  第 %s 个包测试成功！！' % self.test_num)
                except:
                    now = time.strftime("%Y_%m_%d_%H_%M_%S")
                    error_jpg = 'error_jpg\\' + now + 'invite_error%s.jpg' % self.test_num
                    path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), error_jpg)
                    driver.get_screenshot_as_file(path)
                    logger.error(u'---------  第 %s 个包测试失败！！' % self.test_num)
                    self.verificationErrors.append(error_jpg)
                    driver.remove_app('com.jiandan.mobilelesson')
                    driver.quit()

    def tearDown(self):
        # driver.install_app('D:\\auto_app_test\\MobileLessonv1.11.0.161017_jd100_4release.apk')
        self.assertEqual([], self.verificationErrors)

    @staticmethod
    def is_user_exist(db, user_name, phone):
        first_big = user_name.capitalize()
        data = db.query(W_UserBaseInfo)\
            .filter(or_(W_UserBaseInfo.username == user_name, W_UserBaseInfo.username == first_big,
                        W_UserBaseInfo.mobile == phone)).all()
        return data

    @staticmethod
    def __get_res_code(db, user_name):
        code_info = db.query(W_R_User_InviteCodeRec).select_from(W_R_User_InviteCodeRec)\
            .join(W_UserBaseInfo, W_UserBaseInfo.id == W_R_User_InviteCodeRec.userid)\
            .filter(W_UserBaseInfo.username == user_name)\
            .first()
        return code_info.invitecode

    def is_element_present(self, how, what):
        try:
            self.driver.find_element(by=how, value=what)
        except NoSuchElementException as e:
            logger.error(e.message)
            return False
        return True

if __name__ == '__main__':

    unittest.main()


