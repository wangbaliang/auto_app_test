#!/usr/bin/env bash

# 5 * * * *

cd /usr/ET/projects/etutor
source virtual_env/bin/activate
python -m etutorservice -c etc/default.yml -e invite notify_class
