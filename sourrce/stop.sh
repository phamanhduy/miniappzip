#!/usr/bin/env bash
# ==============================================================================
# ZaloCRM - Linux Stop Script (Dynamic Port & Full Cleanup)
# ==============================================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 1. Xác định PORT linh hoạt:
# Thứ tự ưu tiên:
#   1. Tham số dòng lệnh $1 (vd: bash stop.sh 3005)
#   2. Biến môi trường hệ thống $PORT
#   3. Khai báo port trong app.json (nếu có)
#   4. Khai báo PORT trong file .env

TARGET_PORT="${1:-$PORT}"

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/app.json" ]; then
    TARGET_PORT=$(grep -o '"port": *[0-9]*' "$DIR/app.json" | head -n1 | tr -dc '0-9')
fi

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/.env" ]; then
    TARGET_PORT=$(grep -E '^PORT=' "$DIR/.env" | cut -d '=' -f2 | tr -d '\r" ' )
fi

# 2. Tìm tất cả PID của tiến trình node đang chạy dist/index.js
SCRIPT_PIDS=$(pgrep -f "node.*dist/index.js" 2>/dev/null || true)

# Nếu chưa tìm được port, thử dò tự động từ socket mà PID đang lắng nghe
if [ -z "$TARGET_PORT" ] && [ -n "$SCRIPT_PIDS" ]; then
    for p in $SCRIPT_PIDS; do
        DETECTED=$(lsof -Pan -p "$p" -i 2>/dev/null | grep -i LISTEN | awk '{print $9}' | rev | cut -d':' -f1 | rev | head -n1)
        if [ -n "$DETECTED" ]; then
            TARGET_PORT="$DETECTED"
            break
        fi
    done
fi

TARGET_PORT="${TARGET_PORT:-3000}"
echo "Stopping ZaloCRM (Target Port: $TARGET_PORT)..."

# 3. Kill trực tiếp các PID của node dist/index.js
if [ -n "$SCRIPT_PIDS" ]; then
    echo "Terminating ZaloCRM process (PID: $SCRIPT_PIDS)..."
    echo "$SCRIPT_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
fi
pkill -9 -f "node.*dist/index.js" >/dev/null 2>&1 || true

# 4. Giải phóng triệt để cổng mạng
if [ -n "$TARGET_PORT" ]; then
    if command -v fuser >/dev/null 2>&1; then
        fuser -k -9 "${TARGET_PORT}/tcp" >/dev/null 2>&1 || true
    fi

    if command -v lsof >/dev/null 2>&1; then
        PORT_PIDS=$(lsof -ti tcp:"$TARGET_PORT" 2>/dev/null || true)
        if [ -n "$PORT_PIDS" ]; then
            echo "$PORT_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
        fi
    fi
fi

echo "ZaloCRM stopped successfully."
