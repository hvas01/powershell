<#
Built with Powershell for Azure Automation with System-managed identity
Prerequisites
  Module: Az.Accounts, Az.Aks
  Usage
    Add new Azure Automation runbook Powershell 5.1 with the following scripts content
    Add new scheduler as required
    Link runbook with scheduler to complete 
  Roadmap
    Switch to User-managed identity
  License
    Anh: Still not think about this ^_^
  Contact
    anh.hong@hrs.com
    hongvuonganh@gmail.com
    https://github.com/hvas01
#>

Param
(   
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $SubscriptionId ="",
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
Set-AzContext -SubscriptionId $SubscriptionId

Write-Output "`nDeleting evicted pods in cluster $ClusterName ..."
$result = Invoke-AzAksRunCommand 	-ResourceGroupName $ResourceGroupName `
						-Name $ClusterName `
						-Command "kubectl delete pods --all-namespaces=true --field-selector 'status.phase==Failed'" `
						-force

if ($result.value.Message -like '*error*') 
{  
    Write-Output "Failed. An error occurred: `n $($result.value.Message)" | Out-File -Filepath C:\OutputLog.txt -Append
    throw $($result.value.Message)        
}

Write-Output "Script ends."