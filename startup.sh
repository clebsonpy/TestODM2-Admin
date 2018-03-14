#!/bin/bash

echo "Activating environment..."
source activate odm2adminenv
conda install --yes -c conda-forge sqlalchemy

#echo "Building database..."
#su - postgres -c 'pg_restore -d odm2_db -1 -v "/ODM2-Admin/ODM2AdminDBBlank"'
#
#su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password 'test';\""
#
echo "Migrate django tables"
python manage.py migrate

echo "Loading Controlled Vocabularies"
wget https://raw.githubusercontent.com/ODM2/ODM2/master/src/load_cvs/cvload.py
python cvload.py postgresql+psycopg2://postgres:test@db:5432/odm2

echo "Running server..."
python manage.py runserver 0.0.0.0:8000