<#
Trigger Data Sync
Update:
    05-Jul-2023: Change to System Managed Identity
#>

param(
[parameter(Mandatory=$true)]
[string] $resourceGroupName,

[parameter(Mandatory=$true)]
[string] $serverName,

[parameter(Mandatory=$true)]
[string] $databaseName,

[parameter(Mandatory=$true)]
[string] $SyncGroupName,

[parameter(Mandatory=$true)]
[string] $IntervalInSeconds

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

$subscriptionId = "1313fdc6-0d67-409a-8ef5-4374979e73a2"
Set-AzContext -SubscriptionId $subscriptionId

Write-Output "Set context as Public Production."

$SyncLogStartTime = Get-Date

Start-AzSqlSyncGroupSync -SyncGroupName $SyncGroupName -ServerName $serverName -DatabaseName $databaseName -ResourceGroupName $resourceGroupName

# Check the sync log and wait until the first sync succeeded
Write-Output "Check the sync log"
$IsSucceeded = $false
For ($i = 0; ($i -lt 300) -and (-not $IsSucceeded); $i = $i + 10)
{
    Start-Sleep -s 10
    $SyncLogEndTime = Get-Date
    
    $SyncLogList = Get-AzSqlSyncGroupLog -SyncGroupName $SyncGroupName `
        -StartTime $SyncLogStartTime.ToUniversalTime() `
        -EndTime $SyncLogEndTime.ToUniversalTime() `
        -ServerName $ServerName `
        -DatabaseName $DatabaseName `
        -ResourceGroupName $ResourceGroupName

    if ($SynclogList.Length -gt 0)
    {
        foreach ($SyncLog in $SyncLogList)
        {
            if ($SyncLog.Details.Contains("Sync completed successfully"))
            {
                Write-Host $SyncLog.TimeStamp : $SyncLog.Details
                $IsSucceeded = $true
            }
        }
    }
} 


if ($IsSucceeded)
{
    # Enable scheduled sync
    Write-Output "Enable the scheduled sync with 300 seconds interval"

    Update-AzSqlSyncGroup -Name $SyncGroupName `
        -IntervalInSeconds $IntervalInSeconds `
        -ServerName $ServerName `
        -DatabaseName $DatabaseName `
        -ResourceGroupName $ResourceGroupName
}
else
{
    # Output all log if sync doesn't succeed in 300 seconds
    $SyncLogEndTime = Get-Date

    $SyncLogList = Get-AzSqlSyncGroupLog -SyncGroupName $SyncGroupName `
        -StartTime $SyncLogStartTime.ToUniversalTime() `
        -EndTime $SyncLogEndTime.ToUniversalTime() `
        -ServerName $ServerName `
        -DatabaseName $DatabaseName `
        -ResourceGroupName $ResourceGroupName
    
    
    if ($SynclogList.Length -gt 0)
    {
        foreach ($SyncLog in $SyncLogList)
        {
            Write-Host $SyncLog.TimeStamp : $SyncLog.Details
        }
    }
}

Write-Output "This Script will disable auto sync and stop sync in 10 minutes"
Start-Sleep -s 600

# Stop sync manually
Write-Output "Set automatic sync OFF"

Update-AzSqlSyncGroup -Name $SyncGroupName `
        -IntervalInSeconds "-1" `
        -ServerName $ServerName `
        -DatabaseName $DatabaseName `
        -ResourceGroupName $ResourceGroupName

Write-Output "Script ends"