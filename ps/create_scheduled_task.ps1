#Requires -RunAsAdministrator

# Define the name of the scheduled task
$TaskName = "Audio Uploader"

# Define the path to the script to be executed
# $PSScriptRoot is an automatic variable that contains the directory from which a script is being run
$ScriptPath = Join-Path $PSScriptRoot "audio_uploader.ps1"

# Define the log file path in the same directory as the script
$LogFilePath = Join-Path $PSScriptRoot "AudioUploader.log"

$AudioDir = "C:\Users\Radio Production\Recording\PlayIt\NTS1"
$S3Loc = "s3://nts-incoming/*_UPLOADS_S2_STREAMING/CompressedOmnia9/"

# Define the action for the scheduled task
$TaskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" -S3Loc `"$S3Loc`" -AudioDir `"$AudioDir`" *>&1 | Out-File -FilePath `"$LogFilePath`" -Force"

# Define the trigger for the scheduled task to run every 15 minutes
$TaskTrigger = New-ScheduledTaskTrigger -Repeating -RepetitionInterval (New-TimeSpan -Minutes 15)

# Define the settings for the scheduled task
$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Settings $TaskSettings -Description "Runs the audio uploader script every 15 minutes when a network is available." -User "SYSTEM"

Write-Host "Scheduled task '$TaskName' has been created to run '$ScriptPath' every 15 minutes when a network is available."
