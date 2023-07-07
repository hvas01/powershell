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
    $SubscriptionId ="Enter subscriptionID. Eg:1313fdc6-0d67-409a-8ef5-4374979e73a2",
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ResourceGroupName="Enter resource group name. Eg: rg-tim-prd", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $ServerName="Enter SQL Server name. Eg: sqlserver-tim-prd", 
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
    [String] 
    $DatabaseName="Enter SQL database name to delete. Eg: sqldb-tim-staging"
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

# Delete database
try
{
    Write-Output "`Deleting database 'sqldb-tim-staging'"
    Remove-AzSqlDatabase 	-ResourceGroupName $ResourceGroupName `
                            -ServerName $ServerName `
                            -DatabaseName $DatabaseName
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

Write-Output "Script ends."