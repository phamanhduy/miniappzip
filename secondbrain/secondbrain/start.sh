#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# 1. Doc file .env neu co
if [ -f .env ]; then
  set -a
  source .env 2>/dev/null || while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.* ]] && continue
    [ -z "$key" ] && continue
    export "$key=$value"
  done < .env
  set +a
fi

# 2. Thiet lap thong so mac dinh
export PORT="${PORT:-7777}"
export JAVIS_PORT="${JAVIS_PORT:-$PORT}"
export JAVIS_HOST="${JAVIS_HOST:-0.0.0.0}"
export JAVIS_REQUIRE_LOGIN="${JAVIS_REQUIRE_LOGIN:-0}"

# 3. Kiem tra Python tren may
PYTHON_BIN=""
if [ -f "./.venv/bin/python" ]; then
  PYTHON_BIN="./.venv/bin/python"
elif [ -f "../../Environments/python/v3.11.9/bin/python3" ]; then
  PYTHON_BIN="../../Environments/python/v3.11.9/bin/python3"
elif [ -f "../../Environments/python/3.11/bin/python3" ]; then
  PYTHON_BIN="../../Environments/python/3.11/bin/python3"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
fi

if [ -z "$PYTHON_BIN" ]; then
  echo "[Second Brain] Lỗi: Không tìm thấy Python 3 trên hệ thống!" >&2
  exit 1
fi

# 4. Khoi tao .venv neu chua co
if [ ! -d ".venv" ] || [ ! -f "./.venv/bin/python" ]; then
  echo "[Second Brain] Đang khởi tạo môi trường Python ảo (.venv)..."
  "$PYTHON_BIN" -m venv .venv
fi

# 5. Kiem tra va cai dat dependencies tu requirements.txt
if [ ! -f "./.venv/bin/uvicorn" ]; then
  echo "[Second Brain] Đang cài đặt thư viện phụ thuộc từ requirements.txt..."
  ./.venv/bin/pip install --upgrade pip -q
  ./.venv/bin/pip install -r requirements.txt -q
fi

# 6. Giai phong port neu dang bi chiem
if command -v fuser >/dev/null 2>&1; then
  fuser -k "${JAVIS_PORT}/tcp" 2>/dev/null || true
fi

echo "[Second Brain] Khởi động Second Brain (Javis OS) tại http://${JAVIS_HOST}:${JAVIS_PORT}..."
exec ./.venv/bin/python server/main.py

