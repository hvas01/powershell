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
    $StorageAccountKey = "Storage Account Key"

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
    $storSas = “SAS"
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
    $storSas = “SAS"
    $StorageAccountName = ‘storecommondiagtest’
    $containerName = “eventlog”
    $clientContext = New-AzureStorageContext -SasToken $storSAS -StorageAccountName $StorageAccountName
    Get-AzureStorageBlob -Container $containerName -Context $ClientContext