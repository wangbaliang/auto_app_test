# -*- coding: utf-8 -*-

import os
import sys

parentdir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parentdir)

from models import W_UserValidateRecord

from tool.config_helper import config

config_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'default.yml')
config.load_config_file(config_path)

from common.db import (db_session_manager as session_manager)
session_manager.register_db(config.data['mysql_db']['web_mobile'], 'web_mobile')


def get_validate_code(phone):
    with session_manager.with_session('web_mobile') as db_session:
        db_session.flush()
        code_info = db_session.query(W_UserValidateRecord).filter_by(mobile=phone) \
            .order_by(W_UserValidateRecord.insertttime.desc())\
            .first()
        return code_info.validatecode


def delete_validate_code(phone):
    with session_manager.with_session('web_mobile') as db_session:
        code_info_list = db_session.query(W_UserValidateRecord).filter_by(mobile=phone) \
            .all()
        if code_info_list:
            for code_info in code_info_list:
                db_session.delete(code_info)
            db_session.commit()
        return True
