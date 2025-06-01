# Turbodrone - Start Both Apps Script (Windows)
# This script starts both the backend and frontend applications

Write-Host "Starting Turbodrone Applications..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

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

# Function to handle cleanup on script exit
function Stop-Applications {
    Write-Host ""
    Write-Host "Stopping applications..." -ForegroundColor Yellow
    
    # Stop background jobs
    Get-Job | Stop-Job
    Get-Job | Remove-Job
    
    # Kill processes by name if they're still running
    try {
        Get-Process -Name "uvicorn" -ErrorAction SilentlyContinue | Stop-Process -Force
        Get-Process -Name "bun" -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    catch {
        # Ignore errors if processes don't exist
    }
    
    Write-Host "Applications stopped." -ForegroundColor Green
    exit 0
}

# Set up Ctrl+C handler
$null = Register-EngineEvent PowerShell.Exiting -Action { Stop-Applications }

# Check if we're in the correct directory
if (!(Test-Path "backend") -or !(Test-Path "frontend")) {
    Write-Host "❌ Error: Please run this script from the turbodrone project root directory" -ForegroundColor Red
    Write-Host "   Expected to find 'backend' and 'frontend' directories" -ForegroundColor Red
    exit 1
}

# Check if uv is installed
if (!(Test-Command "uv")) {
    Write-Host "❌ Error: 'uv' is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Please install uv: https://docs.astral.sh/uv/getting-started/installation/" -ForegroundColor Blue
    exit 1
}

# Check if bun is installed
if (!(Test-Command "bun")) {
    Write-Host "❌ Error: 'bun' is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Please install bun: https://bun.sh/docs/installation" -ForegroundColor Blue
    exit 1
}

# Get the current directory
$ProjectRoot = Get-Location

Write-Host "[Backend] Starting server..." -ForegroundColor Yellow
Write-Host "   Command: cd backend && uv run uvicorn web_server:app" -ForegroundColor Gray

# Start backend in background job
$BackendJob = Start-Job -ScriptBlock {
    param($ProjectPath)
    Set-Location "$ProjectPath\backend"
    & uv run uvicorn web_server:app
} -ArgumentList $ProjectRoot

# Give backend a moment to start
Start-Sleep -Seconds 3

Write-Host "[Frontend] Starting development server..." -ForegroundColor Yellow
Write-Host "   Command: cd frontend && bun dev" -ForegroundColor Gray

# Start frontend in background job
$FrontendJob = Start-Job -ScriptBlock {
    param($ProjectPath)
    Set-Location "$ProjectPath\frontend"
    & bun dev
} -ArgumentList $ProjectRoot

Write-Host ""
Write-Host "Both applications are starting up!" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend (Web Client): http://localhost:5173" -ForegroundColor Blue
Write-Host "Backend API: http://localhost:8000" -ForegroundColor Blue
Write-Host ""
Write-Host "Note: Make sure your drone is powered on and you're connected to its WiFi network" -ForegroundColor Yellow
Write-Host "   (Network name should be like 'BRAND-MODEL-XXXXXX')" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop both applications" -ForegroundColor Cyan
Write-Host ""

# Monitor jobs and display output
try {
    while ($true) {
        # Check if jobs are still running
        $runningJobs = Get-Job | Where-Object { $_.State -eq "Running" }
        
        if ($runningJobs.Count -eq 0) {
            Write-Host "All applications have stopped." -ForegroundColor Red
            break
        }
        
        # Display any job output
        foreach ($job in $runningJobs) {
            $output = Receive-Job $job -Keep
            if ($output) {
                Write-Host $output
            }
        }
        
        Start-Sleep -Seconds 1
    }
}
catch {
    Write-Host "Script interrupted." -ForegroundColor Yellow
}
finally {
    Stop-Applications
}
