#!/bin/sh

# Iniciar n8n en segundo plano
n8n &

# Esperar a que levante
sleep 5

# Iniciar nginx en foreground
nginx -g "daemon off;"
