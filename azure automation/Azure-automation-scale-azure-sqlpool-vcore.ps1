<#
Built with Powershell for Azure Automation with System-managed identity
Prerequisites
  Module: Az.Accounts, Az.SQL
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
    $SubscriptionId ="93c54646-be8d-459d-9ceb-023cd3cc0282",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ResourceGroupName="rg-tim-test", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ServerName="sqlserver-tim-test", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $PoolName="sqlpool-tim-test", 
    [Parameter(Mandatory=$true)][ValidateSet("GeneralPurpose")] 
    [String] 
    $Edition="Input GeneralPurpose is recommended", 
    [Parameter(Mandatory=$true)][ValidateSet("Gen5")] 
    [String] 
    $ComputeGeneration="Input Gen5 is recommended", 
    [Parameter(Mandatory=$true)][ValidateSet("2","4","6","8","10","12","14","16","18","20")] 
    [String] 
    $VCore="Select VCore in 2/4/6/8/10/12/14/16/18/20",
    [Parameter(Mandatory=$true)][ValidateRange(100, 1000000)] 
    [int32]
    $StorageMB=358400
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
Write-Output "Current Elastic Pool configuration:" $ep

Write-Output "Changing SQL pool SKU..."
Set-AzSqlElasticPool -ElasticPoolName $PoolName `
-Edition $Edition `
-ComputeGeneration $ComputeGeneration `
-VCore $VCore `
-DatabaseVCoreMin 0 `
-DatabaseVCoreMax $VCore `
-StorageMB $StorageMB `
-ServerName $ServerName `
-ResourceGroupName $ResourceGroupName

Write-Output "Script ends."