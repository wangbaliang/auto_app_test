#!/usr/bin/env bash

# * * * * *

cd /usr/ET/projects/etutor
source virtual_env/bin/activate
python -m etutorservice -c etc/default.yml -e invite exec
