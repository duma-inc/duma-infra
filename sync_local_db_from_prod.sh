#!/usr/bin/env bash
#
# sync_local_db_from_prod.sh
#
# Automates refreshing the LOCAL duma_db (docker-compose service `db`) from a
# PRODUCTION dump, without losing the local Keycloak identity links.
#
# Why the identity step exists:
#   Production and local run *different* Keycloak instances, so `users.keycloak_id`
#   values from prod are meaningless locally. A plain restore therefore logs you out
#   of every local account, and drops local-only accounts entirely (e.g. the
#   COLLABORATOR admin `matheus@duma.local`, which does not exist in production).
#   This script snapshots the local email -> keycloak_id mapping before wiping, then
#   re-applies it afterwards, matching on email (the stable key across environments).
#
# Usage:
#   ./sync_local_db_from_prod.sh --fetch        # pull a fresh prod dump, then restore
#   ./sync_local_db_from_prod.sh                # restore from the existing dump file
#   ./sync_local_db_from_prod.sh --fetch-only   # only refresh the dump file
#   ./sync_local_db_from_prod.sh --file x.sql   # use a specific dump
#   ./sync_local_db_from_prod.sh --yes          # skip the confirmation prompt
#
set -euo pipefail
cd "$(dirname "$0")"

# ---------------------------------------------------------------- configuration
PROD_HOST="${PROD_HOST:-72.61.60.208}"
PROD_NS="${PROD_NS:-duma}"
PROD_DB_DEPLOY="${PROD_DB_DEPLOY:-deploy/duma-db}"
DB_USER="${DB_USER:-duma}"
DB_NAME="${DB_NAME:-duma_db}"
DUMP_FILE="duma_db_backup.sql"
BACKUP_DIR="backups"

DO_FETCH=0
DO_RESTORE=1
ASSUME_YES=0

# `docker` needs the docker group. If this shell's credentials predate a
# `usermod -aG docker` (i.e. you have not logged out since), re-exec this whole
# script once under `sg docker` so the group is active for every command.
# Note: `sg -c` runs its argument with /bin/sh, so the re-exec line is quoted
# POSIX-style — bash's `printf %q` would emit $'...' forms that dash cannot parse.
if ! docker info >/dev/null 2>&1; then
  if [[ -z "${DUMA_SYNC_SG_REEXEC:-}" ]] && getent group docker | cut -d: -f4 | tr ',' '\n' | grep -qx "$USER"; then
    shq() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }
    cmd="DUMA_SYNC_SG_REEXEC=1 bash $(shq "$(readlink -f "$0")")"
    for a in "$@"; do cmd="$cmd $(shq "$a")"; done
    echo "==> docker group not active in this shell; re-running under 'sg docker'"
    exec sg docker -c "$cmd"
  fi
  echo "ERROR: no docker access. Run: sudo usermod -aG docker \$USER  (then log out and back in)" >&2
  exit 1
fi

dc() { docker compose "$@"; }

# Run psql inside the db container. Fails the script on the first SQL error.
psql_local() {
  dc exec -T db psql -v ON_ERROR_STOP=1 -U "$DB_USER" -d "$DB_NAME" "$@"
}
# Same, but tolerant — used for the dump replay, which emits benign notices.
psql_local_lax() {
  dc exec -T db psql -U "$DB_USER" -d "$DB_NAME" "$@"
}

log() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# ------------------------------------------------------------------- arg parsing
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fetch)      DO_FETCH=1 ;;
    --fetch-only) DO_FETCH=1; DO_RESTORE=0 ;;
    --file)       DUMP_FILE="${2:?--file needs a path}"; shift ;;
    --yes|-y)     ASSUME_YES=1 ;;
    -h|--help)    sed -n '2,26p' "$0"; exit 0 ;;
    *)            die "unknown option: $1 (try --help)" ;;
  esac
  shift
done

mkdir -p "$BACKUP_DIR"
TS="$(date +%Y%m%d-%H%M%S)"

# =============================================================== 1. fetch prod
if [[ $DO_FETCH -eq 1 ]]; then
  log "Dumping production $DB_NAME from $PROD_HOST (namespace $PROD_NS)"
  TMP_DUMP="$(mktemp "${TMPDIR:-/tmp}/duma_prod_dump.XXXXXX.sql")"
  trap 'rm -f "$TMP_DUMP"' EXIT

  # pg_dump is read-only. --no-owner/--no-privileges keeps it portable across envs.
  ssh -o BatchMode=yes -o ConnectTimeout=15 "$PROD_HOST" \
    "kubectl -n $PROD_NS exec $PROD_DB_DEPLOY -- pg_dump -U $DB_USER -d $DB_NAME --no-owner --no-privileges" \
    > "$TMP_DUMP"

  # Guard against a truncated/failed dump silently overwriting a good backup.
  grep -q 'PostgreSQL database dump complete' "$TMP_DUMP" \
    || die "prod dump looks truncated (no completion marker); leaving $DUMP_FILE untouched"
  [[ -s "$TMP_DUMP" ]] || die "prod dump is empty"

  if [[ -f "$DUMP_FILE" ]]; then
    cp "$DUMP_FILE" "$BACKUP_DIR/$(basename "${DUMP_FILE%.sql}")-superseded-$TS.sql"
  fi
  mv "$TMP_DUMP" "$DUMP_FILE"
  trap - EXIT
  cp "$DUMP_FILE" "$BACKUP_DIR/prod-$TS.sql"

  PROD_FLYWAY="$(grep -oP '^\d+\t\K\d+' <<<"$(sed -n '/^COPY public.flyway_schema_history/,/^\\\.$/p' "$DUMP_FILE")" | sort -n | tail -1 || true)"
  log "Prod dump written: $DUMP_FILE ($(du -h "$DUMP_FILE" | cut -f1)), flyway head V${PROD_FLYWAY:-?}"
  log "Archived copy: $BACKUP_DIR/prod-$TS.sql"
fi

[[ $DO_RESTORE -eq 1 ]] || { log "--fetch-only: local database untouched."; exit 0; }

# ============================================================ 2. preflight checks
[[ -f "$DUMP_FILE" ]] || die "dump file not found: $DUMP_FILE"
[[ -s "$DUMP_FILE" ]] || die "dump file is empty: $DUMP_FILE"
grep -q 'PostgreSQL database dump' "$DUMP_FILE" || die "$DUMP_FILE is not a pg_dump file"

dc ps --status running --services 2>/dev/null | grep -qx db \
  || die "the 'db' service is not running. Start it with: docker compose up -d db"
psql_local -tAc 'select 1' >/dev/null || die "cannot reach postgres inside the db container"

if [[ $ASSUME_YES -eq 0 ]]; then
  echo
  echo "  This DESTROYS the local '$DB_NAME' schema and replaces it with:"
  echo "      $DUMP_FILE"
  echo "  A safety dump of the current local DB is taken first, into $BACKUP_DIR/."
  echo
  read -r -p "  Continue? [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]] || die "aborted by user"
fi

# ===================================================== 3. safety backup of local
SAFETY="$BACKUP_DIR/local-pre-restore-$TS.sql"
log "Backing up the CURRENT local database -> $SAFETY"
dc exec -T db pg_dump -U "$DB_USER" -d "$DB_NAME" --no-owner --no-privileges > "$SAFETY"
grep -q 'PostgreSQL database dump complete' "$SAFETY" || die "safety backup failed; aborting before any destructive step"
gzip -f "$SAFETY"
log "Safety backup: ${SAFETY}.gz ($(du -h "${SAFETY}.gz" | cut -f1))"

# ============================================= 4. snapshot local identity mapping
# email <TAB> keycloak_id <TAB> name <TAB> role <TAB> is_student <TAB> is_teacher
IDENT="$BACKUP_DIR/local-identities-$TS.tsv"
log "Snapshotting local Keycloak identity links"
psql_local -tA -F$'\t' -c "
  SELECT u.email, u.keycloak_id, u.name, coalesce(u.role,'STUDENT'),
         (s.id IS NOT NULL), (t.id IS NOT NULL)
    FROM users u
    LEFT JOIN students s ON s.id = u.id
    LEFT JOIN teachers t ON t.id = u.id
   ORDER BY u.email;" > "$IDENT" || true
IDENT_COUNT=$(grep -c . "$IDENT" 2>/dev/null || echo 0)
log "Captured $IDENT_COUNT local account(s) to re-link"
[[ $IDENT_COUNT -gt 0 ]] && cut -f1 "$IDENT" | sed 's/^/      - /'

# ================================================================ 5. stop the api
log "Stopping api (releases pooled connections and cached schema state)"
dc stop api >/dev/null 2>&1 || true

# ==================================================== 6. wipe and replay the dump
log "Dropping and recreating the public schema"
psql_local -c "
  SELECT pg_terminate_backend(pid) FROM pg_stat_activity
   WHERE datname = current_database() AND pid <> pg_backend_pid();" >/dev/null
psql_local -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO $DB_USER;"

log "Restoring $DUMP_FILE"
# Replayed leniently: a dump taken by a newer pg_dump can emit unknown-GUC notices
# (e.g. transaction_timeout on a PG16 server) that are harmless.
psql_local_lax --quiet < "$DUMP_FILE" 2>&1 | grep -Ei 'error' | grep -v 'transaction_timeout' || true

RESTORED_TABLES=$(psql_local -tAc "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';")
[[ "$RESTORED_TABLES" -gt 0 ]] || die "restore produced no tables — check the dump"
log "Restored $RESTORED_TABLES tables"

# ============================================ 7. apply migrations newer than dump
log "Applying any migrations newer than the dump (flyway)"
dc run --rm migrations

# ================================================ 8. re-link local Keycloak users
if [[ $IDENT_COUNT -gt 0 ]]; then
  log "Re-linking local Keycloak accounts"
  {
    echo "BEGIN;"
    while IFS=$'\t' read -r email kcid name role is_student is_teacher; do
      [[ -n "$email" ]] || continue
      q() { printf "'%s'" "${1//\'/\'\'}"; }   # single-quote + escape for SQL
      E=$(q "$email"); K=$(q "$kcid"); N=$(q "$name"); R=$(q "$role")

      # keycloak_id is UNIQUE + NOT NULL: park any prod row squatting on this id.
      echo "UPDATE users SET keycloak_id = 'stale-' || id WHERE keycloak_id = $K AND email <> $E;"
      # Restored prod row with the same email -> repoint it at the local identity.
      echo "UPDATE users SET keycloak_id = $K WHERE email = $E;"
      # Local-only account (absent from prod) -> recreate it.
      echo "INSERT INTO users (id, keycloak_id, name, email, enabled, role, created_at, updated_at)"
      echo "SELECT gen_random_uuid(), $K, $N, $E, true, $R, now(), now()"
      echo " WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = $E);"
      [[ "$is_student" == "t" ]] && \
        echo "INSERT INTO students (id, is_active, created_at, updated_at) SELECT u.id, true, now(), now() FROM users u WHERE u.email = $E ON CONFLICT (id) DO NOTHING;"
      [[ "$is_teacher" == "t" ]] && \
        echo "INSERT INTO teachers (id, is_active, created_at, updated_at) SELECT u.id, true, now(), now() FROM users u WHERE u.email = $E ON CONFLICT (id) DO NOTHING;"
    done < "$IDENT"
    echo "COMMIT;"
  } | psql_local >/dev/null
  log "Re-linked $IDENT_COUNT account(s); mapping kept at $IDENT"
fi

# ==================================================== 9. bring the api back up
log "Starting api"
dc start api >/dev/null

# ======================================================== 10. verification report
log "Verifying"
psql_local -c "
  SELECT (SELECT max(version::int) FROM flyway_schema_history WHERE success) AS flyway_head,
         (SELECT count(*) FROM users)    AS users,
         (SELECT count(*) FROM students) AS students,
         (SELECT count(*) FROM lessons)  AS lessons,
         (SELECT count(*) FROM attempts) AS attempts;"
psql_local -c "SELECT email, role, (keycloak_id LIKE 'stale-%') AS parked FROM users ORDER BY role, email LIMIT 20;"

printf '\n\033[1;32m==> Done.\033[0m Waiting for the api to report healthy...\n'
for i in $(seq 1 30); do
  if curl -fsS -m 3 http://localhost:8080/actuator/health >/dev/null 2>&1; then
    curl -s http://localhost:8080/actuator/health | head -c 200; echo
    echo "api is up."
    exit 0
  fi
  sleep 3
done
echo "api did not report healthy within 90s — check: docker compose logs -f api"
