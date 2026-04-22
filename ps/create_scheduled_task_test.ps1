#Requires -RunAsAdministrator

# Define the name of the scheduled task
$TaskName = "Test Task"

# Define the path to the script to be executed
# $PSScriptRoot is an automatic variable that contains the directory from which a script is being run
$ScriptPath = Join-Path $PSScriptRoot "test.ps1"
$LogPath = Join-Path $PSScriptRoot "test.log"

# Define the action for the scheduled task
$TaskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" > `"$LogPath`" 2>&1"

# Define the trigger for the scheduled task to run every 15 minutes
$StartTime = (Get-Date).AddDays(-1).Date
$TaskTrigger = New-ScheduledTaskTrigger -Once -At $StartTime -RepetitionInterval (New-TimeSpan -Minutes 15) -RandomDelay (New-TimeSpan -Minutes 15)

# Define the settings for the scheduled task
$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Settings $TaskSettings -Description "Runs the audio uploader script every 15 minutes when a network is available." -Force

Write-Host "Scheduled task '$TaskName' has been created to run '$ScriptPath' every 15 minutes when a network is available."
