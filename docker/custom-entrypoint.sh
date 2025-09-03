#!/bin/sh

set -e

# Remove any existing server pid file
rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

echo "Waiting for postgres to become ready...."
./docker/entrypoints/helpers/pg_database_url.rb

export POSTGRES_HOST="${POSTGRES_HOST:-$POSTGRES_PORT_5432_TCP_ADDR}"
export POSTGRES_PORT="${POSTGRES_PORT:-$POSTGRES_PORT_5432_TCP_PORT}"

PG_READY="pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME"

until $PG_READY
do
  sleep 2
done

echo "Database ready to accept connections."

# Install any missing gems
bundle install

# Check bundle
bundle check

# Run database setup (creates database if not exists, runs migrations and seeds)
echo "Setting up database..."
bundle exec rails db:prepare || true

# Execute the main command
exec "$@"