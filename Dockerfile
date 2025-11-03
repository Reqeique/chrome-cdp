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

# Need root to install packages
USER root
RUN apk add --no-cache nginx && mkdir -p /run/nginx /var/log/nginx

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Small start script to launch both processes cleanly
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

# Keep root so nginx can start without permission issues.
# Chrome is started with --no-sandbox, so it can run as root.
CMD ["/start.sh"]
