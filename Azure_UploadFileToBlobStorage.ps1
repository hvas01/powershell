######################################
# Upload files to Blob storage       #
# Require: a secured credential file #
# Author: Anh Hong                   #
######################################


function UploadToBlobOld {
    param (
        [string] $localFile
    )

    # Setup Storage
    $StorageAccountName = "storecommondiagprd"
    $StorageAccountKey = "f3/CabOIThaGu6ZrINa4f4Tjoxc1XlDIJCpddOKF1UYqj4rmJM16or4WY4D+XkH8pBM+QunOlt9MREmkuYRWaA=="

    # Set context
    $ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

    #Get the File-Name without path
    $BlobName = (Get-Item $localFile).Name
    $ContainerName = "eventlog"

    # Upload file to Blob container
    Set-AzureStorageBlobContent -File $localFile -Container $ContainerName -Blob $BlobName -Context $ctx

}

function UploadToBlob {
    param (
        [string] $localFile
    )

    # Prepare Storage Context
    $storSas = “?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2020-02-25T18:26:21Z&st=2020-02-25T10:26:21Z&spr=https&sig=DLyODidHV4uGVpbJoocB%2BOnzckChww19uzm49TBFTI4%3D"
    $StorageAccountName = ‘storecommondiagtest’
    $containerName = “eventlog”
    $clientContext = New-AzureStorageContext -SasToken $storSAS -StorageAccountName $StorageAccountName
    Get-AzureStorageBlob -Container $containerName -Context $ClientContext
   
    
    #Get the File-Name without path
    $BlobName = (Get-Item $localFile).Name
    $ContainerName = "eventlog"

    # Upload file to Blob container
    Set-AzureStorageBlobContent -File $localFile -Container $ContainerName -Blob $BlobName -Context $ClientContext

}

$uploadfile = "D:\eventlog\T2P-CPU016-Application-20200217.zip"

# Prepare Storage Context
    $storSas = “?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2020-02-25T18:26:21Z&st=2020-02-25T10:26:21Z&spr=https&sig=DLyODidHV4uGVpbJoocB%2BOnzckChww19uzm49TBFTI4%3D"
    $StorageAccountName = ‘storecommondiagtest’
    $containerName = “eventlog”
    $clientContext = New-AzureStorageContext -SasToken $storSAS -StorageAccountName $StorageAccountName
    Get-AzureStorageBlob -Container $containerName -Context $ClientContext