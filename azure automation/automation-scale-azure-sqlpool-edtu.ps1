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
    $SubscriptionId ="",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ResourceGroupName="", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ServerName="", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $PoolName="", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $Edition="", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [int32] 
    $Dtu=50, 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [int32] 
    $DatabaseDtuMax=50,
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [int32] 
    $Capacity=50,
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [int32] 
    $DatabaseCapacityMax=50,
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [int32] 
    $StorageMB=50
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

$ep = Get-AzSqlElasticPool -resourcegroupname $ResourceGroupName -serverName $ServerName -ElasticPoolName $PoolName
Write-Output "Current Elastic Pool configuration: " $ep

Set-AzSqlElasticPool -ElasticPoolName $PoolName `
-Edition $Edition `
-Dtu $Dtu `
-StorageMB $StorageMB `
-DatabaseDtuMax $DatabaseDtuMax `
-ServerName $ServerName `
-ResourceGroupName $ResourceGroupName
