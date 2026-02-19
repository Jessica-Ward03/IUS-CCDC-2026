<#
CCDC Logging Baseline for Windows (All Hosts)
- Enables high-signal Windows audit logging
- Enables PowerShell Script Block + Module loggin
- Enables Windows Defender Operational log channel
- Enables Windows Firewall allowed/blocked logging

Tested targets: Windows 10/11, Windows Server 2019/2022
#>

# ---------------------------
# Safety / Preconditions
# ---------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Run this script as Administrator."
    exit 1
}

$ErrorActionPreference = "Stop"


# Helpers

function Ensure-RegistryKey {
    param([Parameter(Mandatory)] [string]$Path)
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
}

function Set-RegDword {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [int]$Value
    )
    Ensure-RegistryKey -Path $Path
    New-ItemProperty -Path $Path -Name $Name -PropertyType DWord -Value $Value -Force | Out-Null
}

function Enable-EventLogChannel {
    param([Parameter(Mandatory)] [string]$ChannelName)
    # Enable channel (if it exists)
    try {
        & wevtutil sl $ChannelName /e:true | Out-Null
    } catch {
        Write-Warning "Could not enable channel '$ChannelName' (may not exist on this host)."
    }
}

# 1) Advanced Audit Policy

Write-Host "Enabling Advanced Audit Policy subcategories..." -ForegroundColor Cyan

# Success/Failure on key categories
& auditpol /set /category:"Logon/Logoff"       /success:enable /failure:enable | Out-Null
& auditpol /set /category:"Account Logon"      /success:enable /failure:enable | Out-Null
& auditpol /set /category:"Account Management" /success:enable /failure:enable | Out-Null
& auditpol /set /category:"Policy Change"      /success:enable /failure:enable | Out-Null
& auditpol /set /category:"System"             /success:enable /failure:enable | Out-Null

# Process Creation (4688) – this is the big one
& auditpol /set /subcategory:"Process Creation" /success:enable | Out-Null

# Optional but useful for competitions (uncomment if you want more signal)
# & auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable /failure:enable | Out-Null
# & auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable | Out-Null

# Include command line in 4688 events
Write-Host "Enabling Process Creation command-line logging..." -ForegroundColor Cyan
$procAuditKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
Set-RegDword -Path $procAuditKey -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1


# 2) PowerShell Logging (4103/4104)

Write-Host "Enabling PowerShell Script Block + Module logging..." -ForegroundColor Cyan

# Script Block Logging (4104)
$psSblKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
Set-RegDword -Path $psSblKey -Name "EnableScriptBlockLogging" -Value 1

# Module Logging (4103)
$psModKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
Set-RegDword -Path $psModKey -Name "EnableModuleLogging" -Value 1

$psModNamesKey = Join-Path $psModKey "ModuleNames"
Ensure-RegistryKey -Path $psModNamesKey
# Log all modules (high visibility; may be noisy on some systems)
New-ItemProperty -Path $psModNamesKey -Name "*" -PropertyType String -Value "*" -Force | Out-Null

# Enable the PowerShell Operational channel (where 4103/4104 live)
Enable-EventLogChannel -ChannelName "Microsoft-Windows-PowerShell/Operational"


$enableTranscription = $true
if ($enableTranscription) {
    Write-Host "Enabling PowerShell Transcription (optional)..." -ForegroundColor Cyan
    $psTransKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
    Set-RegDword -Path $psTransKey -Name "EnableTranscripting" -Value 1
    Set-RegDword -Path $psTransKey -Name "EnableInvocationHeader" -Value 1

    $transcriptDir = "C:\ProgramData\CCDC\PS-Transcripts"
    if (-not (Test-Path $transcriptDir)) { New-Item -ItemType Directory -Path $transcriptDir -Force | Out-Null }

    New-ItemProperty -Path $psTransKey -Name "OutputDirectory" -PropertyType String -Value $transcriptDir -Force | Out-Null
}


# 3) Windows Defender Operational Logging

Write-Host "Enabling Windows Defender Operational log channel (if present)..." -ForegroundColor Cyan
Enable-EventLogChannel -ChannelName "Microsoft-Windows-Windows Defender/Operational"


# 4) Task Scheduler + RDP-related useful channels

Write-Host "Enabling additional useful operational channels..." -ForegroundColor Cyan
Enable-EventLogChannel -ChannelName "Microsoft-Windows-TaskScheduler/Operational"
Enable-EventLogChannel -ChannelName "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"


# 5) Windows Firewall Logging

Write-Host "Enabling Windows Firewall allowed/blocked logging..." -ForegroundColor Cyan

$fwLogDir = "$env:SystemRoot\System32\LogFiles\Firewall"
if (-not (Test-Path $fwLogDir)) { New-Item -ItemType Directory -Path $fwLogDir -Force | Out-Null }

$fwLogFile = Join-Path $fwLogDir "pfirewall.log"

# Enable logging for all profiles
Set-NetFirewallProfile -Profile Domain,Private,Public `
    -LogAllowed True `
    -LogBlocked True `
    -LogFileName $fwLogFile `
    -LogMaxSizeKilobytes 32768 | Out-Null  # 32MB


# Done
Write-Host ""
Write-Host "Logging baseline applied." -ForegroundColor Green
Write-Host "Key signals now available:" -ForegroundColor Green
Write-Host "  - Security 4688 (process creation w/ command line)" -ForegroundColor Green
Write-Host "  - PowerShell 4104/4103 (script block/module logging)" -ForegroundColor Green
Write-Host "  - Defender Operational events (if Defender present)" -ForegroundColor Green
Write-Host "  - Firewall log: $fwLogFile" -ForegroundColor Green
Write-Host "  - PS Transcripts: C:\ProgramData\CCDC\PS-Transcripts (if enabled)" -ForegroundColor Green
