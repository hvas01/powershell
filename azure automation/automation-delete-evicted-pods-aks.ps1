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
    $subscriptionId ="",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ResourceGroupName ="", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ClusterName =""
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

# Set context to subscription
Set-AzContext -SubscriptionId $subscriptionId

Write-Output "`nDeleting evicted pods in cluster $ClusterName"
Invoke-AzAksRunCommand 	-ResourceGroupName ResourceGroupName `
						-Name $ClusterName `
						-Command "kubectl delete pods --all-namespaces=true --field-selector 'status.phase==Failed'" `
						-force

Write-Output "Script ends."