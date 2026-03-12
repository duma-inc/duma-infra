# 🌐 Configurações do Nginx

Este diretório contém as configurações do Nginx para o projeto DUMA.

# 🌐 Configurações do Nginx - DUMA EdTech

## 🏫 Sobre o DUMA

DUMA é uma **EdTech AI-First** que unifica o melhor do aprendizado tradicional com tecnologia de ponta.

### 🎯 Modelo de Aprendizagem
- 👥 **Encontros ao vivo em grupo** — aulas práticas com turmas reais
- 🤖 **IA centralizada** — criação de exercícios, correção, tutoria e análise de progresso
- 🧑‍🏫 **Mentores humanos** — motivação e dúvidas complexas
- 🎮 **Gamificação** — engajamento e progressão motivadora
- 📹 **Cursos pré-gravados** — conteúdo assíncrono de qualidade
- 📊 **Acompanhamento intensivo** — humano + IA

### 📚 Habilidades Suportadas
- 🌍 Idiomas (Inglês, etc.)
- ♟️ Jogos de estratégia e lógica (Xadrez, etc.)
- 🎵 Música (Violão, Guitarra, etc.)
- 💻 Tecnologia (Python, Fullstack, etc.)
- 📐 Matérias escolares (Matemática, etc.)
- 📖 Concursos e vestibulares (Direito, História, Economia, etc.)

### 🧠 Método de Aprendizagem
Baseado nos métodos **Kumon** e **Duolingo**:
- ✅ Elevação gradual de nível
- ✅ Repetição espaçada
- ✅ Personalização contínua por análise de IA
- ✅ Trilhas adaptativas por habilidade

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────┐
│                     NGINX                           │
│              (Proxy Reverso / Gateway)              │
└──────────┬──────────────┬──────────────┬────────────┘
           │              │              │
    ┌──────▼──────┐ ┌─────▼─────┐ ┌────▼────────┐
    │  duma-api   │ │ duma-ava  │ │  duma-adm   │
    │ Spring Boot │ │  Next.js  │ │   Next.js   │
    │  :8080      │ │  :3001    │ │   :3002     │
    └──────┬──────┘ └─────┬─────┘ └────┬────────┘
           │              │              │
    ┌──────▼──────────────▼──────────────▼────────┐
    │              Microsserviço IA                │
    │           (JS/Python - Agentes)              │
    └──────┬──────────────────────────────────────┘
           │
    ┌──────▼────────────────────────────┐
    │         Infraestrutura            │
    │  PostgreSQL │ MongoDB │ Redis     │
    │  (relacional)│(trilhas)│(cache)   │
    │             RabbitMQ              │
    │          (mensageria)             │
    └───────────────────────────────────┘
```

### 📦 Serviços
| Serviço | Tecnologia | Responsabilidade |
|---------|-----------|-----------------|
| **duma-api** | Spring Boot (Java 21) | Backend principal, regras de negócio |
| **duma-ava** | Next.js (React) | Frontend do aprendiz |
| **duma-adm** | Next.js (React) | Frontend de gestão e acompanhamento |
| **duma-ai** | JS/Python | Microsserviço de agentes de IA |
| **PostgreSQL** | postgres:16 | Dados relacionais (usuários, turmas, matrículas...) |
| **MongoDB** | mongo:7 | Exercícios, trilhas e conteúdo adaptativo |
| **Redis** | redis:7 | Cache, sessões, filas rápidas |
| **RabbitMQ** | rabbitmq:3 | Mensageria assíncrona entre serviços |
| **Nginx** | nginx:alpine | Proxy reverso e gateway |

---

## 📁 Arquivos de Configuração Nginx

### 1. `nginx.conf` (Padrão - Múltiplos Serviços)
**Rotas configuradas:**
- `http://localhost/api/*` → API Backend (porta 8080)
- `http://localhost/ava/*` → Serviço AVA (porta 3001)
- `http://localhost/adm/*` → Admin Panel (porta 3002)
- `http://localhost/health` → Health Check

**Exemplo de uso:**
```bash
curl http://localhost/api/users
curl http://localhost/ava/dashboard
curl http://localhost/adm/settings
```

### 2. `nginx.simple.conf` (Simples - API Direta)
**Configuração mais simples onde:**
- `http://localhost/*` → API Backend diretamente

**Exemplo de uso:**
```bash
curl http://localhost/users
curl http://localhost/health
```

### 3. `nginx.ssl.conf` (HTTPS/SSL)
**Para produção com certificados SSL:**
- Redireciona HTTP → HTTPS automaticamente
- Suporta TLS 1.2 e 1.3
- HSTS habilitado

## 🔄 Como Trocar de Configuração

### Opção 1: Editar `docker-compose.yml`

```yaml
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
  volumes:
    # Escolha qual configuração usar:
    - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf          # Padrão
    # - ./nginx/nginx.simple.conf:/etc/nginx/conf.d/default.conf  # Simples
    # - ./nginx/nginx.ssl.conf:/etc/nginx/conf.d/default.conf     # SSL
```

### Opção 2: Renomear arquivo

```bash
# Backup do atual
cp nginx.conf nginx.conf.backup

# Usar a versão simples
cp nginx.simple.conf nginx.conf

# Reiniciar o Nginx
docker-compose restart nginx
```

## 🧪 Testar Configuração

```bash
# Testar sintaxe antes de aplicar
docker-compose exec nginx nginx -t

# Ver logs do Nginx
docker-compose logs -f nginx

# Recarregar configuração sem parar
docker-compose exec nginx nginx -s reload
```

## 📊 Rotas Explicadas

### `/api/*`
Todas as requisições para `/api/*` são redirecionadas para o backend.

**Exemplo:**
```
Cliente: GET http://localhost/api/users
Nginx:   GET http://api:8000/users
```

### WebSocket Support
Todas as rotas suportam WebSocket automaticamente através dos headers:
```nginx
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

## 🔒 Configuração SSL (Produção)

Para usar HTTPS:

1. **Gerar certificados** (Let's Encrypt recomendado):
```bash
# Criar diretório para certificados
mkdir -p nginx/ssl

# Gerar certificado auto-assinado (apenas para desenvolvimento)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem
```

2. **Atualizar docker-compose.yml**:
```yaml
nginx:
  volumes:
    - ./nginx/nginx.ssl.conf:/etc/nginx/conf.d/default.conf
    - ./nginx/ssl:/etc/nginx/ssl
  ports:
    - "80:80"
    - "443:443"
```

## 🚀 Performance

A configuração inclui:
- ✅ HTTP/2 habilitado
- ✅ Gzip compression
- ✅ Buffer otimizado
- ✅ Timeouts configurados
- ✅ Client max body size: 100MB

## 📝 Personalização

### Aumentar tamanho de upload
```nginx
client_max_body_size 500M;  # Altere de 100M para o desejado
```

### Adicionar CORS
```nginx
location /api/ {
    # ... configurações existentes ...
    
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type';
}
```

### Cache de arquivos estáticos
```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```

## 🐛 Troubleshooting

### Erro 502 Bad Gateway
```bash
# Verificar se os serviços estão rodando
docker-compose ps

# Verificar logs da API
docker-compose logs api

# Verificar logs do Nginx
docker-compose logs nginx
```

### Erro 404 Not Found
```bash
# Verificar se a rota está correta
docker-compose exec nginx cat /etc/nginx/conf.d/default.conf

# Testar configuração
docker-compose exec nginx nginx -t
```

## 📚 Recursos

- [Documentação Oficial do Nginx](https://nginx.org/en/docs/)
- [Nginx Proxy Pass](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [Let's Encrypt](https://letsencrypt.org/)
