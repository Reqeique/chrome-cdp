FROM zenika/alpine-chrome:with-node

EXPOSE 9222

CMD chromium-browser --headless --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --no-sandbox --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer --remote-allow-origins=* --allow-insecure-localhost
