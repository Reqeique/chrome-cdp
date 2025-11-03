#!/bin/sh
set -e

# Default PORT for local testing; Render will provide a numeric $PORT at runtime.
: "${PORT:=8080}"

# Write nginx config with the correct PORT substituted.
# Note: we escape $http_upgrade and $connection_upgrade so the shell doesn't expand them.
cat > /etc/nginx/nginx.conf <<EOF
events {}

http {
  access_log /dev/stdout;
  error_log /dev/stderr info;

  map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
  }

  server {
    # listen on the port Render provides (all interfaces)
    listen ${PORT};

    location / {
      proxy_pass http://127.0.0.1:9222;
      proxy_http_version 1.1;

      # keep Host as 127.0.0.1 to bypass Chrome DNS-rebind protection
      proxy_set_header Host 127.0.0.1;

      # websocket upgrade support
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection \$connection_upgrade;

      proxy_set_header X-Forwarded-For \$remote_addr;
      proxy_read_timeout 3600;
      proxy_send_timeout 3600;
      proxy_buffering off;
    }
  }
}
EOF

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

# Start nginx in foreground
exec nginx -g "daemon off;"
