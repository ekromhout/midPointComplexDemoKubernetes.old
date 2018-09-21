#!/bin/bash
set -e

echo Creating midPoint user and database

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER midpoint WITH PASSWORD '456654' LOGIN SUPERUSER;
    CREATE DATABASE midpoint WITH OWNER = midpoint ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8' CONNECTION LIMIT = -1;
EOSQL

echo midPoint user and database were created

