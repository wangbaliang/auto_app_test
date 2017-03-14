# -*- coding: utf-8 -*-

import importlib
import argparse
import logging
import sys

from etutorservice.utils.config_helper import config
from etutorservice.utils.thrift_helper import create_multiplexed_server
from etutorservice.common.db import (
    db_session_manager as session_manager,
    redis_manager,
)


def _parse_args():
    parser = argparse.ArgumentParser('run tutor service or commands')
    parser.add_argument('-c', '--config', dest='config_file', required=True,
                        help='config file path')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-r', '--runservice', action='store_true',
                       dest='run_service')
    group.add_argument('-e', '--exec', dest='command_name',
                       help='exec command name')
    parser.add_argument('command_args', nargs='*',
                        help='sub command args')
    return parser.parse_args()

def _run_sub_command(command_name, command_args):
    try:
        command_module = importlib.import_module(
            'etutorservice.jobs.%s' % command_name)
        command_module.run(command_args)
    except ImportError as e:
        print('the command %s not found' % e.message)


def _init_logging_setting():
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    return logger


def main():
    logger = _init_logging_setting()

    args = _parse_args()

    config.load_config_file(args.config_file)

    session_manager.register_db(config.data['mysql_db']['tutor'], 'default')
    # redis_manager.register_db(config.data['redis_db'], config.data['redis_server'])

    if args.run_service:
        logger.info('service start')
    elif args.command_name:
        logger.info('command start')
        _run_sub_command(args.command_name, args.command_args)
    else:
        print('args not valid')


if __name__ == '__main__':
    main()
