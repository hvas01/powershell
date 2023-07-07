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

param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] $SubscriptionId ="Enter subscriptionID. Eg:1313fdc6-0d67-409a-8ef5-4374979e73a2",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] $ResourceGroupName="Enter resource group name. Eg: rg-tim-prd", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] $ServerName="Enter SQL server name. Eg: sqlserver-tim-prd", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] $DatabaseName="Enter SQL database name to delete. Eg: sqldb-tim-staging",
    [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
    [string] $edition="Enter edition:Basic/Standard/Premium",
    [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
    [string] $serviceName="Enter service:Basic/S0/S1/S2/S3/S4/S6/S7/S9/S12/P1/P2/P4/P6/P11/P15"
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

# Set context to Subscription
Set-AzContext -SubscriptionId $SubscriptionId 

# Get target database
$database = Get-AzSqlDatabase -DatabaseName $databaseName `
    -ServerName $serverName `
    -ResourceGroupName $resourceGroupName

Write-Output "Current SKU:" $database.SkuName $database.RequestedServiceObjectiveName
Write-Output "Changing SKU..."

# Scale the database performance
$database = Set-AzSqlDatabase -DatabaseName $databaseName `
    -Edition $edition `
    -RequestedServiceObjectiveName $serviceName `
    -ServerName $serverName `
    -ResourceGroupName $resourceGroupName

Write-Output "New SKU:" $database.SkuName $database.RequestedServiceObjectiveName

Write-Output "Script ends."