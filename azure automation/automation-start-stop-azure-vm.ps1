#############################################################################
# Built with Powershell for Azure Automation with System-managed identity
# Prerequisites
#   Module: Az suite (Az.Accounts, Az.Compute, Az.SQL, Az.Websites)
# Usage
#   Add new Azure Automation Powershell runbook
# Roadmap
#   Switch to User-managed identity
# License
#   Anh: Still not think about this ^_^
# Contact
#   anh.hong@hrs.com
#   hongvuonganh@gmail.com
#   https://github.com/hvas01
#############################################################################

Param
(   
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $SubscriptionId="",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $AzureVMList="", 
    [Parameter(Mandatory=$true)][ValidateSet("Start","Stop")] 
    [String] 
    $Action 
)

Write-Output "Script starts."

# Connect to Azure using System-assigned managed identity
try
{
    Write-Output "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
Write-Error -Message $_.Exception
throw $_.Exception
}    

# Set context to subscription
Set-AzContext -SubscriptionId $SubscriptionId

if($AzureVMList -ne "") 
{ 
    $AzureVMs = $AzureVMList.Split(",") 
    [System.Collections.ArrayList]$AzureVMsToHandle = $AzureVMs 
} 
else 
{ 
    #To Do: if empty ??? or just leave it as it is ^_^
}

foreach($AzureVM in $AzureVMsToHandle) 
{ 
    if(!(Get-AzVM | ? {$_.Name -eq $AzureVM})) 
    { 
        throw " AzureVM : [$AzureVM] - Does not exist! - Check your inputs " 
    } 
} 
    
if($Action -eq "Stop") 
{             
    foreach ($AzureVM in $AzureVMsToHandle) 
    { 
        Write-Output "Stopping [$AzureVM]"
        Get-AzVM | ? {$_.Name -eq $AzureVM} | Stop-AzVM -Force 
    } 
} 
else 
{         
    foreach ($AzureVM in $AzureVMsToHandle) 
    { 
        Write-Output "Starting [$AzureVM]"
        Get-AzVM | ? {$_.Name -eq $AzureVM} | Start-AzVM 
    } 
}

Write-Output "Script ends."