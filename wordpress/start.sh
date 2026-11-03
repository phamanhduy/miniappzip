#!/usr/bin/env bash
# ==============================================================================
# Portable WordPress - Linux Start Script
# Tự động nhận diện cấu hình, chuẩn bị database và khởi chạy WordPress
# ==============================================================================

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 1. Xác định PORT linh hoạt (ưu tiên tham số truyền vào -> app.json -> .env -> mặc định 3003)
TARGET_PORT="${1:-$PORT}"

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/app.json" ]; then
    TARGET_PORT=$(grep -o '"port": *[0-9]*' "$DIR/app.json" | head -n1 | tr -dc '0-9')
fi

if [ -z "$TARGET_PORT" ] && [ -f "$DIR/.env" ]; then
    TARGET_PORT=$(grep -E '^PORT=' "$DIR/.env" | cut -d '=' -f2 | tr -d '\r" ' )
fi

export PORT="${TARGET_PORT:-3003}"

# 2. Đọc biến môi trường từ .env
if [ -f "$DIR/.env" ]; then
    set -a
    source "$DIR/.env" 2>/dev/null || true
    set +a
fi

DB_NAME="${DB_NAME:-wordpress}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_HOST="${DB_HOST:-127.0.0.1}"

echo "======================================================="
echo "   ĐANG KHỞI ĐỘNG WORDPRESS TRÊN LINUX"
echo "======================================================="
echo "Thư mục gốc  : $DIR"
echo "Cổng dịch vụ : $PORT"
echo "Database     : $DB_NAME ($DB_USER@$DB_HOST)"
echo "======================================================="

# 3. Dọn dẹp tiến trình cũ chiếm cổng
if command -v fuser >/dev/null 2>&1; then
    fuser -k -9 "${PORT}/tcp" >/dev/null 2>&1 || true
fi
if command -v lsof >/dev/null 2>&1; then
    PORT_PIDS=$(lsof -ti tcp:"$PORT" 2>/dev/null || true)
    [ -n "$PORT_PIDS" ] && echo "$PORT_PIDS" | xargs kill -9 >/dev/null 2>&1 || true
fi

# 4. Kiểm tra mã nguồn WordPress (thư mục www)
mkdir -p "$DIR/www"
if [ ! -f "$DIR/www/index.php" ] && [ ! -f "$DIR/www/wp-config-sample.php" ]; then
    echo "[INFO] Đang tải mã nguồn WordPress bản mới nhất..."
    WP_TMP="/tmp/wordpress_latest_$$.tar.gz"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "https://wordpress.org/latest.tar.gz" -o "$WP_TMP"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "https://wordpress.org/latest.tar.gz" -O "$WP_TMP"
    fi

    if [ -f "$WP_TMP" ]; then
        echo "[INFO] Đang giải nén WordPress vào thư mục www..."
        tar -xzf "$WP_TMP" -C "$DIR/www" --strip-components=1
        rm -f "$WP_TMP"
    fi
fi

# 5. Tự động cấu hình wp-config.php nếu chưa có
WP_CONFIG="$DIR/www/wp-config.php"
WP_SAMPLE="$DIR/www/wp-config-sample.php"

if [ -f "$WP_SAMPLE" ] && [ ! -f "$WP_CONFIG" ]; then
    echo "[INFO] Đang tự động cấu hình wp-config.php..."
    cp "$WP_SAMPLE" "$WP_CONFIG"
    sed -i "s/database_name_here/$DB_NAME/g" "$WP_CONFIG"
    sed -i "s/username_here/$DB_USER/g" "$WP_CONFIG"
    sed -i "s/password_here/$DB_PASS/g" "$WP_CONFIG"
    sed -i "s/localhost/$DB_HOST/g" "$WP_CONFIG"

    # Cho phép cài plugin và cập nhật giao diện trực tiếp không cần tài khoản FTP
    if ! grep -q "FS_METHOD" "$WP_CONFIG"; then
        sed -i "/<?php/a define('FS_METHOD', 'direct');" "$WP_CONFIG"
    fi
fi

# 6. Khởi tạo Database nếu MySQL khả dụng
if command -v mysql >/dev/null 2>&1; then
    PASS_ARG=""
    [ -n "$DB_PASS" ] && PASS_ARG="-p$DB_PASS"
    mysql -h "$DB_HOST" -u "$DB_USER" $PASS_ARG -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >/dev/null 2>&1 || true
fi

# 7. Khởi chạy Web Server
echo "[INFO] Khởi động WordPress Web Server trên cổng $PORT..."

# Lưu PID phục vụ script dừng
echo $$ > "$DIR/wordpress.pid"

if command -v php >/dev/null 2>&1; then
    exec php \
        -d upload_max_filesize=128M \
        -d post_max_size=128M \
        -d memory_limit=512M \
        -d max_execution_time=300 \
        -S "0.0.0.0:$PORT" \
        -t "$DIR/www" \
        "$DIR/router.php"
else
    echo "[LỖI] Chưa cài đặt PHP CLI trên Linux. Vui lòng chạy lệnh: apt-get install -y php-cli php-mysql php-curl php-mbstring php-gd php-zip"
    exit 1
fi
