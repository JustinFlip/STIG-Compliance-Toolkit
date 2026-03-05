<#
.SYNOPSIS
    This PowerShell script ensures that the password history is configured to remember 24 or more passwords.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000020

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Configures password history to remember 24 passwords to meet the STIG requirement.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-AC-000020-PasswordHistory.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-AC-000020: Password History" -ForegroundColor Cyan
Write-Host "Setting password history to remember 24 passwords..." -ForegroundColor Yellow

try {
    net accounts /uniquepw:24 | Out-Null
    
    $accountInfo = net accounts
    if ($accountInfo -match "Password history length.*24") {
        Write-Host "✓ Password history successfully set to 24 passwords" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000020 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Setting applied but verification returned unexpected result" -ForegroundColor Yellow
        Write-Host $accountInfo
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-AC-000020: $_" -ForegroundColor Red
    exit 1
}
