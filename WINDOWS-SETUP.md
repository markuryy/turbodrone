# Windows Setup Guide for Turbodrone

This guide provides detailed instructions for setting up Turbodrone on Windows systems.

## Prerequisites

- Windows 10 or Windows 11
- PowerShell 5.1 or later (comes with Windows)
- Internet connection for downloading dependencies

## Installation Options

### Option 1: Automated Installation (Recommended)

1. **Open PowerShell as Administrator**
   - Press `Win + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)"
   - If prompted by UAC, click "Yes"

2. **Navigate to the project directory**
   ```powershell
   cd path\to\turbodrone
   ```

3. **Set execution policy (if needed)**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run the installation script**
   ```powershell
   .\install-windows.ps1
   ```

5. **Start the applications**
   ```powershell
   .\start-windows.ps1
   ```

### Option 2: Batch File Installation

If you prefer using Command Prompt or have issues with PowerShell:

1. **Open Command Prompt as Administrator**
   - Press `Win + R`, type `cmd`, then press `Ctrl + Shift + Enter`

2. **Navigate to the project directory**
   ```cmd
   cd path\to\turbodrone
   ```

3. **Run the installation**
   ```cmd
   install-windows.bat
   ```

4. **Start the applications**
   ```cmd
   start-windows.bat
   ```

## What Gets Installed

The installation script will automatically install:

- **Python 3.12+** - Required for the backend
- **uv** - Modern Python package manager
- **Bun** - JavaScript runtime for the frontend
- **Visual C++ Redistributable** - Required for some Python packages
- **windows-curses** - Windows-specific Python library
- **All project dependencies** - Both backend and frontend packages

## Troubleshooting

### PowerShell Execution Policy Issues

If you get an execution policy error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python Installation Issues

If Python installation fails:
1. Download Python manually from [python.org](https://www.python.org/downloads/)
2. Make sure to check "Add Python to PATH" during installation
3. Restart PowerShell and try again

### Visual C++ Build Tools Issues

If you encounter compilation errors for Python packages:
1. Download and install Visual Studio Build Tools from [Microsoft](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
2. Select "C++ build tools" workload during installation

### PATH Issues

If commands like `uv` or `bun` are not found after installation:
1. Restart PowerShell/Command Prompt
2. Or manually add to PATH:
   - `%USERPROFILE%\.cargo\bin` (for uv)
   - `%USERPROFILE%\.bun\bin` (for bun)

### Firewall/Antivirus Issues

Some antivirus software may block the installation scripts:
1. Temporarily disable real-time protection
2. Add the project folder to antivirus exclusions
3. Re-enable protection after installation

## Manual Installation

If the automated scripts don't work, you can install manually:

1. **Install Python 3.12+**
   - Download from [python.org](https://www.python.org/downloads/)
   - Check "Add Python to PATH"

2. **Install uv**
   ```powershell
   Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
   ```

3. **Install Bun**
   ```powershell
   Invoke-RestMethod https://bun.sh/install.ps1 | Invoke-Expression
   ```

4. **Install backend dependencies**
   ```powershell
   cd backend
   uv sync
   uv add windows-curses
   cd ..
   ```

5. **Install frontend dependencies**
   ```powershell
   cd frontend
   bun install
   cd ..
   ```

## Running the Application

After installation, you can start the application using:

- **PowerShell**: `.\start-windows.ps1`
- **Batch**: `.\start-windows.bat`
- **Manual**:
  ```powershell
  # Terminal 1 - Backend
  cd backend
  uv run uvicorn web_server:app
  
  # Terminal 2 - Frontend
  cd frontend
  bun dev
  ```

## Next Steps

1. **Connect to drone WiFi** - Look for network named "BRAND-MODEL-XXXXXX"
2. **Open web browser** - Navigate to `http://localhost:5173`
3. **Test connection** - You should see the drone video feed
4. **Configure controller** - Plug in a gaming controller for better control

## Support

If you encounter issues:
1. Check the main [README.md](README.md) for general troubleshooting
2. Ensure your drone is powered on and broadcasting its WiFi network
3. Verify you're connected to the drone's WiFi (not your home WiFi)
4. Check Windows Defender/Firewall settings if connection fails
