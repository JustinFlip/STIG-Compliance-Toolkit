# Windows 11 Pro 25H2 STIG Remediation Scripts

Hi there 👋

Welcome to my collection of **PowerShell remediation scripts** for automating DISA STIG (Security Technical Implementation Guide) compliance on Windows 11 Pro 25H2 systems.

---

## 🎯 What Are STIGs?

DISA STIGs are **Security Technical Implementation Guides** that provide security configuration standards for Department of Defense systems and civilian agencies. They define baseline security configurations to:

- Reduce vulnerability exposure
- Ensure consistent security posture
- Meet compliance requirements
- Protect against common attack vectors

This repository automates the remediation of **10 critical STIG findings** on Windows 11 Pro 25H2 systems.

---

## 📦 Scripts Included (10 Total)

### 🔐 Account Policies (5 scripts)

| STIG ID | Script | Purpose |
|---------|--------|---------|
| WN11-AC-000005 | AccountLockoutDuration | Sets account lockout to 30 minutes (prevents brute force) |
| WN11-AC-000010 | BadLogonAttempts | Sets bad logon threshold to 3 attempts |
| WN11-AC-000020 | PasswordHistory | Enforces 24-password history (prevents reuse) |
| WN11-AC-000025 | MaxPasswordAge | Sets max password age to 60 days (enforces rotation) |
| WN11-AC-000035 | MinPasswordLength | Requires 14-character minimum passwords |

**Why These Matter:** Account policies are the first line of defense against unauthorized access and credential compromise attacks.

---

### 🛡️ System Hardening (2 scripts)

| STIG ID | Script | Purpose | Severity |
|---------|--------|---------|----------|
| WN11-00-000155 | DisablePowerShell2 | Disables legacy PowerShell 2.0 | HIGH |
| WN11-00-000160 | DisableSMBv1 | Disables SMB v1 protocol | **CRITICAL** |

**Why These Matter:** 
- **PowerShell 2.0** contains known security vulnerabilities and lacks modern protections
- **SMB v1** is exploited by WannaCry, EternalBlue, and other ransomware (CVE-2017-0144+)

---

### 📋 Service Management (1 script)

| STIG ID | Script | Purpose |
|---------|--------|---------|
| WN11-00-000175 | DisableSecondaryLogon | Disables RunAs service (reduces privilege escalation risk) |

**Why This Matters:** Secondary Logon enables lateral movement and privilege escalation if compromised.

---

### 🔒 Security Configuration (2 scripts)

| STIG ID | Script | Purpose |
|---------|--------|---------|
| WN11-CC-000038 | DisableWDigest | Disables WDigest authentication (prevents cleartext password storage) |
| WN11-CC-000190 | DisableAutoplay | Disables Autoplay for all drives (prevents drive-by malware) |

**Why These Matter:**
- **WDigest** stores passwords in memory in a format vulnerable to credential dumping
- **Autoplay** automatically executes code from USB drives and external media

---

## 🚀 Quick Start

### Prerequisites
- **OS:** Windows 11 Pro 25H2
- **PowerShell:** 5.1 or higher
- **Privileges:** Administrator rights required
- **Internet:** Not required (works offline)

### Installation

1. **Clone or download this repository:**
```bash
git clone https://github.com/JustinFlip/STIGS.git
cd STIGS
```

2. **(Optional) Set execution policy:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Running Scripts

**Run a single script:**
```powershell
.\Remediation-WN11-AC-000005-AccountLockoutDuration.ps1
```

**Run all scripts:**
```powershell
Get-ChildItem Remediation-*.ps1 | ForEach-Object { & $_.FullName }
```

**Expected Output:**
```
Remediating STIG WN11-AC-000005: Account Lockout Duration
Setting account lockout duration to 30 minutes...
✓ Account lockout duration successfully set to 30 minutes
✓ STIG WN11-AC-000005 remediated successfully
```

---

## 📝 Script Format

Each script follows a professional, standardized template:

```powershell
<#
.SYNOPSIS
    [Description of what the script does]

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : [CVE IDs if applicable]
    Plugin IDs      : [Plugin IDs if applicable]
    STIG-ID         : [STIG ID]

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    [Usage instructions]
    Example syntax:
    PS C:\> .\Remediation-[STIG-ID]-[Description].ps1
#>

# Implementation code...
```

---

## ✨ Key Features

✅ **Admin Validation** - Each script checks for Administrator privileges before execution  
✅ **Error Handling** - Try-catch blocks for graceful error handling and clear error messages  
✅ **Verification Logic** - Built-in confirmation that remediation succeeded  
✅ **Color-Coded Output** - Visual feedback (green=success, yellow=warning, red=error)  
✅ **Exit Codes** - Proper exit codes (0=success, 1=failure) for automation/scripting  
✅ **Independent Execution** - Scripts can run individually or together  
✅ **No Dependencies** - Each script is standalone; no inter-script dependencies  

---

## 🔍 What Each Script Does

### Account Lockout Duration (WN11-AC-000005)
```powershell
net accounts /lockoutduration:30
```
- **Effect:** After 3 failed login attempts, account locks for 30 minutes
- **Protection:** Prevents brute force password attacks
- **Restart Required:** No

### Bad Logon Attempt Threshold (WN11-AC-000010)
```powershell
net accounts /lockoutthreshold:3
```
- **Effect:** Account locks after 3 failed login attempts
- **Protection:** Dramatically reduces brute force attack window
- **Restart Required:** No

### Password History (WN11-AC-000020)
```powershell
net accounts /uniquepw:24
```
- **Effect:** Users cannot reuse any of last 24 passwords
- **Protection:** Prevents compromised password reuse
- **Restart Required:** No

### Maximum Password Age (WN11-AC-000025)
```powershell
net accounts /maxpwage:60
```
- **Effect:** Forces password change every 60 days
- **Protection:** Limits exposure of compromised credentials
- **Restart Required:** No

### Minimum Password Length (WN11-AC-000035)
```powershell
net accounts /minpwlen:14
```
- **Effect:** All passwords must be at least 14 characters
- **Protection:** Exponentially increases crack time against brute force
- **Restart Required:** No

### Disable PowerShell 2.0 (WN11-00-000155)
```powershell
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root
```
- **Effect:** PowerShell 2.0 Engine is removed
- **Protection:** Eliminates known PowerShell 2.0 vulnerabilities
- **Restart Required:** Yes
- **CVEs:** CVE-2015-8617, CVE-2015-8619

### Disable SMB v1 (WN11-00-000160)
```powershell
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0
```
- **Effect:** SMB v1 protocol is completely disabled
- **Protection:** Prevents EternalBlue, WannaCry, and similar RCE attacks
- **Restart Required:** Yes
- **CVEs:** CVE-2017-0144, CVE-2017-0145, CVE-2017-0146, CVE-2017-0147, CVE-2017-0148

### Disable Secondary Logon (WN11-00-000175)
```powershell
Set-Service -Name "seclogon" -StartupType Disabled
Stop-Service -Name "seclogon" -Force
```
- **Effect:** RunAs functionality is disabled
- **Protection:** Reduces lateral movement and privilege escalation attack surface
- **Restart Required:** No

### Disable WDigest (WN11-CC-000038)
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name "UseLogonCredential" -Value 0
```
- **Effect:** WDigest no longer stores cleartext passwords in memory
- **Protection:** Prevents credential dumping attacks
- **Restart Required:** No

### Disable Autoplay (WN11-CC-000190)
```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 255
```
- **Effect:** Autoplay is disabled for all drive types
- **Protection:** Prevents automatic code execution from USB drives and external media
- **Restart Required:** No

---

## ⚠️ Before Running

**IMPORTANT:** Follow these steps before running any remediation scripts:

1. **Create a System Backup or Snapshot**
   - Take a VM snapshot or system image
   - Create a recovery point in System Restore
   - This enables rollback if issues arise

2. **Test in Non-Production First**
   - Test on a lab VM or test system first
   - Verify no critical applications break
   - Document any compatibility issues

3. **Review Each Script**
   - Read the .SYNOPSIS section
   - Understand what the script changes
   - Note the "Restart Required" status

4. **Plan for System Restarts**
   - Some scripts (PowerShell 2.0, SMB v1) require system restart
   - Schedule remediation during maintenance windows
   - Inform users of planned reboots

5. **Have a Rollback Plan**
   - Know how to reverse changes if needed
   - PowerShell 2.0 and SMB v1 can be re-enabled if necessary
   - Document any issues encountered

---

## ✅ Verification & Testing

After running scripts, verify the changes:

```powershell
# Check account policies
net accounts

# Check Windows features
Get-WindowsOptionalFeature -Online | Where-Object State -eq "Disabled"

# Check services
Get-Service seclogon | Select-Object Name, StartType, Status

# Check registry - WDigest
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential

# Check registry - Autoplay
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoDriveTypeAutoRun
```

**Expected Results:**
- Account policies configured as specified
- PowerShell V2Root and SMB1Protocol disabled
- seclogon service in "Disabled" state
- WDigest UseLogonCredential = 0
- Autoplay NoDriveTypeAutoRun = 255

---

## 🐛 Troubleshooting

### "Access Denied" Error
```
ERROR: This script requires Administrator privileges!
```
**Solution:** Run PowerShell as Administrator
- Right-click PowerShell → "Run as Administrator"
- Or use `Start-Process powershell -Verb RunAs`

### Script Won't Execute
```
Cannot be loaded because running scripts is disabled on this system
```
**Solution:** Set execution policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Setting Applied But Verification Returned Unexpected Result"
**Possible Causes:**
- Regional language settings affecting output parsing
- Windows version differences
- Network connectivity issue during verification
- **Action:** Manually verify using commands above

### Some Features Already Disabled
```
PowerShell 2.0 feature not found on this system
```
**This is OK!** Script will report as already compliant and exit successfully.

---

## 📊 Security Impact Summary

| Remediation | Attack Vector Mitigated | Impact |
|-------------|------------------------|--------|
| Account Lockout (30 min) | Brute force attacks | Blocks attacker after 3 attempts for 30 min |
| Bad Logon Threshold (3) | Credential guessing | Forces immediate lockout on wrong password |
| Password History (24) | Compromised password reuse | User can't recycle old passwords |
| Max Password Age (60 days) | Long-term credential exposure | Forces password rotation |
| Min Password Length (14) | Dictionary attacks, brute force | 14 chars = 5.6 trillion+ combinations |
| Disable PowerShell 2.0 | Known PS2 exploits | Eliminates legacy attack surface |
| Disable SMB v1 | EternalBlue, WannaCry, RCE | Prevents critical ransomware propagation |
| Disable Secondary Logon | Lateral movement, privilege escalation | Blocks "Run As" abuse |
| Disable WDigest | Credential dumping (Mimikatz) | Prevents cleartext password theft |
| Disable Autoplay | Drive-by malware (USB execution) | Stops automatic code execution from media |

---

## 🔗 References

- **DISA STIGs:** https://stigaview.com/
- **Windows 11 Security Baselines:** https://learn.microsoft.com/en-us/windows/security/
- **CIS Benchmarks:** https://www.cisecurity.org/
- **Microsoft Security Documentation:** https://learn.microsoft.com/en-us/security/
- **PowerShell Documentation:** https://learn.microsoft.com/en-us/powershell/

---

## 📞 Connect With Me

- **LinkedIn:** [linkedin.com/in/justinflip/](https://linkedin.com/in/justinflip/)
- **GitHub:** [@JustinFlip](https://github.com/JustinFlip)

---

## 📋 Script Checklist

Before deploying to production:

- [ ] Reviewed all 10 scripts
- [ ] Created system backup/snapshot
- [ ] Tested in non-production environment
- [ ] Verified no critical app dependencies broken
- [ ] Planned for required system reboots
- [ ] Informed stakeholders of changes
- [ ] Have rollback procedure documented
- [ ] Reviewed verification commands
- [ ] Ready to execute remediation

---

## ⚖️ Disclaimer

These scripts modify Windows security settings and system configurations. While thoroughly tested, they should be used with caution and only by authorized personnel.

**Use at Your Own Risk:** The author assumes no liability for system damage, data loss, or operational disruption resulting from the use of these scripts. Always test in non-production environments first and maintain current backups.

---

## 📄 License

These scripts are provided as-is for security hardening and STIG compliance purposes.

---

**Version:** 1.0  
**Last Updated:** 2026-03-04  
**Target OS:** Windows 11 Pro 25H2  
**PowerShell:** 5.1+  
**Status:** Production Ready ✅

---

## 🎯 Get Started

1. Clone this repository
2. Review the README and individual script descriptions
3. Create a system backup
4. Test on a non-production VM
5. Deploy with confidence

**Happy hardening!** 🛡️
