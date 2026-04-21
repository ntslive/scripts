<#
###SETUP###

# Install AWS CLI
# http://docs.aws.amazon.com/cli/latest/userguide/installing.html

# Configure AWS CLI with credentials:
# PS> aws configure
# AWS Access Key ID [****************MQ5A]:
# AWS Secret Access Key [****************ukte]:
# Default region name [eu-west-1]:
# Default output format [None]:

# you may want to reduce maximum number of concurrent requests (default it 10)
# Lowering this value will make the S3 transfer commands less resource intensive.
# more info http://docs.aws.amazon.com/cli/latest/topic/s3-config.html
# PS> aws configure set default.s3.max_concurrent_requests 2

# Test manually, then set up a scheduled task
# PS> powershell -File C:\path\to\script\audio_uploader.ps1 -AudioDir C:\path\to\audio-dir -S3Loc s3://bucket-name/path/

.SYNOPSIS
    Uploads audio files to AWS S3.

.DESCRIPTION
    This script finds .mp3 files in a specified directory, compresses them, uploads them to S3, and then cleans up old backup files.

.PARAMETER AudioDir
    The directory containing the audio files.

.PARAMETER S3Loc
    The S3 location (bucket and path) to upload the files to.
#>
param (
    [string]$AudioDir,
    [string]$S3Loc
)

$LogFilePath = Join-Path $PSScriptRoot "AudioUploader.log"

"Starting Script $(Get-Date) Source $AudioDir Dest $S3Loc" | Out-File -FilePath $LogFilePath -Append

# uploads all .mp3 files, which have not been changed within the last minutes and renames them to .mp3.bak
Get-ChildItem -Path "$AudioDir" -Filter *.mp3 -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-30) } | ForEach-Object {
    "Start uploading $(Get-Date) File $($_.FullName)" | Out-File -FilePath $LogFilePath -Append
    aws s3 cp "$($_.FullName)" "$S3Loc"
    "Uploading complete $(Get-Date) File $($_.FullName)" | Out-File -FilePath $LogFilePath -Append
    Rename-Item "$($_.FullName)" "$($_.FullName).bak"
}
"Upload complete Source $AudioDir" | Out-File -FilePath $LogFilePath -Append
# deletes all .bak files, which have not been accessed in the last 7 days.
Get-ChildItem -Path $AudioDir -Filter *.bak -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | ForEach-Object {
    Remove-Item $($_.FullName)
}
"Script complete $(Get-Date) Source $AudioDir" | Out-File -FilePath $LogFilePath -Append
