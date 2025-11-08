FROM mcr.microsoft.com/playwright:focal

# Install nginx if you still want proxying (optional)
USER root
RUN apt-get update && apt-get install -y nginx && \
    mkdir -p /run/nginx /var/log/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080 9222

CMD ["/start.sh"]
