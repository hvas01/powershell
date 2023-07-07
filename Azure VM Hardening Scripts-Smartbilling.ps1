##########
# AZURE VM HARDENING SCRIPT
# VERSION: v0.1 by HVA
# DATE: 22.04.2021
# NOTE: THIS SCRIPT IS PREPARED IN ACCORDANCE WITH AZURE VM VULNERABILITY SCAN VIA SECURITY CENTER
#       MAKE SURE YOU READ THIS SCRIPT CAREFULLY BEFORE RUNNING IT + ADJUST COMMENTING AS APPROPRIATE
#       This script will reboot your machine when completed.
##########


# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}



##########
# Local category
##########


##########
# Security Policy category
##########

 Write-Host "Disabling Autoplay..."
 Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
# Enable Autoplay
# Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
 
 Write-Host "Fix 105170-Microsoft Windows Explorer AutoPlay Not Disabled"
 If (!(Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
   New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
 Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

# QID-90043 - SMB Signing Disabled or SMB Signing Not Required
# HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters enablesecuritysignature = 1
# HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters requiresecuritysignature = 1
# Added 01.09.2021 by Anh Hong 
 Write-Host "Fix 90043 - SMB Signing Disabled or SMB Signing Not Required"
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "enablesecuritysignature" -Type DWord -Value 1
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "requiresecuritysignature" -Type DWord -Value 1
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Name "enablesecuritysignature" -Type DWord -Value 1
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Name "requiresecuritysignature" -Type DWord -Value 1


##########
# Windows category
##########

 Write-Host "Fix 90007-Enabled Cached Logon Credential"
 $ValueCachedLogonCredential = "0"
 Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows Nt\CurrentVersion\Winlogon" -Name "CachedLogonsCount" -Value $ValueCachedLogonCredential

 #To disable or restrict null session
 Write-Host "Fix 90044-Allowed Null Session"
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess" -Value 1
 Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "restrictanonymous" -Value 1

 #To prevent globally socket hijacking
 Write-Host "Preventing globally socket hijacking..."
 Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\Afd\Parameters" -Name "DisableAddressSharing" -Value 1

 #105228-Built-in Guest Account Not Renamed
 Write-Host "Fix 105228-Built-in Guest Account Not Renamed at Windows Target System"
 $GuestName = "Guest"

##########
# Internet Explorer category
##########
 
 # IE threat CVE-2017-8529
 Write-Host "Preventing IE threat CVE-2017-8529..."
 If (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX")) {
   New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX" | Out-Null
}
 Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX" -Name "iexplore.exe" -Type DWord -Value 1