# 🚀 Checklist de Deploy — Servidor de Produção

> Documento com todas as alterações necessárias ao mover o ambiente local para o servidor.

---

## 1. `.env` — Principal ponto de configuração

Arquivo: `duma-infra/.env`

| Variável | Valor local (dev) | Valor no servidor |
|---|---|---|
| `HOST_IP` | `192.168.1.105` | IP público ou domínio do servidor (ex: `1.2.3.4`) |
| `NEXT_PUBLIC_API_URL` | `http://${HOST_IP}:8080` | `https://adm.dumaway.com/api` (via nginx/proxy) |
| `NEXT_PUBLIC_KEYCLOAK_ISSUER` | `http://${HOST_IP}:8081/realms/duma-realm` | `https://auth.dumaway.com/realms/duma-realm` |
| `NEXTAUTH_URL` | `http://localhost:3012` | `https://adm.dumaway.com` |
| `KEYCLOAK_ISSUER` | `http://${HOST_IP}:8081/realms/duma-realm` | `https://auth.dumaway.com/realms/duma-realm` |
| `KEYCLOAK_ISSUER_INTERNAL` | `http://keycloak:8080/realms/duma-realm` | ✅ Manter igual (comunicação interna Docker) |
| `KEYCLOAK_CLIENT_SECRET` | `14KouZxVwvRcOTLe1vvw6HOiORdw0fLw` | 🔐 Gerar novo secret no Keycloak de produção |
| `NEXTAUTH_SECRET` | `minhasenhasupersecreta123` | 🔐 Gerar com `openssl rand -base64 32` |

---

## 2. `docker-compose.yml` — Serviços

### 2.1 — API (Spring Boot)

| Variável | Valor local | Valor no servidor |
|---|---|---|
| `SPRING_PROFILES_ACTIVE` | `docker` | ⚠️ Trocar para o perfil correto de produção (ex: `prod`) |
| `DUMA_JWT_ISSUER_URI` | `http://${HOST_IP}:8081/realms/duma-realm` | `https://auth.dumaway.com/realms/duma-realm` |
| `DUMA_JWT_JWK_SET_URI` | `http://keycloak:8080/realms/...` | ✅ Manter igual (interno) |
| Senhas do banco | `163duma` | 🔐 Trocar por senhas fortes |

### 2.2 — Keycloak

| Variável | Valor local | Valor no servidor |
|---|---|---|
| `KC_HOSTNAME` | `http://${HOST_IP}:8081` | `https://auth.dumaway.com` |
| `KC_BOOTSTRAP_ADMIN_PASSWORD` | `163duma` | 🔐 Trocar por senha forte |
| `command` | `start-dev --import-realm` | ⚠️ Trocar `start-dev` por `start` (modo produção) |

### 2.3 — ADM (Next.js)

Os valores são injetados via `build args` **em tempo de build**. Ao fazer o build no servidor, as variáveis do `.env` já substituem automaticamente. Verificar que o `.env` esteja correto antes do `docker compose up --build`.

### 2.4 — Banco de dados (PostgreSQL e MongoDB)

| Item | Ação |
|---|---|
| `POSTGRES_PASSWORD` | 🔐 Trocar `163duma` por senha forte |
| `MONGO_INITDB_ROOT_PASSWORD` | 🔐 Trocar `163duma` por senha forte |
| Ports expostas (`5433`, `27017`) | ⚠️ Remover ou restringir por firewall no servidor |

---

## 3. `duma-backend` — Código Java

### 3.1 — `DockerSecurityConfig.java`
**Arquivo:** `duma-backend/src/main/java/.../config/DockerSecurityConfig.java`

> ⚠️ **Esta classe desativa toda autenticação e libera CORS completamente.**
> Foi criada para uso local apenas.

**Ação no servidor:**
- Remover ou desativar esta classe
- Garantir que o `SPRING_PROFILES_ACTIVE` **não** inclua `docker`
- O `SecurityConfig.java` original (com JWT/Keycloak) deve estar ativo

### 3.2 — `SecurityConfig.java`
**Arquivo:** `duma-backend/src/main/java/.../config/SecurityConfig.java`

Verificar que a anotação seja:
```java
// Produção: ativa em qualquer perfil exceto dev e docker
@Profile("!(dev | docker)")
```

---

## 4. `keycloak/realm-export.json`

| Item | Ação |
|---|---|
| `redirectUris` do client `duma-adm` | Adicionar URLs de produção (`https://adm.dumaway.com/*`) |
| `webOrigins` do client `duma-adm` | Adicionar `https://adm.dumaway.com` |
| `postLogoutRedirectUris` | Adicionar `https://adm.dumaway.com` |
| URLs `localhost:3012` | ✅ Podem ser mantidas para acesso local ou removidas |

---

## 5. `nginx/` — Configuração do Proxy

| Arquivo | Uso |
|---|---|
| `nginx.simple.conf` | Usado atualmente (sem SSL) |
| `nginx.ssl.conf` | ⚠️ Usar este no servidor com certificados SSL |

**Ações:**
- Trocar o volume no `docker-compose.yml` de `nginx.simple.conf` para `nginx.ssl.conf`
- Colocar os certificados SSL em `nginx/ssl/`
- Ajustar `server_name` para os domínios reais

---

## 6. Senhas e Secrets — Resumo de Segurança

> 🔐 Todas as credenciais abaixo estão em texto plano no `.env` local. **Nunca commitar o `.env` de produção.**

| Item | Status |
|---|---|
| `POSTGRES_PASSWORD` / `MONGO_*_PASSWORD` | ⚠️ Trocar |
| `KEYCLOAK_ADMIN_PASSWORD` | ⚠️ Trocar |
| `KEYCLOAK_CLIENT_SECRET` | ⚠️ Regenerar no painel do Keycloak |
| `NEXTAUTH_SECRET` | ⚠️ Gerar novo com `openssl rand -base64 32` |
| `DEEPSEEK_API_KEY` | ⚠️ Inserir a chave real |

---

## 7. Ordem de execução no servidor

```bash
# 1. Editar o .env com os valores de produção
nano .env

# 2. Build e subida dos containers
sudo docker compose up -d --build

# 3. Verificar se o Keycloak importou o realm corretamente
sudo docker logs duma-infra-keycloak-1 | grep -i "import"

# 4. Importar dados do banco (se necessário)
# PostgreSQL:
sudo docker exec -i duma-infra-db-1 psql -U duma -d duma_db < duma_db_backup.sql
# MongoDB:
sudo docker cp seed_01_all.json duma-infra-mongodb-1:/tmp/
sudo docker exec duma-infra-mongodb-1 mongoimport -u duma -p <senha> \
  --authenticationDatabase admin --db duma_db \
  --collection exercises --file /tmp/seed_01_all.json --jsonArray
```

---

*Gerado em: 26/05/2026*
