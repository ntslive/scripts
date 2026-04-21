#Requires -RunAsAdministrator

# Define the name of the scheduled task
$TaskName = "Test Zero"

# Define the path to the script to be executed
# $PSScriptRoot is an automatic variable that contains the directory from which a script is being run
$ScriptPath = Join-Path $PSScriptRoot "zero.ps1"

# Define the log file path in the same directory as the script
$LogFilePath = Join-Path $PSScriptRoot "zero.log"

# Define the action for the scheduled task
$TaskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" *>&1 | Out-File -FilePath `"$LogFilePath`" -Force"

# Define the trigger for the scheduled task to run every 15 minutes
$TaskTrigger = New-ScheduledTaskTrigger -Daily -At 3am

# Define the settings for the scheduled task
$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Settings $TaskSettings -Description "Test task." -User "SYSTEM"

Write-Host "Scheduled task '$TaskName' has been created"
