# Turbodrone - Windows Installation Script
# This script installs all dependencies needed to run Turbodrone on Windows

Write-Host "Turbodrone Windows Installation" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install Winget if not present (should be available on Windows 10/11)
function Install-Winget {
    if (!(Test-Command "winget")) {
        Write-Host "Installing Windows Package Manager (winget)..." -ForegroundColor Yellow
        Write-Host "Please install winget manually from Microsoft Store or GitHub releases" -ForegroundColor Red
        Write-Host "https://github.com/microsoft/winget-cli/releases" -ForegroundColor Blue
        exit 1
    } else {
        Write-Host "✓ Windows Package Manager (winget) already available" -ForegroundColor Green
    }
}

# Function to install Python via Winget
function Install-Python {
    if (!(Test-Command "python")) {
        Write-Host "Installing Python..." -ForegroundColor Yellow
        winget install Python.Python.3.12 --accept-source-agreements --accept-package-agreements
        
        # Refresh PATH
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
        
        # Verify installation
        if (!(Test-Command "python")) {
            Write-Host "❌ Python installation failed. Please restart PowerShell and try again." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "✓ Python already installed" -ForegroundColor Green
    }
    
    # Check Python version
    $pythonVersion = python --version 2>&1
    Write-Host "Python version: $pythonVersion" -ForegroundColor Blue
}

# Function to install uv
function Install-Uv {
    if (!(Test-Command "uv")) {
        Write-Host "Installing uv (Python package manager)..." -ForegroundColor Yellow
        
        # Install uv using PowerShell script
        Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
        
        # Add uv to PATH for current session
        $uvPath = "$env:USERPROFILE\.cargo\bin"
        if (Test-Path $uvPath) {
            $env:PATH = "$uvPath;$env:PATH"
        }
        
        # Verify installation
        if (!(Test-Command "uv")) {
            Write-Host "❌ uv installation failed. Please restart PowerShell and try again." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "✓ uv already installed" -ForegroundColor Green
    }
}

# Function to install Bun
function Install-Bun {
    if (!(Test-Command "bun")) {
        Write-Host "Installing Bun (JavaScript runtime)..." -ForegroundColor Yellow
        
        # Install Bun using PowerShell script
        Invoke-RestMethod https://bun.sh/install.ps1 | Invoke-Expression
        
        # Add Bun to PATH for current session
        $bunPath = "$env:USERPROFILE\.bun\bin"
        if (Test-Path $bunPath) {
            $env:PATH = "$bunPath;$env:PATH"
        }
        
        # Verify installation
        if (!(Test-Command "bun")) {
            Write-Host "❌ Bun installation failed. Please restart PowerShell and try again." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "✓ Bun already installed" -ForegroundColor Green
    }
}

# Function to install Visual C++ Build Tools (needed for some Python packages)
function Install-BuildTools {
    Write-Host "Checking for Visual C++ Build Tools..." -ForegroundColor Yellow
    
    # Try to install via winget (this may not always work)
    try {
        winget list "Microsoft Visual C++ 2015-2022 Redistributable" | Out-Null
        Write-Host "✓ Visual C++ Redistributable already installed" -ForegroundColor Green
    }
    catch {
        Write-Host "Installing Visual C++ Build Tools..." -ForegroundColor Yellow
        winget install Microsoft.VCRedist.2015+.x64 --accept-source-agreements --accept-package-agreements
    }
}

# Function to install backend dependencies
function Install-BackendDeps {
    Write-Host "Installing backend dependencies..." -ForegroundColor Yellow
    
    if (Test-Path "backend") {
        Push-Location "backend"
        
        # Install dependencies using uv
        uv sync
        
        # Install windows-curses specifically for Windows
        Write-Host "Installing windows-curses for Windows compatibility..." -ForegroundColor Yellow
        uv add windows-curses
        
        Pop-Location
        Write-Host "✓ Backend dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Error: backend directory not found" -ForegroundColor Red
        exit 1
    }
}

# Function to install frontend dependencies
function Install-FrontendDeps {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    
    if (Test-Path "frontend") {
        Push-Location "frontend"
        bun install
        Pop-Location
        Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Error: frontend directory not found" -ForegroundColor Red
        exit 1
    }
}

# Function to update PATH permanently
function Update-PathPermanently {
    Write-Host "Updating PATH environment variable..." -ForegroundColor Yellow
    
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    $pathsToAdd = @(
        "$env:USERPROFILE\.cargo\bin",
        "$env:USERPROFILE\.bun\bin"
    )
    
    foreach ($pathToAdd in $pathsToAdd) {
        if (Test-Path $pathToAdd) {
            if ($userPath -notlike "*$pathToAdd*") {
                $newPath = "$userPath;$pathToAdd"
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
                Write-Host "✓ Added $pathToAdd to PATH" -ForegroundColor Green
            }
        }
    }
}

# Main installation process
Write-Host "Starting installation process..." -ForegroundColor Cyan
Write-Host ""

# Check if we're in the correct directory
if (!(Test-Path "backend") -or !(Test-Path "frontend")) {
    Write-Host "❌ Error: Please run this script from the turbodrone project root directory" -ForegroundColor Red
    Write-Host "   Expected to find 'backend' and 'frontend' directories" -ForegroundColor Red
    exit 1
}

# Check PowerShell execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Host "❌ PowerShell execution policy is restricted." -ForegroundColor Red
    Write-Host "   Please run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Install dependencies
Install-Winget
Install-Python
Install-BuildTools
Install-Uv
Install-Bun

Write-Host ""
Write-Host "Installing project dependencies..." -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Refresh PATH to ensure new tools are available
$env:PATH = "$env:USERPROFILE\.cargo\bin;$env:USERPROFILE\.bun\bin;$env:PATH"

Install-BackendDeps
Install-FrontendDeps

# Update PATH permanently
Update-PathPermanently

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart PowerShell to ensure PATH changes take effect" -ForegroundColor White
Write-Host "2. Connect to your drone's WiFi network (BRAND-MODEL-XXXXXX)" -ForegroundColor White
Write-Host "3. Run: .\start.sh (or start the backend and frontend manually)" -ForegroundColor White
Write-Host ""
Write-Host "Manual startup commands:" -ForegroundColor Cyan
Write-Host "Backend:  cd backend && uv run uvicorn web_server:app" -ForegroundColor White
Write-Host "Frontend: cd frontend && bun dev" -ForegroundColor White
Write-Host ""
Write-Host "The web client will be available at: http://localhost:5173" -ForegroundColor Blue
Write-Host "The backend API will be available at: http://localhost:8000" -ForegroundColor Blue
Write-Host ""
Write-Host "Note: If you encounter any issues with Python packages, you may need to install" -ForegroundColor Yellow
Write-Host "Visual Studio Build Tools manually from: https://visualstudio.microsoft.com/visual-cpp-build-tools/" -ForegroundColor Yellow
