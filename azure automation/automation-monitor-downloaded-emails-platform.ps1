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

# Counting for HRS platform
$exportFileName = "hrs.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\HRS\HRS_Processing"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HRS\HRS_Processing\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HRS\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HRS\HRS_Processing\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for HRS"

# Counting for BCD platform
$exportFileName = "bcd.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\BCD\BCD_Processing"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\BCD\BCD_Processing\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\BCD\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\BCD\BCD_Processing\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for BCD"

# Counting for Cytric platform
$exportFileName = "Cytric.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\Cytric\Cytric_Processing"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Cytric\Cytric_Processing\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Cytric\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Cytric\Cytric_Processing\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for Cytric"

# Counting for Onesto platform
$exportFileName = "Onesto.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\DeutscheBahn"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Count problem emails for DB Onesto"

# Counting for HDE platform
$exportFileName = "HDE.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\HDE\HDE_Processing"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HDE\HDE_Processing\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HDE\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\HDE\HDE_Processing\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for HDE"

# Counting for Meeting platform
$exportFileName = "Meeting.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\Meeting\Meeting_Processing"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Meeting\Meeting_Processing\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Meeting\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\Meeting\Meeting_Processing\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for Meeting"

# Counting for DB platform
$exportFileName = "DeutscheBahn.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back (Number of downloaded emails), (error emails), (notprocess emails), (timeout emails). </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmailDB\DeutscheBahn"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmailDB\DeutscheBahn\error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmailDB\DeutscheBahn\notprocess"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmailDB\DeutscheBahn\timeout"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for DeutscheBahn"

# Counting for CIG platform
$exportFileName = "cig.html"
$exportFile = New-Item -ItemType File -Name $exportFileName
"<html>" | Out-File -Encoding utf8 $exportFile
"<body>" | Out-File -Encoding utf8 -Append $exportFile
"Script gives back error emails of aldi,btc,FIDUCIA,inconso,octapharma,railtours,reiseservice,s-servicepartner,TUEV-NORD,tuvrheinland . </br>" | Out-File -Encoding utf8 -Append $exportFile

$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\aldi.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\btc.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\FIDUCIA.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\inconso@travel2pay.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\octapharma.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\railtours.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\reiseservice.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\s-servicepartner.invoice@smartbilling.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\TUEV-NORD@travel2pay.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile
$path = "Notification\DownloadedEmail\DeutscheBahn\CIG\tuvrheinland@travel2pay.com\Error"
$content=Get-AZStorageFile -Context $context -ShareName $fileShareName -Path $path | Get-AZStorageFile
"[$($content.count)]" | Out-File -Encoding utf8 -Append $exportFile

"</body>" | Out-File -Encoding utf8 -Append $exportFile
"</html>" | Out-File -Encoding utf8 -Append $exportFile

Set-AzStorageBlobContent -File $exportFile -Container "monitor-downloaded-email" -Context $context -Force
Write-Output "Finish updating counting emails for CIG"

Write-Output "Script ends."