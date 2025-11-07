#!/bin/sh
set -e

# Start Chrome bound to localhost so only the proxy can reach it
chromium-browser \
  --headless \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port=9222 \
  --no-sandbox \
  # --disable-dev-shm-usage \
  --disable-gpu \
  # --disable-software-rasterizer \
  # --remote-allow-origins=* \
  # --allow-insecure-localhost \
  # --disable-web-security \
  # --disable-features=IsolateOrigins,site-per-process &

# Run nginx in foreground
exec nginx -g "daemon off;"
