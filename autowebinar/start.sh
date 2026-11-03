#!/usr/bin/env bash
# ==============================================================================
# AutoMeet Webinar - Linux Start Script
# ==============================================================================

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 1. Xác định PORT linh hoạt
TARGET_PORT="${1:-$PORT}"

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/app.json" ]; then
    TARGET_PORT=$(grep -o '"port": *[0-9]*' "$DIR/app.json" | head -n1 | tr -dc '0-9')
fi

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/.env" ]; then
    TARGET_PORT=$(grep -E '^PORT=' "$DIR/.env" | cut -d '=' -f2 | tr -d '\r" ' )
fi

export PORT="${TARGET_PORT:-3007}"
export NODE_ENV="${NODE_ENV:-production}"

echo "======================================================="
echo "  🚀 Starting AutoMeet Webinar on port $PORT..."
echo "  📡 Web App: http://localhost:$PORT"
echo "======================================================="

# 2. Dọn dẹp tiến trình chiếm cổng
if command -v fuser >/dev/null 2>&1; then
    fuser -k -9 "${PORT}/tcp" >/dev/null 2>&1 || true
fi
if command -v lsof >/dev/null 2>&1; then
    PORT_PIDS=$(lsof -ti tcp:"$PORT" 2>/dev/null || true)
    [ -n "$PORT_PIDS" ] && echo "$PORT_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
fi

# 3. Khởi chạy Node Server
echo $$ > "$DIR/autowebinar.pid"

if [ -f "$DIR/.env" ]; then
    exec node --env-file="$DIR/.env" dist/index.js
else
    exec node dist/index.js
fi

