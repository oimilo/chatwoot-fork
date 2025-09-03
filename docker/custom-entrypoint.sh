#!/bin/sh

set -e

# Remove any existing server pid file
rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

echo "Waiting for database to become ready...."

# Use DATABASE_URL directly with pg_isready
until pg_isready -d "$DATABASE_URL"
do
  echo "Waiting for database connection..."
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