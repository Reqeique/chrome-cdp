#!/bin/sh
set -e

# Ensure PORT default for local testing
: "${PORT:=8080}"

# If template doesn't exist in /etc/nginx, copy from repo or fail
if [ -f /etc/nginx/nginx.conf.template ]; then
  envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
else
  # If template wasn't copied to image (safety fallback), create it from here-doc and envsubst
  cat > /tmp/nginx.conf.template <<'EOF'
events {}

http {
  access_log /dev/stdout;
  error_log /dev/stderr info;

  map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
  }

  server {
    listen ${PORT:-8080};

    location / {
      proxy_pass http://127.0.0.1:9222;
      proxy_http_version 1.1;
      proxy_set_header Host 127.0.0.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_read_timeout 3600;
      proxy_send_timeout 3600;
      proxy_buffering off;
    }
  }
}
EOF
  envsubst '$PORT' < /tmp/nginx.conf.template > /etc/nginx/nginx.conf
fi

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
