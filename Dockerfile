FROM node:18-alpine

# Crear carpeta de trabajo
WORKDIR /app

# Instalar dependencias: nginx, python3 y n8n
RUN apk add --no-cache \
    nginx \
    bash \
    curl \
    python3 \
    && npm install -g n8n

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Variables para n8n
ENV N8N_PORT=5678
ENV PORT=8080

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
