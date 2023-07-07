
# Set context to DE Production
Set-AzureRmContext -Subscription 458b5608-0edf-48ee-90c5-cfe2540a895d

$ctx = New-AzureStorageContext tempstoreazuredc01prd wZkT4zTECmgBUV//62yfM/K2y1LQffqv2gVjqQYb2Q0Tn8JZbil4IpGtB1Fu3RVnhQS6xf3NESyg3U9JDw5yiA==
##sharename is your existed name.

##To download a file from the share to the local computer, use Get-AzureStorageFileContent.

#$sharedname = "data-prd"
#Get-AzureStorageFileContent –Sharename $sharedname –Path "\\testingstore.file.core.cloudapi.de\data-prd\HRS\Invoice_Image\20200214\ff346133-17ed-495e-bfcf-b472d9fdb894.pdf" 


$shared = Get-AzureStorageShare –Context $ctx
Get-AzureStorageFileContent –Share $shared –Path "https://testingstore.file.core.cloudapi.de/data-prd/HRS/new.txt" 
#\\testingstore.file.core.cloudapi.de\