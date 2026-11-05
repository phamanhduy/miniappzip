#!/bin/sh
set -e
mkdir -p /app/uploads
if [ -f /app/.env ]; then
  echo "ðŸš€ [ZaloCRM Docker] Äang khá»Ÿi Ä‘á»™ng há»‡ thá»‘ng vá»›i file .env..."
  exec node --env-file=/app/.env dist/index.js
else
  echo "ðŸš€ [ZaloCRM Docker] Äang khá»Ÿi Ä‘á»™ng há»‡ thá»‘ng vá»›i biáº¿n mÃ´i trÆ°á»ng..."
  exec node dist/index.js
fi