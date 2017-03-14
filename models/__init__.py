# -*- coding: utf-8 -*-

import datetime
import json
import arrow

from sqlalchemy import Column, func
from sqlalchemy.dialects.mysql import (
    VARCHAR, INTEGER, TINYINT, SMALLINT, DATE, TEXT, TIMESTAMP, DATETIME, TIME,
    BOOLEAN, MEDIUMINT, DECIMAL,
)

from common.db import ModelBase
from tool.config_helper import config


__all__ = [
    'W_UserBaseInfo',
    'W_R_User_InviteCodeRec',
    'W_UserValidateRecord',
]


class W_UserBaseInfo(ModelBase):
    """
    用户信息基本表
    """


class W_R_User_InviteCodeRec(ModelBase):
    """
    渠道邀请码记录表
    """


class W_UserValidateRecord(ModelBase):
    """
    注册短信验证码
    """

