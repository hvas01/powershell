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
    $SubscriptionId ="Enter subscriptionID. Eg:1313fdc6-0d67-409a-8ef5-4374979e73a2",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ResourceGroupName="Enter resource group name. Eg: rg-paymenthub-prd", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $AppServiceName="Enter App Service name. Eg: webapp-paymenthub-prd"
)

Write-Output "Script starts."

# Authenticate using System Managed Identity
try
{
    Write-Output "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

# Set context to Public Production subscription
Set-AzContext -SubscriptionId $SubscriptionId 

Write-Output "Get App Service state."
$WebApp = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName

if ($WebApp.State -eq "Running") {
    Stop-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
    Write-Output "App Service stopped."
    Start-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
    Write-Output "App Service started."
}
else {
    Restart-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
    Write-Output "App Service restarted."
}

Write-Output "Script Ends."

