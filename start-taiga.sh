#!/bin/bash
sudo service nginx start
sudo service postgresql start
cd /home/taiga
source .virtualenvs/taiga/bin/activate
cd taiga-back
python manage.py runserver localhost:8001 &> /dev/stdout
