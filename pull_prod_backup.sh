#!/usr/bin/env bash
#
# pull_prod_backup.sh
#
# Copia os dumps diarios gerados pelos CronJobs de producao (k8s/backup.yml) para
# esta maquina, em backups/prod/. Essa e a copia FORA do VPS: sem ela, backup e
# banco moram no mesmo disco e um unico incidente de hardware leva os dois.
#
# Como o PVC duma-backups usa o provisioner local-path, o volume e apenas um
# diretorio no disco do host -- da para copiar por rsync direto, sem passar por pod.
#
# Uso:
#   ./pull_prod_backup.sh            # sincroniza backups/prod/
#   ./pull_prod_backup.sh --list     # so lista o que existe em producao
#
set -euo pipefail
cd "$(dirname "$0")"

PROD_HOST="${PROD_HOST:-72.61.60.208}"
PROD_NS="${PROD_NS:-duma}"
PVC_NAME="${PVC_NAME:-duma-backups}"
DEST="backups/prod"

LIST_ONLY=0

log() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)    LIST_ONLY=1 ;;
    -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
    *)         die "opcao desconhecida: $1 (tente --help)" ;;
  esac
  shift
done

remote() { ssh -o BatchMode=yes -o ConnectTimeout=15 "$PROD_HOST" "$@"; }

log "Localizando o volume do PVC $PVC_NAME no host $PROD_HOST"
PV="$(remote "kubectl -n $PROD_NS get pvc $PVC_NAME -o jsonpath='{.spec.volumeName}'")"
[[ -n "$PV" ]] || die "PVC $PVC_NAME nao encontrado ou ainda Pending (nenhum Job rodou ate agora?)"

# O local-path-provisioner mudou de campo entre versoes: PVs antigos do cluster usam
# spec.hostPath, os criados pela versao atual usam spec.local (+ nodeAffinity). Aceita os dois.
SRC="$(remote "kubectl get pv $PV -o jsonpath='{.spec.local.path}{.spec.hostPath.path}'")"
[[ -n "$SRC" ]] || die "PV $PV nao expoe caminho local -- o provisioner deixou de ser local-path?"
log "Origem: $SRC"

if [[ $LIST_ONLY -eq 1 ]]; then
  remote "ls -lhR $SRC"
  exit 0
fi

mkdir -p "$DEST"

# Sem --delete de proposito: producao poda em 14 dias, mas a copia local mantem o
# historico mais longo -- e justamente o ponto de ter uma copia fora.
# --chmod=F600 porque sao dados reais de alunos.
log "Sincronizando -> $DEST/"
rsync -avz --chmod=F600 "$PROD_HOST:$SRC/" "$DEST/"

log "Backups locais mais recentes"
find "$DEST" -name '*.gz' -type f -printf '%TY-%Tm-%Td %TH:%TM  %10s  %p\n' 2>/dev/null \
  | sort -r | head -10

printf '\n\033[1;32m==> Pronto.\033[0m Total em %s: %s\n' "$DEST" "$(du -sh "$DEST" | cut -f1)"
