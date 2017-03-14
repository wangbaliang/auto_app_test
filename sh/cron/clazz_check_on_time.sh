#!/usr/bin/env bash

# * 23-15 * * *

cd /usr/ET/projects/etutor
source virtual_env/bin/activate
python -m etutorservice -c etc/default.yml -e clazz check_on_time
