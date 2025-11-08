#!/bin/sh
set -e

# Launch Chromium headless with remote debugging (CDP) exposed
node - <<'EOF' 
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    headless: 'new',              // modern headless mode
    args: [
      '--remote-debugging-address=0.0.0.0', // listen on all interfaces
      '--remote-debugging-port=9222',
      '--no-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--allow-insecure-localhost',
      '--disable-background-timer-throttling'
    ]
  });

  console.log('Chromium launched with CDP on port 9222');

  // Keep the browser alive
  await new Promise(() => {}); // infinite wait
})();
EOF

# Run nginx in foreground if needed
exec nginx -g "daemon off;"
