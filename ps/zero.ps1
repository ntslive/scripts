# Define the log file path in the same directory as the script
$LogFilePath = Join-Path $PSScriptRoot "zero.log"

# Append a timestamped message to the log file
"Scheduled task Zero completed $(Get-Date)" | Out-File -FilePath $LogFilePath -Append
