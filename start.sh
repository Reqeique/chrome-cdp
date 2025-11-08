#!/bin/sh
set -e

# Start Chrome bound to localhost so only the proxy can reach it
chromium-browser \
  --headless=new \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port=9222 \
  --no-sandbox \
  --remote-allow-origins=* \
  --allow-insecure-localhost &

# Run nginx in foreground
exec nginx -g "daemon off;"
