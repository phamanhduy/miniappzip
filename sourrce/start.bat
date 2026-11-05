@echo off
setlocal enabledelayedexpansion

SET NODE_ENV=production
SET SKIP_LICENSE=true

:: 1. Khôi phục binary Windows cho cả dist và root (tránh lỗi %20 do khoảng trắng tên user)
if exist "%~dp0dist\build\Release\better_sqlite3.win32.node" (
    copy /y "%~dp0dist\build\Release\better_sqlite3.win32.node" "%~dp0dist\build\Release\better_sqlite3.node" >nul 2>&1
    copy /y "%~dp0dist\build\Release\better_sqlite3.win32.node" "%~dp0better_sqlite3.node" >nul 2>&1
)

echo Starting ZaloCRM (Single Bundle Mode)...
node --env-file="%~dp0.env" dist/index.js
pause
