<#
Update Sku Capacity of an Virtual Machine Scale Set

Usecase:
$subscriptionID = "1313fdc6-0d67-409a-8ef5-4374979e73a2"
$resourceGroup = "rg-ocr-prd"

Use a scheduler Powershell script to retrieve number of invoice in OCR queue and trigger this runbook to update Sku Capacity accordingly.

.NOTES
    Author: Anh Hong
    Update:
        10-Mar-2023 - Update VMSS instances
        05-Jul-2023 - Change to Azure System Managed Identity
#>

$subscriptionId="1313fdc6-0d67-409a-8ef5-4374979e73a2"
$resourceGroupName="rg-ocr-prd"
$vmssName="vsResSugSlpPrd"
$queueName="InvoiceXMLProduction"
$skuCapacity=0

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

Write-Output "Querying number of Message Ready from rabbitmq ......"

$rbmqUrl = "https://monitor-rbmq.travel2pay.com/api/v1/rabbitmq/"

$Params = @{
    "URI"    = $rbmqUrl + $queueName + "/count"
} 
$response = Invoke-RestMethod @Params
$msgReady = $response.messages

$skuCapacity = 3
If ([int]$msgReady -lt 5) { 
    $skuCapacity = 1
}
ElseIf ([int]$msgReady -lt 100) { 
    $skuCapacity = 2
}
ElseIf ([int]$msgReady -lt 300) { 
    $skuCapacity = 3
}
Else { 
    $skuCapacity = 4
}

Write-Output "Ready messages in queue $queueName : $msgReady"
Write-Output "Setting instance of $vmssName to: $skuCapacity ......"

$vmss = Get-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName

if ($skuCapacity -ne $vmss.Sku.Capacity) {
    Write-Output "Current instances : $($vmss.Sku.Capacity)"
    $vmss = Update-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName -SkuCapacity $skuCapacity
    $vmss = Get-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName
    Write-Output "New instances: $($vmss.Sku.Capacity)"
}
else {
    Write-Output "Current Sku is sufficient. Do nothing."
}

Write-Output "Script ends."