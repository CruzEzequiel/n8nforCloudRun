#!/bin/bash

set -e

# Cargar variables desde .env si existe
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Archivo .env no encontrado. Abortando..."
  exit 1
fi

# Eliminar contenedor anterior si existe
if docker ps -a --format '{{.Names}}' | grep -Eq '^n8n$'; then
  echo "Eliminando contenedor anterior de n8n..."
  docker rm -f n8n
fi

# Eliminar imagen previa si existe
if docker images | grep -Eq '^n8n\s'; then
  echo "Eliminando imagen previa de n8n..."
  docker rmi -f n8n
fi

# Construir nueva imagen con NGINX + n8n
echo "Construyendo nueva imagen local de n8n (con NGINX)..."
docker build -t n8n .

# Ejecutar el contenedor en background (puerto 8080)
docker run -d \
  --name n8n \
  -p 8080:8080 \
  -e N8N_PORT=5678 \
  -e N8N_HOST=0.0.0.0 \
  -e DB_TYPE="$DB_TYPE" \
  -e DB_POSTGRESDB_HOST="$DB_POSTGRESDB_HOST" \
  -e DB_POSTGRESDB_PORT="$DB_POSTGRESDB_PORT" \
  -e DB_POSTGRESDB_DATABASE="$DB_POSTGRESDB_DATABASE" \
  -e DB_POSTGRESDB_USER="$DB_POSTGRESDB_USER" \
  -e DB_POSTGRESDB_PASSWORD="$DB_POSTGRESDB_PASSWORD" \
  -e N8N_RUNNERS_ENABLED="$N8N_RUNNERS_ENABLED" \
  n8n

echo "Mostrando logs..."
echo "Presiona Ctrl+C para salir"
docker logs -f n8n
