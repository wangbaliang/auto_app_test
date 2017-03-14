#!/usr/bin/env bash

# 0 16 * * *

cd /usr/ET/projects/etutor
source virtual_env/bin/activate
python -m etutorservice -c etc/default.yml -e clazz init_place
python -m etutorservice -c etc/default.yml -e clazz remove_expired_students
python -m etutorservice -c etc/default.yml -e invite create
