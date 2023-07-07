# Get the ID and security principal of the current user account  
Function WaitForExit 
{ 
Echo "`nPress 'Q/q' key to exit ..."  
while($true)  
{      
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
    if(($($x.Character) -eq "q") -or ($($x.Character) -eq "Q"))  
    {  
        exit 
    }  
} 
} 
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()  
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)  
# Get the security principal for the Administrator role  
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator  
# Check to see if we are currently running "as Administrator"  
if ($myWindowsPrincipal.IsInRole($adminRole))  
   {  
   # We are running "as Administrator" - so change the title and background color to indicate this  
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"  
   #$Host.UI.RawUI.BackgroundColor = "DarkBlue"  
   clear-host  
echo "`nMicrosoft Azure VM Backup - File Recovery" 
echo "______________________________________________" 
$OSVersion=[environment]::OSVersion.Version 
$isServer2008R2=$false 
if(($($OSVersion.Major) -eq 6) -and ($($OSVersion.Minor) -eq 1)) 
{ 
   $isServer2008R2=$true 
   $OSName="Windows" 
} 
elseif (($($OSVersion.Major) -gt 6) -or (($($OSVersion.Major) -eq 6) -and ($($OSVersion.Minor) -gt 1))) 
{ 
   $isServer2008R2=$false 
   $OSName=(Get-CimInstance Win32_OperatingSystem).Caption.Replace(" ","") 
} 
else 
{ 
   Echo "This OS Version is not supported" 
} 
$VMName="vm-web1-prd" 
$MachineName="vm-web1-prd" 
$TargetPortalAddress ="pod01-rec2.gec.backup.windowsazure.de" 
$TargetPortalPortNumber =3260
$SequenceNumber ="164946509322"
$TargetUserName ="$OSName;$OSVersion;2941435164372385773-2ff697a9-b543-45a5-b22f-8c828ab1dc28" 
$TargetPassword ="70d717a9e2daec2" 
$InitiatorChapPassword ="877830910f0b5d" 
$ScriptId="7549239f-fcb8-44df-a394-b0f4b4dbc985" 
$CurrentDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)  
$time=(get-date).tostring("yyyyMMddHHssmm") 
$FolderName="$VMName-$time" 
$FolderPath="$CurrentDir\$FolderName"  
$Logfile = $FolderPath + "\MicrosoftAzureBackupILRLogFile.log"  
$IsMultitarget = 0
Function LogWrite  
{  
   Param ([string]$logstring)  
   $Timestamp=Get-Date  
   $logdata="[$Timestamp] :" + $logstring  
   Add-content  $Logfile -value $logdata  
}  
try  
{  
    $Folder=Get-Item -Path $FolderPath -ErrorAction stop  
}  
catch  
{  
    $Folder=New-Item -Name $FolderName -Path $CurrentDir -ItemType directory  
}  
try  
{  
    # Remove inheritance  
    $acl = Get-Acl $FolderPath  
    $acl.SetAccessRuleProtection($true,$true)  
    Set-Acl $FolderPath $acl  
    # Remove ACL  
    $acl = Get-Acl $FolderPath  
    $acl.Access | %{$acl.RemoveAccessRule($_)} | Out-Null  
    # Add local admin  
    $permission  = "BUILTIN\Administrators","FullControl", "ContainerInherit,ObjectInherit","None","Allow"  
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission  
    $acl.SetAccessRule($rule)  
    Set-Acl $FolderPath $acl  
}  
catch  
{  
    LogWrite "Exception Details: $ErrorMessage, $FailedItem"  
    LogWrite "Failed to ACL Local Folder"  
}  
if($isServer2008R2 -eq $true) 
{ 
$wc = New-Object System.Net.WebClient 
$wc.DownloadFile("https://download.microsoft.com/download/0/B/4/0B4C4191-DF3C-4142-9616-7234980B4777/WindowsPowershellISCSIScriptForILR.ps1", "$FolderPath\WindowsPowershellISCSIScriptForILR.ps1") 
    $wc = New-Object System.Net.WebClient 
$wc.DownloadFile("https://download.microsoft.com/download/0/B/4/0B4C4191-DF3C-4142-9616-7234980B4777/SecureTCPTunnel.exe", "$FolderPath\SecureTCPTunnel.exe") 
} 
else 
{ 
   $output=Invoke-WebRequest -Uri "https://download.microsoft.com/download/0/B/4/0B4C4191-DF3C-4142-9616-7234980B4777/WindowsPowershellISCSIScriptForILR.ps1" -OutFile "$FolderPath\WindowsPowershellISCSIScriptForILR.ps1"   
   $output=Invoke-WebRequest -Uri "https://download.microsoft.com/download/0/B/4/0B4C4191-DF3C-4142-9616-7234980B4777/SecureTCPTunnel.exe" -OutFile "$FolderPath\SecureTCPTunnel.exe"   
} 
if((![System.IO.File]::Exists("$FolderPath\WindowsPowershellISCSIScriptForILR.ps1")) -or (![System.IO.File]::Exists("$FolderPath\SecureTCPTunnel.exe"))) 
{ 
    Echo "`Unable to access the recovery point. Please make sure that you have enabled access to Azure public IP addresses on the outbound port 3260 and 'https://download.microsoft.com/'" 
    WaitForExit             
} 
if($EnableILRRetries -eq "1")
{ 
    powershell.exe -File "$FolderPath\WindowsPowershellISCSIScriptForILR.ps1" "$VMName" "$MachineName" "$OSName" "$OSVersion" $isServer2008R2 "$FolderPath" "$Logfile" "$TargetPortalAddress" "$TargetPortalPortNumber" "$TargetUserName" "$TargetPassword" "$InitiatorChapPassword" "$ScriptId" "$SequenceNumber" "$IsMultitarget" 
} 
else
{ 
    powershell.exe -File "$FolderPath\WindowsPowershellISCSIScriptForILR.ps1" "$VMName" "$MachineName" "$OSName" "$OSVersion" $isServer2008R2 "$FolderPath" "$Logfile" "$TargetPortalAddress" "$TargetPortalPortNumber" "$TargetUserName" "$TargetPassword" "$InitiatorChapPassword" "$ScriptId" "$SequenceNumber" 
} 
exit 
   }  
   else  
   {  
   # We are not running "as Administrator" - so relaunch as administrator  
   # Create a new process object that starts PowerShell  
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";  
   # Specify the current script path and name as a parameter  
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;  
   # Indicate that the process should be elevated  
   $newProcess.Verb = "runas";  
   # Start the new process  
   $process=[System.Diagnostics.Process]::Start($newProcess);  
   Start-Sleep -Seconds 2  
   if($($process.ExitCode) -eq 1)  
   {  
           Echo "`nThe script should be run in elevated mode. Please right-click on the file and choose `"Run as administrator`."  
           WaitForExit 
   }  
   # Exit from the current, unelevated, process  
   }  
