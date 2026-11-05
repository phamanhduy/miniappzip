@echo off
setlocal enabledelayedexpansion

:: 1. Xác định PORT linh hoạt: %1 -> %PORT% -> .env -> mặc định 3000
set TARGET_PORT=%1
if "%TARGET_PORT%"=="" (
    set TARGET_PORT=%PORT%
)
if "%TARGET_PORT%"=="" (
    if exist "%~dp0.env" (
        for /f "tokens=1,2 delims==" %%a in ('findstr /r "^PORT=" "%~dp0.env"') do (
            set TARGET_PORT=%%b
        )
    )
)
if "%TARGET_PORT%"=="" (
    set TARGET_PORT=3000
)

echo Stopping ZaloCRM on port %TARGET_PORT%...

:: 2. Kill theo cổng
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r ":%TARGET_PORT% .*LISTENING"') do (
    if not "%%a"=="" (
        taskkill /F /PID %%a >nul 2>&1
    )
)

:: 3. Kill node process theo command/window
taskkill /F /IM node.exe /FI "WINDOWTITLE eq *ZaloCRM*" >nul 2>&1

echo ZaloCRM stopped successfully.
