#!/usr/bin/env bash

# 0 9,14 * * *

cd /usr/ET/projects/etutor
source virtual_env/bin/activate
python -m etutorservice -c etc/default.yml -e invite notify_test
