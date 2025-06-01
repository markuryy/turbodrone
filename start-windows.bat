@echo off
REM Turbodrone - Start Both Apps Script (Windows Batch)
REM This script starts both the backend and frontend applications

echo Starting Turbodrone Applications...
echo ==================================

REM Check if we're in the correct directory
if not exist "backend" (
    echo Error: Please run this script from the turbodrone project root directory
    echo        Expected to find 'backend' and 'frontend' directories
    pause
    exit /b 1
)

if not exist "frontend" (
    echo Error: Please run this script from the turbodrone project root directory
    echo        Expected to find 'backend' and 'frontend' directories
    pause
    exit /b 1
)

REM Check if uv is installed
uv --version >nul 2>&1
if errorlevel 1 (
    echo Error: 'uv' is not installed or not in PATH
    echo        Please install uv: https://docs.astral.sh/uv/getting-started/installation/
    pause
    exit /b 1
)

REM Check if bun is installed
bun --version >nul 2>&1
if errorlevel 1 (
    echo Error: 'bun' is not installed or not in PATH
    echo        Please install bun: https://bun.sh/docs/installation
    pause
    exit /b 1
)

echo [Backend] Starting server...
echo    Command: cd backend ^&^& uv run uvicorn web_server:app
start "Turbodrone Backend" cmd /k "cd backend && uv run uvicorn web_server:app"

REM Give backend a moment to start
timeout /t 3 /nobreak >nul

echo [Frontend] Starting development server...
echo    Command: cd frontend ^&^& bun dev
start "Turbodrone Frontend" cmd /k "cd frontend && bun dev"

echo.
echo Both applications are starting up!
echo.
echo Frontend (Web Client): http://localhost:5173
echo Backend API: http://localhost:8000
echo.
echo Note: Make sure your drone is powered on and you're connected to its WiFi network
echo       (Network name should be like 'BRAND-MODEL-XXXXXX')
echo.
echo Close the terminal windows to stop the applications
echo.
pause
