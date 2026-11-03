#!/usr/bin/env bash
# ==============================================================================
# AutoMeet Webinar - Linux Stop Script
# ==============================================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

TARGET_PORT="${1:-$PORT}"

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/app.json" ]; then
    TARGET_PORT=$(grep -o '"port": *[0-9]*' "$DIR/app.json" | head -n1 | tr -dc '0-9')
fi

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/.env" ]; then
    TARGET_PORT=$(grep -E '^PORT=' "$DIR/.env" | cut -d '=' -f2 | tr -d '\r" ' )
fi

TARGET_PORT="${TARGET_PORT:-3007}"

echo "======================================================="
echo "   Stopping AutoMeet Webinar on port $TARGET_PORT..."
echo "======================================================="

# 1. Dừng theo PID file
if [ -f "$DIR/autowebinar.pid" ]; then
    PID=$(cat "$DIR/autowebinar.pid" 2>/dev/null || true)
    [ -n "$PID" ] && kill -9 "$PID" >/dev/null 2>&1 || true
    rm -f "$DIR/autowebinar.pid" >/dev/null 2>&1 || true
fi

# 2. Dừng theo tiến trình node và thư mục
pkill -9 -f "node.*${DIR}/dist/index\.js" 2>/dev/null || true
pkill -9 -f "${DIR}/dist" 2>/dev/null || true

# 3. Giải phóng cổng mạng
if command -v fuser >/dev/null 2>&1; then
    fuser -k -9 "${TARGET_PORT}/tcp" >/dev/null 2>&1 || true
fi

if command -v lsof >/dev/null 2>&1; then
    PORT_PIDS=$(lsof -ti tcp:"$TARGET_PORT" 2>/dev/null || true)
    if [ -n "$PORT_PIDS" ]; then
        echo "$PORT_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
    fi
fi

if command -v ss >/dev/null 2>&1; then
    SS_PIDS=$(ss -lptn "sport = :${TARGET_PORT}" 2>/dev/null | grep -oP 'pid=\K[0-9]+' || true)
    if [ -n "$SS_PIDS" ]; then
        echo "$SS_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
    fi
fi

echo "AutoMeet Webinar stopped successfully."
