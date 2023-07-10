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
    $ResourceGroupName="rg-didi-test", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ServerName="sqlserver-didi-staging", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $PoolName="sqlpool-didi-test", 
    [Parameter(Mandatory=$true)][ValidateSet("Basic","Standard","Premium")] 
    [String] 
    $Edition="Standard", 
    [Parameter(Mandatory=$true)][ValidateSet("50","100","200","300","400","800","1200","1600","2000","2500","3000")] 
    [String] 
    $Dtu="50", 
    [Parameter(Mandatory=$true)][ValidateSet("50","100","200","300","400","800","1200","1600","2000","2500","3000")] 
    [String] 
    $DatabaseDtuMax="50",
    [Parameter(Mandatory=$true)][ValidateRange(100, 1000000)] 
    [int32]
    $StorageMB=200000
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
Write-Output "Current Elastic Pool configuration: `n" $ep

Write-Output "Changing Elastic Pool SKU..."
Set-AzSqlElasticPool -ElasticPoolName $PoolName `
-Edition $Edition `
-Dtu [int]$Dtu `
-DatabaseDtuMax [int]$DatabaseDtuMax `
-StorageMB $StorageMB `
-ServerName $ServerName `
-ResourceGroupName $ResourceGroupName

Write-Output "Script ends."