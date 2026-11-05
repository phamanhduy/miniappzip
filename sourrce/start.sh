#!/usr/bin/env bash
# ==============================================================================
# ZaloCRM - Linux Start Script (Dynamic Port & Native Addon Multi-ABI)
# ==============================================================================

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

export PORT="${TARGET_PORT:-3006}"
export NODE_ENV="${NODE_ENV:-production}"

# 2. Đồng bộ Native Addon SQLite tương thích với phiên bản Node trên hệ thống
# Node 20 (ABI 115) | Node 22 (ABI 127) | Node 24 (ABI 137)
mkdir -p "$DIR/dist/build/Release"
CURRENT_NODE="$DIR/dist/build/Release/better_sqlite3.node"
NODE_ABI=$(node -p "process.versions.modules" 2>/dev/null || echo "115")
PREBUILT_NODE="$DIR/dist/build/Release/better_sqlite3.linux-x64-v${NODE_ABI}.node"

if [ -f "$PREBUILT_NODE" ]; then
    echo "Applying prebuilt Linux SQLite addon for Node ABI v${NODE_ABI}..."
    cp -f "$PREBUILT_NODE" "$CURRENT_NODE"
else
    # Fallback tự tải nếu gặp phiên bản Node khác
    echo "Downloading Linux SQLite addon for Node ABI v${NODE_ABI}..."
    TMP_TGZ="/tmp/bsqlite_${NODE_ABI}.tar.gz"
    DL_VER="v12.11.1"
    if [ "$NODE_ABI" = "115" ]; then
        DL_VER="v12.9.1"
    fi
    if curl -fsSL "https://github.com/WiseLibs/better-sqlite3/releases/download/${DL_VER}/better-sqlite3-${DL_VER}-node-v${NODE_ABI}-linux-x64.tar.gz" -o "$TMP_TGZ" 2>/dev/null; then
        tar -xzf "$TMP_TGZ" -C "$DIR/dist" 2>/dev/null
        rm -f "$TMP_TGZ"
    fi
fi

# 3. Tạo thư mục uploads nếu chưa có
mkdir -p "$DIR/uploads"

echo "Starting ZaloCRM on port $PORT (Single Bundle Mode)..."

# 4. Khởi động Node với file .env
if [ -f "$DIR/.env" ]; then
    exec node --env-file="$DIR/.env" dist/index.js
else
    exec node dist/index.js
fi
