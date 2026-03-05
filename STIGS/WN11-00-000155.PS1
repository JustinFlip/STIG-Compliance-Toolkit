<#
.SYNOPSIS
    This PowerShell script ensures that the Windows PowerShell 2.0 feature is disabled on the system.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : CVE-2015-8617, CVE-2015-8619
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000155

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Disables the PowerShell 2.0 Engine feature on Windows 11.
    Run with Administrator privileges. System restart may be required.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-00-000155-DisablePowerShell2.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-00-000155: Disable PowerShell 2.0" -ForegroundColor Cyan
Write-Host "Disabling PowerShell 2.0 Engine..." -ForegroundColor Yellow

try {
    $psv2Feature = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -ErrorAction SilentlyContinue
    
    if ($null -eq $psv2Feature) {
        Write-Host "ℹ PowerShell 2.0 feature not found on this system" -ForegroundColor Yellow
        Write-Host "✓ STIG WN11-00-000155 already in compliant state" -ForegroundColor Green
        exit 0
    }
    
    if ($psv2Feature.State -eq "Enabled") {
        Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart -ErrorAction Stop | Out-Null
        Write-Host "✓ PowerShell 2.0 Engine successfully disabled" -ForegroundColor Green
        Write-Host "⚠ System restart is recommended for changes to take effect" -ForegroundColor Yellow
        Write-Host "✓ STIG WN11-00-000155 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "✓ PowerShell 2.0 Engine is already disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-00-000155 already in compliant state" -ForegroundColor Green
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-00-000155: $_" -ForegroundColor Red
    exit 1
}
