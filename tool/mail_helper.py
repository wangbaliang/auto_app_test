# -*- coding: utf-8 -*-

import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders
import os

from tool.config_helper import config


def __traverse_path(file_path):
    message = MIMEMultipart()
    msg = MIMEBase('application', 'octet-stream')

    file_get = open(file_path, 'rb').read()
    msg.set_payload(file_get)
    encoders.encode_base64(msg)
    file_name = os.path.basename(file_path)
    msg.add_header('Content-Disposition', 'attachment', filename=file_name)
    message.attach(msg)
    return message


def send_email(to_addresses, subject, content, content_type='html', charset='utf-8', file_path=None):
    """
    发送邮件
    :param to_addresses: 收件人邮箱，以;分隔
    :param subject: 邮件主题
    :param content: 邮件正文
    :param files: 文件名/文件夹名(皆可)列表
    :return:
    """
    smtp_config = config.data['smtp']
    server_host = smtp_config['host']
    server_port = smtp_config['port']
    user_name = smtp_config['user_name']
    password = smtp_config['password']
    timeout = smtp_config.get('timeout', 3)
    from_address = user_name

    if file_path:
        message = __traverse_path(file_path)
        message.attach(MIMEText(content, _subtype=content_type, _charset=charset))
    else:
        message = MIMEText(content, _subtype=content_type, _charset=charset)

    message['Subject'] = subject
    message['From'] = from_address
    message['To'] = ';'.join(to_addresses)
    client = smtplib.SMTP(server_host, server_port, timeout=timeout)
    client.starttls()
    client.login(user_name, password)
    client.sendmail(from_address, to_addresses, message.as_string())
    client.quit()
