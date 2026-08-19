#!/usr/bin/env bash
#
# fix_basic_scope.sh — restores the `sub` claim in Keycloak access tokens.
#
# Problem this fixes:
#   Since Keycloak 24 the `sub` (and `auth_time`) claim is contributed by the
#   built-in `basic` client scope, not by the token core. This realm was created
#   from keycloak/realm-export.json, which only defines the `profile`, `email` and
#   `roles` scopes — so `basic` does not exist and no client gets `sub`.
#
#   duma-backend's JwtUserResolver reads `sub` first, then falls back to
#   `preferred_username`, then `email`. With no `sub` it looked users up by email
#   against users.keycloak_id (a UUID), so every authenticated request 404'd with:
#       "User not found for keycloakId: <email>"
#
# What it does: creates the `basic` client scope (with the sub + auth_time
# mappers) and assigns it as a default scope to the OIDC clients. Idempotent.
#
# After running, users must sign out and back in — existing sessions still hold
# tokens minted without `sub`.
#
set -euo pipefail

KC_URL="${KC_URL:-http://localhost:8081}"
KC_REALM="${KC_REALM:-duma-realm}"
KC_ADMIN_USER="${KC_ADMIN_USER:-duma}"
KC_ADMIN_PASS="${KC_ADMIN_PASS:-163duma}"
read -r -a CLIENTS <<<"${*:-duma-web duma-adm}"

log() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

log "Authenticating against $KC_URL (realm master)"
TOK=$(curl -s -m 15 \
  -d "client_id=admin-cli" -d "username=$KC_ADMIN_USER" \
  -d "password=$KC_ADMIN_PASS" -d "grant_type=password" \
  "$KC_URL/realms/master/protocol/openid-connect/token" \
  | python3 -c "import sys,json;print(json.load(sys.stdin).get('access_token',''))")
[[ -n "$TOK" ]] || die "could not obtain an admin token (check KC_ADMIN_USER/KC_ADMIN_PASS)"

BASE="$KC_URL/admin/realms/$KC_REALM"
auth=(-H "Authorization: Bearer $TOK")

scope_id() {
  curl -s -m 15 "${auth[@]}" "$BASE/client-scopes" | python3 -c "
import sys,json
print(next((s['id'] for s in json.load(sys.stdin) if s['name']=='basic'), ''))"
}

if [[ -n "$(scope_id)" ]]; then
  log "'basic' client scope already exists — skipping creation"
else
  log "Creating the 'basic' client scope (sub + auth_time mappers)"
  payload=$(mktemp); trap 'rm -f "$payload"' EXIT
  cat > "$payload" <<'JSON'
{
  "name": "basic",
  "description": "OpenID Connect scope for add all basic claims to the token",
  "protocol": "openid-connect",
  "attributes": { "include.in.token.scope": "false", "display.on.consent.screen": "false" },
  "protocolMappers": [
    { "name": "sub", "protocol": "openid-connect", "protocolMapper": "oidc-sub-mapper",
      "consentRequired": false,
      "config": { "introspection.token.claim": "true", "access.token.claim": "true" } },
    { "name": "auth_time", "protocol": "openid-connect",
      "protocolMapper": "oidc-usersessionmodel-note-mapper", "consentRequired": false,
      "config": { "user.session.note": "AUTH_TIME", "introspection.token.claim": "true",
                  "userinfo.token.claim": "true", "id.token.claim": "true",
                  "access.token.claim": "true", "claim.name": "auth_time",
                  "jsonType.label": "long" } }
  ]
}
JSON
  code=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE/client-scopes" \
    "${auth[@]}" -H 'Content-Type: application/json' --data-binary @"$payload")
  [[ "$code" == 201 || "$code" == 409 ]] || die "creating 'basic' scope failed (HTTP $code)"
fi

SCOPE_ID="$(scope_id)"
[[ -n "$SCOPE_ID" ]] || die "'basic' scope still not found after creation"

for c in "${CLIENTS[@]}"; do
  CID=$(curl -s -m 15 "${auth[@]}" "$BASE/clients?clientId=$c" \
    | python3 -c "import sys,json;d=json.load(sys.stdin);print(d[0]['id'] if d else '')")
  if [[ -z "$CID" ]]; then
    echo "    $c: client not found in realm $KC_REALM — skipped"
    continue
  fi
  code=$(curl -s -o /dev/null -w '%{http_code}' -X PUT \
    "$BASE/clients/$CID/default-client-scopes/$SCOPE_ID" "${auth[@]}")
  echo "    $c: assign 'basic' as default scope -> HTTP $code"
done

log "Verifying: generating an example access token per client"
for c in "${CLIENTS[@]}"; do
  CID=$(curl -s -m 15 "${auth[@]}" "$BASE/clients?clientId=$c" \
    | python3 -c "import sys,json;d=json.load(sys.stdin);print(d[0]['id'] if d else '')")
  [[ -n "$CID" ]] || continue
  UID_=$(curl -s -m 15 "${auth[@]}" "$BASE/users?max=1&briefRepresentation=true" \
    | python3 -c "import sys,json;d=json.load(sys.stdin);print(d[0]['id'] if d else '')")
  [[ -n "$UID_" ]] || { echo "    $c: no users in realm to sample"; continue; }
  curl -s -m 15 "${auth[@]}" \
    "$BASE/clients/$CID/evaluate-scopes/generate-example-access-token?userId=$UID_&scope=openid+profile+email" \
    | python3 -c "
import sys,json
p=json.load(sys.stdin)
sub=p.get('sub')
print(f\"    $c: sub={'PRESENT ('+sub+')' if sub else 'STILL MISSING'}\")"
done

printf '\n\033[1;32m==> Done.\033[0m Sign out and sign in again — existing sessions still carry\n'
printf '    tokens minted without a sub claim.\n'
