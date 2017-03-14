# -*- coding: utf-8 -*-


class GetCookie(object):

    def get_login_cookie(self, driver, user_name, pwd):
        # 关闭首页广告
        driver.find_element_by_xpath(".//*[@id='J_newProductClose']/a/img").click()

        driver.find_element_by_link_text(u"登录").click()
        driver.find_element_by_id("iusername").clear()
        driver.find_element_by_id("iusername").send_keys(user_name)
        driver.find_element_by_id("iuserpwd").clear()
        driver.find_element_by_id("iuserpwd").send_keys(pwd)
        driver.find_element_by_name("submit").click()
        cookies = driver.get_cookies()
        print(cookies)
        for cookie in cookies:
            if 'etsessionid' in cookie.values():
                print(cookie)
                return cookie
        return False
