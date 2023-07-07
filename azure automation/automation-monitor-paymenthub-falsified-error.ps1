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
$subscriptionId = "1313fdc6-0d67-409a-8ef5-4374979e73a2"
Set-AzContext -SubscriptionId $subscriptionId

$resourceGroupName = "rg-tim-prd"
$storageAccName = "storetimprd"
$fileShareName = "data-prd"
$exportPath = $env:TEMP
$context=(Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName).Context  


#Download Payment Hub log file and ErrorCount
$CountErrorURL = "https://storetimprd.blob.core.windows.net/monitor-paymenthub-falsified-error/counterror.txt"
$CountErrorFile = "counterror.txt"
Invoke-WebRequest -Uri $CountErrorURL -OutFile $CountErrorFile
foreach($line in (Get-Content $CountErrorFile)) {
    $LastCountError = $line -as [int]    
}

Write-Output "Last No. Error: $($LastCountError)" 

#Download Payment Hub log file
$datestring = (get-date).ToString("yyyyMMdd")
$PHLogURL = "https://paymenthub.smartbilling.com/interface/soap/logs/" + $datestring + ".txt"
$PHLogFile = $datestring

Invoke-WebRequest -Uri $PHLogURL -OutFile $PHLogFile

$ErrorPattern = "<faultstring>Policy Falsified</faultstring>"
$CountError = (@( Get-Content $PHLogFile | Where-Object { $_.Contains($ErrorPattern) } ).Count)/2

Write-Output "Payment Hub log file: $($PHLogFile)"
Write-Output "Today No. Error: $($CountError)"

#Check error and send alert email
if ($CountError -eq 0) {
    $CountError | Out-File -FilePath $CountErrorFile    
    Write-Output "No Policy Falsified error found. Update counterror.txt"
    Set-AzStorageBlobContent -File $CountErrorFile -Container "monitor-paymenthub-falsified-error" -Context $context -Force
}
else {
    if ($CountError -eq $LastCountError) {
        Write-Output "Same error count. Do nothing. Email should be sent ealier."
    }
    else {
        Write-Output "Different error count. Prepare to send email and update error count file."
        #TODO restart App Service
        $ResourceGroupName = "rg-paymenthub-prd"
        $AppServiceName = "webapp-paymenthub-prd"

        $WebApp = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName

        if ($WebApp.State -eq "Running") {
            #Stop-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
            Write-Output "App Service stopped."
            #Start-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
            Write-Output "App Service started."
        }
        else {
            #Restart-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppServiceName
            Write-Output "App Service restarted."
        }


        #TO DO : send email alert
        $uri = "https://notification.travel2pay.com/messages/sendmail"
        $token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0cmF2ZWwycGF5LmNvbSJ9.eZry8-gg-Bn9CYv1ChyaOo_6xyzxVYf3tKrRmS_kr8s"
$body = 
@"
{
    "username": "systemmonitor@travel2pay.com",
    "from": "systemmonitor@travel2pay.com",
    "to": ["infra@travel2pay.com", "oanh.pham@hrs.com", "khoi.vu@hrs.com"],    
    "subject":"[Monitor] PaymentHub Falsified Policy error",
    "content":"Number of Falsified Policy error: $($CountError)"
}
"@       

        try {
            #Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -uri $uri -Method Post -ContentType application/json -Body $body
        }
        catch {            
            #throw $_
            Write-Output "Fail to send email."
            break
        }
        
        #Logging
        Write-Output "Email has been sent."
        $CountError | Out-File -FilePath $CountErrorFile
        Set-AzStorageBlobContent -File $CountErrorFile -Container "monitor-paymenthub-falsified-error" -Context $context -Force
        Write-Output "Error count number has been updated."
        
        
    }  
}

Write-Output "Script ends."

