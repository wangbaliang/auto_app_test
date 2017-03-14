# -*- coding: utf-8 -*-
import thriftpy

from etutorservice.utils.thrift_helper import ThriftClient
from etutorservice.utils.config_helper import config

upland_thrift = thriftpy.load('thriftfiles/upland.thrift', 'upland_thrift',
                              include_dirs=['thriftfiles'])


def get_client(service, service_name):
    return ThriftClient(service, config.data['thrift_service']['upland_server'],
                        service_name)
