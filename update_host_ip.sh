#!/usr/bin/env bash
#
# update_host_ip.sh — repoint the whole local DUMA stack at the machine's current LAN IP.
#
# Why this exists:
#   Keycloak signs ONE canonical hostname (KC_HOSTNAME) into its discovery document
#   and into every token. That hostname must be reachable BOTH from the browser and
#   from inside the adm/api containers, so "localhost" cannot be used (inside a
#   container it points at the container itself). The stack therefore pins the host's
#   LAN IP — which DHCP happily changes, breaking every login with a dead redirect.
#
#   This script rewrites that IP everywhere it is pinned and restarts/rebuilds only
#   what actually needs it.
#
# Files it manages:
#   duma-infra/.env         HOST_IP=            (adm, ava, api and KC_HOSTNAME all derive from it)
#   duma-ava/.env.local     KEYCLOAK_ISSUER, NEXT_PUBLIC_KEYCLOAK_ISSUER, NEXT_PUBLIC_API_URL
#   duma-mobile/.env        EXPO_PUBLIC_API_URL, EXPO_PUBLIC_KEYCLOAK_URL
#
# Usage:
#   ./update_host_ip.sh              # detect the current LAN IP and apply
#   ./update_host_ip.sh 192.168.1.42 # force a specific IP
#   ./update_host_ip.sh --dry-run    # show what would change, touch nothing
#   ./update_host_ip.sh --skip-docker# only rewrite files
#   ./update_host_ip.sh --force      # re-apply even if the IP has not changed
#
set -euo pipefail
cd "$(dirname "$0")"
INFRA="$PWD"
ROOT="$(cd .. && pwd)"

DRY=0; SKIP_DOCKER=0; FORCE=0; WANT_IP=""
for a in "$@"; do
  case "$a" in
    --dry-run)     DRY=1 ;;
    --skip-docker) SKIP_DOCKER=1 ;;
    --force)       FORCE=1 ;;
    -h|--help)     sed -n '2,28p' "$0"; exit 0 ;;
    -*)            echo "opção desconhecida: $a" >&2; exit 1 ;;
    *)             WANT_IP="$a" ;;
  esac
done

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
die()  { printf '\n\033[1;31mERRO: %s\033[0m\n' "$*" >&2; exit 1; }

# ------------------------------------------------------------ docker group
# If this shell predates a `usermod -aG docker`, re-exec once under `sg docker`.
# `sg -c` runs its argument with /bin/sh, so quote POSIX-style (no printf %q).
if [[ $SKIP_DOCKER -eq 0 && $DRY -eq 0 ]] && ! docker info >/dev/null 2>&1; then
  if [[ -z "${DUMA_IP_SG_REEXEC:-}" ]] && getent group docker | cut -d: -f4 | tr ',' '\n' | grep -qx "$USER"; then
    shq() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }
    cmd="DUMA_IP_SG_REEXEC=1 bash $(shq "$(readlink -f "$0")")"
    for a in "$@"; do cmd="$cmd $(shq "$a")"; done
    echo "==> grupo docker não ativo nesta shell; reexecutando via 'sg docker'"
    exec sg docker -c "$cmd"
  fi
  die "sem acesso ao docker. Rode: sudo usermod -aG docker \$USER (e faça logout/login)"
fi

# ------------------------------------------------------------ detect the IP
detect_ip() { ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K[0-9.]+' | head -1; }
NEW_IP="${WANT_IP:-$(detect_ip)}"
[[ -n "$NEW_IP" ]] || die "não consegui detectar o IP da LAN; passe explicitamente: $0 <ip>"
[[ "$NEW_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || die "IP inválido: $NEW_IP"

CUR_IP="$(grep -oP '^HOST_IP=\K.*' "$INFRA/.env" 2>/dev/null || true)"
log "IP atual no .env: ${CUR_IP:-<ausente>}   →   novo: $NEW_IP"

if [[ "$CUR_IP" == "$NEW_IP" && $FORCE -eq 0 ]]; then
  info "Já está correto. Nada a fazer (use --force para reaplicar)."
  exit 0
fi

# --------------------------------------------------- rewrite the env files
TS="$(date +%Y%m%d-%H%M%S)"
CHANGED=()

# Replaces the host part of `VAR=scheme://HOST[:port][/path]`, keeping port and path.
# Collects the replaced hosts into OLDS so comments can be fixed up too.
OLDS=()
rewrite_url_var() {
  local f="$1" v="$2" old
  grep -qE "^${v}=" "$f" 2>/dev/null || { info "  $v: ausente — pulado"; return 0; }
  old="$(grep -oP "^${v}=[a-z]+://\\K[^:/]+" "$f" | head -1)"
  [[ -n "$old" ]] || return 0
  if [[ $DRY -eq 0 ]]; then
    sed -i -E "s|^(${v}=[a-z]+://)[^:/]+|\\1${NEW_IP}|" "$f"
  fi
  info "  $v: $old → $NEW_IP"
  [[ "$old" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && OLDS+=("$old")
  return 0
}

process_file() {
  local f="$1"; shift
  [[ -f "$f" ]] || { info "  (arquivo não encontrado: ${f#$ROOT/} — pulado)"; return 0; }
  log "Atualizando ${f#$ROOT/}"
  [[ $DRY -eq 0 ]] && cp "$f" "$f.bak-$TS"
  OLDS=()
  local v o
  for v in "$@"; do rewrite_url_var "$f" "$v"; done
  for o in $(printf '%s\n' "${OLDS[@]:-}" | sort -u); do
    [[ -z "$o" || "$o" == "$NEW_IP" ]] && continue
    if grep -qF "$o" "$f"; then
      [[ $DRY -eq 0 ]] && sed -i "s/${o//./\\.}/$NEW_IP/g" "$f"
      info "  (demais ocorrências de $o atualizadas)"
    fi
  done
  CHANGED+=("${f#$ROOT/}")
  return 0
}

log "Atualizando duma-infra/.env"
[[ $DRY -eq 0 ]] && cp "$INFRA/.env" "$INFRA/.env.bak-$TS"
if [[ $DRY -eq 0 ]]; then
  sed -i -E "s|^HOST_IP=.*|HOST_IP=${NEW_IP}|" "$INFRA/.env"
  # any other literal occurrence of the previous IP (comments, hardcoded URLs)
  [[ -n "$CUR_IP" ]] && sed -i "s/\b${CUR_IP//./\\.}\b/$NEW_IP/g" "$INFRA/.env"
fi
info "  HOST_IP: ${CUR_IP:-<ausente>} → $NEW_IP"
CHANGED+=("duma-infra/.env")

process_file "$ROOT/duma-ava/.env.local" \
  KEYCLOAK_ISSUER NEXT_PUBLIC_KEYCLOAK_ISSUER NEXT_PUBLIC_API_URL
process_file "$ROOT/duma-mobile/.env" \
  EXPO_PUBLIC_API_URL EXPO_PUBLIC_KEYCLOAK_URL

if [[ $DRY -eq 1 ]]; then
  log "--dry-run: nenhum arquivo foi alterado."
  exit 0
fi

log "Arquivos atualizados (backup .bak-$TS ao lado de cada um)"
printf '    - %s\n' "${CHANGED[@]}"

[[ $SKIP_DOCKER -eq 1 ]] && { log "--skip-docker: containers não tocados."; exit 0; }

# ------------------------------------------------------------ docker: apply
# keycloak/api só precisam de recriação (env de runtime).
log "Recriando keycloak e api (variáveis de runtime)"
docker compose up -d keycloak api

# adm/ava assam NEXT_PUBLIC_* no bundle em build time → precisam de rebuild.
log "Rebuild de adm e ava (NEXT_PUBLIC_* é inlined no build do Next.js)"
docker compose up -d --build adm ava

# ------------------------------------------------------------ verification
log "Verificando"
ISS="$(curl -s -m 15 http://localhost:8081/realms/duma-realm/.well-known/openid-configuration \
        | python3 -c 'import sys,json;print(json.load(sys.stdin).get("issuer",""))' 2>/dev/null || true)"
info "issuer anunciado : ${ISS:-<sem resposta>}"
[[ "$ISS" == *"$NEW_IP"* ]] && info "issuer confere com $NEW_IP" || info "ATENÇÃO: issuer não bate com $NEW_IP"

info "keycloak $NEW_IP:8081 -> $(curl -s -o /dev/null -m 10 -w '%{http_code}' "http://$NEW_IP:8081/realms/duma-realm")"
info "api      $NEW_IP:8080 -> $(curl -s -o /dev/null -m 10 -w '%{http_code}' "http://$NEW_IP:8080/actuator/health")"

for svc in adm ava; do
  stale=$(docker compose exec -T "$svc" sh -c "grep -rl '$CUR_IP' /app/.next/static 2>/dev/null | wc -l" 2>/dev/null | tr -d '\r' || echo '?')
  info "bundle $svc: $stale arquivo(s) ainda citando ${CUR_IP:-<n/a>}"
done

printf '\n\033[1;32m==> Pronto.\033[0m Faça logout/login — sessões antigas carregam o issuer velho.\n'
printf '    duma-mobile: reinicie o Expo para reler o .env.\n'
