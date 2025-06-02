#!/bin/bash

# Turbodrone - Kali Linux Installation Script
# This script installs all dependencies needed to run Turbodrone

echo "Turbodrone Kali Linux Installation"
echo "=================================="

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Python via apt
install_python() {
    if ! command_exists python3; then
        echo "Installing Python..."
        sudo apt update
        sudo apt install -y python3 python3-pip
    else
        echo "✓ Python already installed"
    fi
}

# Function to install uv
install_uv() {
    if ! command_exists uv; then
        echo "Installing uv (Python package manager)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        
        # Add uv to PATH
        export PATH="$HOME/.cargo/bin:$PATH"
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    else
        echo "✓ uv already installed"
    fi
}

# Function to install Bun
install_bun() {
    if ! command_exists bun; then
        echo "Installing Bun (JavaScript runtime)..."
        curl -fsSL https://bun.sh/install | bash
        
        # Add bun to PATH
        export PATH="$HOME/.bun/bin:$PATH"
        echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
    else
        echo "✓ Bun already installed"
    fi
}

# Function to install backend dependencies
install_backend_deps() {
    echo "Installing backend dependencies..."
    if [ -d "backend" ]; then
        cd backend
        uv sync
        cd ..
        echo "✓ Backend dependencies installed"
    else
        echo "❌ Error: backend directory not found"
        exit 1
    fi
}

# Function to install frontend dependencies
install_frontend_deps() {
    echo "Installing frontend dependencies..."
    if [ -d "frontend" ]; then
        cd frontend
        bun install
        cd ..
        echo "✓ Frontend dependencies installed"
    else
        echo "❌ Error: frontend directory not found"
        exit 1
    fi
}

# Main installation process
echo "Starting installation process..."
echo ""

# Check if we're in the correct directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: Please run this script from the turbodrone project root directory"
    echo "   Expected to find 'backend' and 'frontend' directories"
    exit 1
fi

# Install dependencies
install_python
install_uv
install_bun

echo ""
echo "Installing project dependencies..."
echo "================================="

# Refresh PATH to ensure new tools are available
export PATH="$HOME/.cargo/bin:$HOME/.bun/bin:$PATH"

install_backend_deps
install_frontend_deps

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. Connect to your drone's WiFi network (BRAND-MODEL-XXXXXX)"
echo "3. Run: ./start-kali.sh"
echo ""
echo "The web client will be available at: http://localhost:5173"
echo "The backend API will be available at: http://localhost:8000"
