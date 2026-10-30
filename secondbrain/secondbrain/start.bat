: << 'EOF'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$DIR/start.sh" "$@"
exit $?
EOF
@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

:: 1. Đọc file .env nếu có
if exist ".env" (
    for /f "usebackq eol=# tokens=1,* delims==" %%a in (".env") do (
        set "%%a=%%b"
    )
)

if "%PORT%"=="" set "PORT=7777"
if "%JAVIS_PORT%"=="" set "JAVIS_PORT=%PORT%"
if "%JAVIS_HOST%"=="" set "JAVIS_HOST=0.0.0.0"
if "%JAVIS_REQUIRE_LOGIN%"=="" set "JAVIS_REQUIRE_LOGIN=0"

:: 2. Tìm hoặc tạo môi trường Python ảo (.venv)
set "PYTHON_EXE="
if exist ".venv\Scripts\python.exe" (
    set "PYTHON_EXE=.venv\Scripts\python.exe"
) else (
    if exist "..\..\Environments\python\v3.11.9\python.exe" (
        set "BASE_PY=..\..\Environments\python\v3.11.9\python.exe"
    ) else if exist "..\..\Environments\python\3.11\python.exe" (
        set "BASE_PY=..\..\Environments\python\3.11\python.exe"
    ) else (
        set "BASE_PY=python"
    )
    
    echo [Second Brain] Đang khởi tạo môi trường Python ảo (.venv)...
    !BASE_PY! -m venv .venv
    if !errorlevel! neq 0 (
        echo [Second Brain] Thử tạo .venv bằng python hệ thống...
        python -m venv .venv
    )
    set "PYTHON_EXE=.venv\Scripts\python.exe"
)

:: 3. Kiểm tra và cài đặt dependencies nếu chưa có
if not exist ".venv\Scripts\uvicorn.exe" (
    echo [Second Brain] Đang cài đặt thư viện từ requirements.txt...
    "%PYTHON_EXE%" -m pip install --upgrade pip -q
    "%PYTHON_EXE%" -m pip install -r requirements.txt -q
)

:: 4. Giải phóng port cũ nếu đang bị chiếm
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%JAVIS_PORT% " ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo [Second Brain] Khởi động Second Brain (Javis OS) tại http://%JAVIS_HOST%:%JAVIS_PORT%...
"%PYTHON_EXE%" server\main.py

