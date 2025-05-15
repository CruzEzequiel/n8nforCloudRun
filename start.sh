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

# Ejecutar el contenedor con red host (para acceder a PostgreSQL local)
docker run -d \
  --name n8n \
  --network="host" \
  -e DB_TYPE="$DB_TYPE" \
  -e DB_POSTGRESDB_HOST="$DB_POSTGRESDB_HOST" \
  -e DB_POSTGRESDB_PORT="$DB_POSTGRESDB_PORT" \
  -e DB_POSTGRESDB_DATABASE="$DB_POSTGRESDB_DATABASE" \
  -e DB_POSTGRESDB_USER="$DB_POSTGRESDB_USER" \
  -e DB_POSTGRESDB_PASSWORD="$DB_POSTGRESDB_PASSWORD" \
  -e N8N_RUNNERS_ENABLED="$N8N_RUNNERS_ENABLED" \
  n8nio/n8n

echo "Mostrando logs..."
echo "Presiona Ctrl+C para salir"

# Mostrar logs en tiempo real
docker logs -f n8n
