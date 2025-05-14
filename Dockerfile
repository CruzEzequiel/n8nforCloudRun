# Dockerfile para n8n
FROM n8nio/n8n:latest

# Establece el puerto que n8n escuchará
EXPOSE 5678

# Comando para iniciar n8n
CMD ["n8n"]
