# Kubernetes — duma-infra

Manifests de infraestrutura transversal do namespace `duma` em produção (k3s no VPS
`72.61.60.208`). Manifests específicos de uma aplicação ficam em `<repo>/k8s/`.

## Backup diário dos bancos

`backup.yml` cria três recursos:

| Recurso | O quê |
|---|---|
| PVC `duma-backups` (2Gi) | Onde os dumps ficam, dentro do cluster |
| CronJob `duma-backup-postgres` | `pg_dump` do `duma_db` — **03:00** (America/Sao_Paulo) |
| CronJob `duma-backup-mongo` | `mongodump` do `duma_db` — **03:15** (America/Sao_Paulo) |

Retenção de **14 dias** em cada CronJob (env `RETENTION_DAYS`). Os arquivos ficam em:

```
/backups/postgres/duma_db-AAAAMMDD-HHMMSS.sql.gz      + symlink latest.sql.gz
/backups/mongo/duma_db-AAAAMMDD-HHMMSS.archive.gz     + symlink latest.archive.gz
```

Um dump só recebe o nome definitivo depois de validado (o do Postgres tem que conter o
marcador `PostgreSQL database dump complete`; o do Mongo tem que ser não-vazio). Até lá
ele se chama `.duma_db-*` — assim um dump truncado nunca é confundido com um bom.

### Aplicar

```bash
ssh 72.61.60.208 "kubectl -n duma apply -f -" < k8s/backup.yml
ssh 72.61.60.208 "kubectl -n duma get cronjob,pvc"
```

O PVC fica `Pending` até o primeiro Job rodar — é o comportamento normal do
`local-path` (`volumeBindingMode: WaitForFirstConsumer`), não um erro.

### Verificar / rodar sob demanda

```bash
# estado dos agendamentos
ssh 72.61.60.208 "kubectl -n duma get cronjob"

# disparar agora, sem esperar as 3h
ssh 72.61.60.208 "kubectl -n duma create job --from=cronjob/duma-backup-postgres bkp-manual-pg"
ssh 72.61.60.208 "kubectl -n duma logs job/bkp-manual-pg"
ssh 72.61.60.208 "kubectl -n duma delete job bkp-manual-pg"
```

### Copiar para fora do VPS

Os CronJobs gravam no disco do próprio VPS. Para ter cópia fora dele:

```bash
./pull_prod_backup.sh          # rsync -> duma-infra/backups/prod/
./pull_prod_backup.sh --list   # só lista o que existe em produção
```

O script não apaga nada localmente: produção poda em 14 dias, a cópia local acumula
histórico maior. `backups/` já está no `.gitignore`.

## Restore

Deliberadamente **não há script de restore de produção** — é uma operação destrutiva e
merece ser digitada com consciência, comando a comando.

### 0. Antes de qualquer coisa

Tire um dump do estado atual (mesmo quebrado, ele pode conter dados que o backup não tem)
e derrube o backend, que segura conexões e cache de schema:

```bash
ssh 72.61.60.208 "kubectl -n duma create job --from=cronjob/duma-backup-postgres bkp-pre-restore"
ssh 72.61.60.208 "kubectl -n duma scale deploy/duma-backend --replicas=0"
```

### Postgres

```bash
# 1. escolher o dump e baixá-lo
./pull_prod_backup.sh --list      # ver o que existe em produção
./pull_prod_backup.sh             # trazer tudo para backups/prod/

# 2. limpar o schema e replay do dump (a partir de uma cópia local já baixada)
ssh 72.61.60.208 "kubectl -n duma exec -i deploy/duma-db -- psql -U duma -d duma_db -c \
  'DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO duma;'"

gunzip -c backups/prod/postgres/duma_db-AAAAMMDD-HHMMSS.sql.gz \
  | ssh 72.61.60.208 "kubectl -n duma exec -i deploy/duma-db -- psql -U duma -d duma_db"

# 3. conferir
ssh 72.61.60.208 "kubectl -n duma exec deploy/duma-db -- psql -U duma -d duma_db -c \
  'SELECT max(version::int) AS flyway_head FROM flyway_schema_history WHERE success;'"
```

Se o dump for mais antigo que o schema atual, rode o Job de migrations depois:
`kubectl -n duma apply -f ../duma-backend/k8s/flyway-migrate-job.yml`.

### Mongo

```bash
PW=$(ssh 72.61.60.208 "kubectl -n duma get secret duma-infra-secrets -o jsonpath='{.data.MONGO_PASSWORD}'" | base64 -d)

cat backups/prod/mongo/duma_db-AAAAMMDD-HHMMSS.archive.gz \
  | ssh 72.61.60.208 "kubectl -n duma exec -i deploy/duma-mongodb -- \
      mongorestore -u duma -p '$PW' --authenticationDatabase admin \
      --gzip --archive --drop --nsInclude 'duma_db.*'"
```

`--drop` remove cada coleção antes de recriá-la; sem isso o restore **mescla** com o que
já está lá, em vez de substituir.

### 4. Voltar o backend

```bash
ssh 72.61.60.208 "kubectl -n duma scale deploy/duma-backend --replicas=1"
ssh 72.61.60.208 "kubectl -n duma rollout status deploy/duma-backend"
```

## Camadas de proteção

| Camada | Frequência | Retenção | Granularidade |
|---|---|---|---|
| CronJobs deste arquivo | diária | 14 dias | por banco, restore em minutos |
| `pull_prod_backup.sh` | quando você roda | indefinida | idem, fora do VPS |
| Snapshot de VM da Hostinger | semanal | 2 | máquina inteira, rollback ~85 min |
