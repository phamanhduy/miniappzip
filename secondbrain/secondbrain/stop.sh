#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

PORT="${PORT:-7777}"
if [ -f .env ]; then
  P=$(grep -E '^PORT=|^JAVIS_PORT=' .env | head -n 1 | cut -d '=' -f2 | tr -d '\r')
  [ -n "$P" ] && PORT="$P"
fi

echo "[Second Brain] Đang dừng tiến trình trên port $PORT và server/main.py..."

# Kill tiến trình python chạy server/main.py
pkill -9 -f 'server/main.py' 2>/dev/null || true
pkill -9 -f 'main:app' 2>/dev/null || true

# Kill theo port
if command -v fuser >/dev/null 2>&1; then
  fuser -k "${PORT}/tcp" 2>/dev/null || true
elif command -v lsof >/dev/null 2>&1; then
  lsof -ti:"${PORT}" | xargs -r kill -9 2>/dev/null || true
fi

echo "[Second Brain] Đã dừng hoàn tất."
exit 0

