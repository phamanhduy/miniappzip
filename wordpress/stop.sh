#!/usr/bin/env bash
# ==============================================================================
# Portable WordPress - Linux Stop Script
# Dừng an toàn toàn bộ tiến trình WordPress và giải phóng cổng
# ==============================================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 1. Xác định cổng mục tiêu
TARGET_PORT="${1:-$PORT}"

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/app.json" ]; then
    TARGET_PORT=$(grep -o '"port": *[0-9]*' "$DIR/app.json" | head -n1 | tr -dc '0-9')
fi

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/.env" ]; then
    TARGET_PORT=$(grep -E '^PORT=' "$DIR/.env" | cut -d '=' -f2 | tr -d '\r" ' )
fi

TARGET_PORT="${TARGET_PORT:-3003}"

echo "======================================================="
echo "   ĐANG DỪNG CÁC TIẾN TRÌNH WORDPRESS (Cổng $TARGET_PORT)..."
echo "======================================================="

# 2. Dừng theo PID file nếu có
if [ -f "$DIR/wordpress.pid" ]; then
    PID=$(cat "$DIR/wordpress.pid" 2>/dev/null || true)
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        kill -9 "$PID" >/dev/null 2>&1 || true
    fi
    rm -f "$DIR/wordpress.pid" >/dev/null 2>&1 || true
fi

# 3. Dừng các tiến trình WordPress liên quan
pkill -9 -f "php.*router\.php" 2>/dev/null || true
pkill -9 -f "php.*0\.0\.0\.0:${TARGET_PORT}" 2>/dev/null || true
pkill -9 -f "${DIR}/www" 2>/dev/null || true

# 4. Giải phóng cổng bắt buộc
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

echo "Đã dừng toàn bộ dịch vụ WordPress thành công."
