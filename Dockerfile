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

USER root
RUN apk add --no-cache nginx bash gettext && mkdir -p /run/nginx /var/log/nginx

# Copy template and start script
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
