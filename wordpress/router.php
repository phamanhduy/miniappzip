<?php
/**
 * WordPress Built-in Server Router
 * Hỗ trợ định tuyến WordPress Permalinks, REST API và phục vụ Static Assets
 */

$root = __DIR__ . '/www';
$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$filePath = realpath($root . $requestUri);

// 1. Phục vụ file tĩnh trực tiếp nếu tồn tại và nằm trong thư mục www
if ($filePath && is_file($filePath) && strpos($filePath, realpath($root)) === 0) {
    return false;
}

// 2. Chuyển hướng các yêu cầu động về index.php của WordPress
$_SERVER['SCRIPT_NAME'] = '/index.php';
$_SERVER['SCRIPT_FILENAME'] = $root . '/index.php';
chdir($root);

require $root . '/index.php';
