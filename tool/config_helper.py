# -*- coding: utf-8 -*-

import yaml


class _Config(object):
    __config = None

    def load_config_file(self, path):
        with open(path, 'r') as f:
            self.__config = yaml.safe_load(f)

    @property
    def data(self):
        return self.__config


config = _Config()
