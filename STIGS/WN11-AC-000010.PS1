<#
.SYNOPSIS
    This PowerShell script ensures that the number of allowed bad logon attempts is configured to 3 or less.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000010

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Configures the bad logon attempt threshold to 3 attempts to meet the STIG requirement.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-AC-000010-BadLogonAttempts.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-AC-000010: Bad Logon Attempt Threshold" -ForegroundColor Cyan
Write-Host "Setting bad logon attempt threshold to 3..." -ForegroundColor Yellow

try {
    net accounts /lockoutthreshold:3 | Out-Null
    
    $accountInfo = net accounts
    if ($accountInfo -match "Lockout threshold.*3") {
        Write-Host "✓ Bad logon attempt threshold successfully set to 3" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000010 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Setting applied but verification returned unexpected result" -ForegroundColor Yellow
        Write-Host $accountInfo
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-AC-000010: $_" -ForegroundColor Red
    exit 1
}
