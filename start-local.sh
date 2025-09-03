#!/bin/bash

echo "🚀 Iniciando Chatwoot Local..."

# Criar diretórios necessários
mkdir -p data/postgres data/redis data/storage

# Parar containers antigos se existirem
docker compose -f docker-compose.local.yml down

# Iniciar serviços
echo "📦 Iniciando PostgreSQL e Redis..."
docker compose -f docker-compose.local.yml up -d postgres redis

# Aguardar serviços estarem prontos
echo "⏳ Aguardando banco de dados..."
sleep 10

# Criar banco e rodar migrations
echo "🗄️ Preparando banco de dados..."
docker compose -f docker-compose.local.yml run --rm rails bundle exec rails db:prepare

# Iniciar aplicação
echo "🎯 Iniciando Chatwoot..."
docker compose -f docker-compose.local.yml up -d

echo ""
echo "✅ Chatwoot iniciado!"
echo "📍 Acesse: http://localhost:3000"
echo ""
echo "📝 Comandos úteis:"
echo "  Ver logs:        docker compose -f docker-compose.local.yml logs -f"
echo "  Parar tudo:      docker compose -f docker-compose.local.yml down"
echo "  Console Rails:   docker compose -f docker-compose.local.yml exec rails bundle exec rails console"
echo ""