#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Stopping api (holds live connections/cached schema state)"
docker compose stop api

echo "==> Dropping and recreating the public schema (wipes current data)"
docker compose exec -T db psql -U duma -d duma_db -c \
  "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO duma;"

echo "==> Restoring duma_db_backup.sql (schema as of migration V36 + data)"
docker compose exec -T db psql -U duma -d duma_db < duma_db_backup.sql

echo "==> Applying migrations newer than the dump (V37-V40) via flyway"
docker compose run --rm migrations

echo "==> Re-linking matheus@duma.local's Postgres row to its existing Keycloak account"
docker compose exec -T db psql -U duma -d duma_db <<'SQL'
INSERT INTO users (id, keycloak_id, name, email, enabled, role, created_at, updated_at)
VALUES ('046005f5-0d44-4738-b0d0-c2a2726f9634', 'cca53ec7-5bd2-44e2-8191-fa01771a3cea', 'Matheus Duma', 'matheus@duma.local', true, 'COLLABORATOR', now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO teachers (id, is_active, created_at, updated_at)
VALUES ('046005f5-0d44-4738-b0d0-c2a2726f9634', true, now(), now())
ON CONFLICT (id) DO NOTHING;
SQL

echo "==> Restarting api"
docker compose start api

echo "==> Done. Verify with: curl http://localhost:8080/actuator/health"
