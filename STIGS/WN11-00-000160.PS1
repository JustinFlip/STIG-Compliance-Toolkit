<#
.SYNOPSIS
    This PowerShell script ensures that the Server Message Block (SMB) v1 protocol is disabled on the system.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : CVE-2017-0144, CVE-2017-0145, CVE-2017-0146, CVE-2017-0147, CVE-2017-0148
    Plugin IDs      : Tenable 103586
    STIG-ID         : WN11-00-000160

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Disables SMB v1 protocol on Windows 11.
    Run with Administrator privileges. System restart is required for full effect.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-00-000160-DisableSMBv1.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-00-000160: Disable SMB v1 Protocol" -ForegroundColor Cyan
Write-Host "Disabling SMB v1 protocol via Windows Features and Registry..." -ForegroundColor Yellow

try {
    $smbv1Feature = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue
    
    if ($null -ne $smbv1Feature -and $smbv1Feature.State -eq "Enabled") {
        Write-Host "Disabling SMB1Protocol Windows Feature..." -ForegroundColor Gray
        Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction Stop | Out-Null
        Write-Host "✓ SMB1Protocol Windows Feature disabled" -ForegroundColor Green
    } else {
        Write-Host "ℹ SMB1Protocol Windows Feature already disabled" -ForegroundColor Yellow
    }
    
    Write-Host "Configuring registry settings for SMB v1 disablement..." -ForegroundColor Gray
    
    $smbPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    if (Test-Path $smbPath) {
        Set-ItemProperty -Path $smbPath -Name "SMB1" -Value 0 -Force -ErrorAction Stop
        Write-Host "✓ Registry: SMB1 value set to 0" -ForegroundColor Green
    }
    
    $smbrPath = "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10"
    if (Test-Path $smbrPath) {
        Set-ItemProperty -Path $smbrPath -Name "Start" -Value 4 -Force -ErrorAction Stop
        Write-Host "✓ Registry: mrxsmb10 service disabled" -ForegroundColor Green
    }
    
    Write-Host "⚠ System restart is required for changes to take full effect" -ForegroundColor Yellow
    Write-Host "✓ STIG WN11-00-000160 remediated successfully" -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "✗ Error remediating STIG WN11-00-000160: $_" -ForegroundColor Red
    exit 1
}
