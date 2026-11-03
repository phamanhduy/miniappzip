@echo off
setlocal enabledelayedexpansion
title AutoMeet Webinar (Port 3007)

SET NODE_ENV=production

:: 1. Xác định PORT linh hoạt: %1 -> %PORT% -> app.json -> .env -> mặc định 3007
set TARGET_PORT=%1
if "%TARGET_PORT%"=="" (
    set TARGET_PORT=%PORT%
)
if "%TARGET_PORT%"=="" (
    if exist "%~dp0app.json" (
        for /f "tokens=2 delims=:, " %%a in ('findstr /r "\"port\"" "%~dp0app.json"') do (
            set TARGET_PORT=%%a
        )
    )
)
if "%TARGET_PORT%"=="" (
    if exist "%~dp0.env" (
        for /f "tokens=1,2 delims==" %%a in ('findstr /r "^PORT=" "%~dp0.env"') do (
            set TARGET_PORT=%%b
        )
    )
)
if "%TARGET_PORT%"=="" (
    set TARGET_PORT=3007
)

set PORT=%TARGET_PORT%

echo ========================================================
echo  🚀 Starting AutoMeet Webinar Mini-App on port %PORT%...
echo  📡 Web App: http://localhost:%PORT%
echo ========================================================

:: 2. Dọn dẹp tiến trình cũ chiếm cổng nếu có
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r ":%PORT% .*LISTENING"') do (
    if not "%%a"=="" (
        taskkill /F /PID %%a >nul 2>&1
    )
)

:: 3. Chạy Node server kèm .env
if exist "%~dp0.env" (
    node --env-file="%~dp0.env" "%~dp0dist\index.js"
) else (
    node "%~dp0dist\index.js"
)

pause
