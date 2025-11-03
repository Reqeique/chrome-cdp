# FROM zenika/alpine-chrome:with-node

# EXPOSE 9222

# CMD chromium-browser --headless \
#     --remote-debugging-address=0.0.0.0 \
#     --remote-debugging-port=9222 \
#     --no-sandbox \
#     --disable-dev-shm-usage \
#     --disable-gpu \
#     --disable-software-rasterizer \
#     --remote-allow-origins=* \
#     --allow-insecure-localhost \
#     --disable-web-security \
#     --disable-features=IsolateOrigins,site-per-process
FROM zenika/alpine-chrome:with-node

# Add nginx
RUN apk add --no-cache nginx && mkdir -p /run/nginx

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

# Start Chrome bound to localhost and run nginx in foreground
CMD sh -c '\
  chromium-browser \
    --headless \
    --remote-debugging-address=127.0.0.1 \
    --remote-debugging-port=9222 \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --remote-allow-origins=* \
    --allow-insecure-localhost & \
  nginx -g "daemon off;"'
