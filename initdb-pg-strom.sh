#!/bin/bash

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_postgis IS_TEMPLATE true;
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
	echo "Loading extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
        CREATE EXTENSION IF NOT EXISTS pg_strom;
        CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL
done