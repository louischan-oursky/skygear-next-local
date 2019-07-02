#!/bin/sh

set -eu

MIGRATE_IMAGE='quay.io/skygeario/skygear-migrate:git-ef8ac87'
DATABASE_URL='postgres://postgres:@host.docker.internal:5433/postgres?sslmode=disable'

# Start the database and wait for it to be ready
docker-compose up -d skygear-db
sleep 10

# Create schema app_auth
docker-compose exec skygear-db psql -U postgres -c 'CREATE SCHEMA app_auth;'

# Run "core" migration for auth
docker run \
  --rm \
  "$MIGRATE_IMAGE" \
  -schema=app_auth \
  -module=core \
  -database="$DATABASE_URL" \
  up

# Run "auth" migration for auth
docker run \
  --rm \
  "$MIGRATE_IMAGE" \
  -schema=app_auth \
  -module=auth \
  -database="$DATABASE_URL" \
  up
