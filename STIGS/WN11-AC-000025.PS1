<#
.SYNOPSIS
    This PowerShell script ensures that the maximum password age is configured to 60 days or less.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000025

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Configures the maximum password age to 60 days to meet the STIG requirement.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-AC-000025-MaxPasswordAge.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-AC-000025: Maximum Password Age" -ForegroundColor Cyan
Write-Host "Setting maximum password age to 60 days..." -ForegroundColor Yellow

try {
    net accounts /maxpwage:60 | Out-Null
    
    $accountInfo = net accounts
    if ($accountInfo -match "Maximum password age.*60") {
        Write-Host "✓ Maximum password age successfully set to 60 days" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000025 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Setting applied but verification returned unexpected result" -ForegroundColor Yellow
        Write-Host $accountInfo
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-AC-000025: $_" -ForegroundColor Red
    exit 1
}
