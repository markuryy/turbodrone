#!/bin/bash

# Turbodrone - Start Both Apps Script for Kali Linux
# This script starts both the backend and frontend applications

echo "Starting Turbodrone Applications..."
echo "=================================="

# Function to handle cleanup on script exit
cleanup() {
    echo ""
    echo "Stopping applications..."
    # Kill all background jobs started by this script
    kill $(jobs -p) 2>/dev/null
    exit 0
}

# Set up trap to handle Ctrl+C
trap cleanup SIGINT SIGTERM

# Check if we're in the correct directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: Please run this script from the turbodrone project root directory"
    echo "   Expected to find 'backend' and 'frontend' directories"
    exit 1
fi

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ Error: 'uv' is not installed or not in PATH"
    echo "   Please run ./install-kali.sh first or install uv manually: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# Check if bun is installed
if ! command -v bun &> /dev/null; then
    echo "❌ Error: 'bun' is not installed or not in PATH"
    echo "   Please run ./install-kali.sh first or install bun manually: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

# Get the absolute path of the project root
PROJECT_ROOT="$(pwd)"

echo "[Backend] Starting server..."
echo "   Command: cd backend && uv run uvicorn web_server:app"
cd "$PROJECT_ROOT/backend"
uv run uvicorn web_server:app &
BACKEND_PID=$!
cd "$PROJECT_ROOT"

# Give backend a moment to start
sleep 2

echo "[Frontend] Starting development server..."
echo "   Command: cd frontend && bun dev"
cd "$PROJECT_ROOT/frontend"
bun dev --host 0.0.0.0 &
FRONTEND_PID=$!
cd "$PROJECT_ROOT"

# Get network IP address for external access
NETWORK_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+' || echo "")

echo ""
echo "Both applications are starting up!"
echo ""
echo "Frontend (Web Client): http://localhost:5173"
if [ -n "$NETWORK_IP" ]; then
    echo "Network Access: http://$NETWORK_IP:5173"
fi
echo "Backend API: http://localhost:8000"
echo ""
echo "Note: Make sure your drone is powered on and you're connected to its WiFi network"
echo "   (Network name should be like 'BRAND-MODEL-XXXXXX')"
echo ""
echo "Press Ctrl+C to stop both applications"
echo ""

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
