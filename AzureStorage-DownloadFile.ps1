# 1. Enable execute scripts in Windows 10
# > Get-ExecutionPolicy # get status
# > Set-ExecutionPolicy RemoteSigned
# 2. Change Tls powershell version to download package
# > $TLS1012Protocol = [System.Net.SecurityProtocolType] 'Tls, Tls11, Tls12'
# > [System.Net.ServicePointManager]::SecurityProtocol = $TLS1012Protocol
# 3. Install psexcel module
# > Install-Module -Name PSExcel

# ============================== Mapping storetimprd to drive M ==============================
$connectTestResult = Test-NetConnection -ComputerName storetimprd.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"storetimprd.file.core.windows.net`" /user:`"localhost\storetimprd`" /pass:`"0ag17tELVlty8Xpn2jJrV34AH8QphE07ITzmNFJj03aNkIyHaWtXsyHdldtmKxcOpIvDQWkXy8H5gcc/dxktrw==`""
    # Mount the drive
    New-PSDrive -Name M -PSProvider FileSystem -Root "\\storetimprd.file.core.windows.net\data-prd" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
# ============================================================================================



# ============================ Mapping storebackupprd to drive N =============================
$connectTestResult = Test-NetConnection -ComputerName storebackupprd.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"storebackupprd.file.core.windows.net`" /user:`"localhost\storebackupprd`" /pass:`"3DaWk9bDTfem3FQ5c3ObsYIy7E+TM3sZZu9O+K/9cw6Cqy9abo5upwEhnPJYvJnz+lw9dotsBSGQmmDNLYJmqQ==`""
    # Mount the drive
    New-PSDrive -Name N -PSProvider FileSystem -Root "\\storebackupprd.file.core.windows.net\data-prd" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
# ============================================================================================



# ==================================== Copy (Move) Files =====================================
$path = "$PSScriptRoot\AzureStorage-EditFiles.xlsx"

import-module psexcel #it wasn't auto loading on my machine

$records = new-object System.Collections.ArrayList

$result=foreach ($records in (Import-XLSX -Path $path -RowStart 2))
{
    # Check Dst folder exist , if not create it
    $dstFolder = $records.Dstfolder
    $srcFile = $records.SrcFullPath

    If(!(test-path $dstFolder))
    {
        New-Item -ItemType Directory -Force -Path $records.Dstfolder
    }

    #Download file
    Copy-Item $srcFile -Destination $dstFolder 
	
}

# Kill Excel process
kill -processname EXCEL

# ============================================================================================



# =================================Force disconnect drive M,N ================================
Remove-PSDrive M,N -Force -Verbose 
# ============================================================================================




