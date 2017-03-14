# -*- coding: utf-8 -*-


from contextlib import contextmanager

from sqlalchemy import engine_from_config
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

__all__ = ['ModelBase', 'db_session_manager']


class _DbSessionManager(object):
    def __init__(self):
        self.__session_maker_dict = {}
        self.__engine_dict = {}

    def __set_engine(self, db_config, name):
        engine = engine_from_config(db_config, '', encoding="utf-8")
        engine.execute('SET time_zone=\'+08:00\';')
        self.__engine_dict[name] = engine_from_config(db_config, '', encoding="utf-8")

    def __get_engine(self, name):
        return self.__engine_dict[name]

    def __get_session_maker(self, name):
        engine = self.__get_engine(name)
        return sessionmaker(bind=engine)

    def register_db(self, db_config, name):
        self.__set_engine(db_config, name)
        self.__session_maker_dict[name] = self.__get_session_maker(name)

    @contextmanager
    def with_session(self, name):
        session_maker = self.__session_maker_dict[name]
        session = session_maker()
        try:
            yield session
        finally:
            session.close()

    @contextmanager
    def with_connection(self, name='default'):
        engine = self.__get_engine(name)
        engine.execute('SET time_zone=\'+08:00\';')
        connection = engine.connect()
        try:
            yield connection
        finally:
            connection.close()

    def get_session(self, name='default'):
        session_maker = self.__session_maker_dict[name]
        return session_maker()


db_session_manager = _DbSessionManager()

ModelBase = declarative_base()
