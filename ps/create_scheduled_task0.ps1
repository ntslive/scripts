#Requires -RunAsAdministrator

# Define the name of the scheduled task
$TaskName = "Test Zero"

# Define the path to the script to be executed
# $PSScriptRoot is an automatic variable that contains the directory from which a script is being run
$ScriptPath = Join-Path $PSScriptRoot "zero.ps1"

# Define the action for the scheduled task
$TaskAction = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Define the trigger for the scheduled task to run at logon
$TaskTrigger = New-ScheduledTaskTrigger -AtLogon

# Define the settings for the scheduled task
$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Settings $TaskSettings -Description "Test task." -User "SYSTEM" -Force

Write-Host "Scheduled task '$TaskName' has been created"
