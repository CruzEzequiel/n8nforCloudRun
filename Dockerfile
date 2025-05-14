FROM n8nio/n8n:latest

# Cloud Run escucha en el puerto 8080
ENV PORT=8080
EXPOSE 8080

CMD ["n8n"]
