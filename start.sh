#!/bin/sh
set -e

# Ensure PORT default for local testing
: "${PORT:=8080}"

# Render requires the app listen on $PORT; create nginx.conf from template
envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start Chrome bound to localhost so only the proxy can reach it
chromium-browser \
  --headless \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port=9222 \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
  --remote-allow-origins=* \
  --allow-insecure-localhost &

# Run nginx in foreground
exec nginx -g "daemon off;"
