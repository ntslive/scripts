param (
    [string]$LogPath
)
Start-Transcript -Path "$LogPath" -Append
    Write-Host "$(Get-Date) Running Test Script"
    Write-Output "$(Get-Date) Running Test Script1"
    "$(Get-Date) Running Test Script1"
Stop-Transcript
