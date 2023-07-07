#################################################################
# Upload files to Blob storage using AZCopy with SAS token      #
# Require: a secured credential file                            #
# Author: Anh Hong                                              #
#################################################################

#azcopy copy '<local-file-path>' 'https://<storage-account-name>.<blob or dfs>.core.windows.net/<container-name>/<blob-name>'



$SrcFile = 'D:\eventlog\T2P-CPU016-Application-20200217.zip'

#Get the File-Name without path
$Url = 'https://storecommondiagtest.blob.core.windows.net/'
$ContainerName = 'eventlog'
$BlobName = (Get-Item $UploadFile).Name

$DstFile = 'https://storecommondiagtest.blob.core.windows.net/' + $ContainerName + "/" + $BlobName
$SAS = '?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2020-02-25T19:23:53Z&st=2020-02-25T11:23:53Z&spr=https&sig=I8de9rR61ZyEg0MExf905Hz%2BJvWCLCee%2BFOZPTeOVtM%3D'

$DstFileSAS = $DstFile + $SAS

#.\azcopy.exe copy /Source:D:\eventlog /Dest:https://storecommondiagtest.blob.core.windows.net/eventlog /DestKey:4NJ2C5o6PGqjFW/VP4o7mLrauUmEMBf1epQzMKh3/BuZexxslk8fAK/7aH9E22svCIXIwlgE4XemUQ27m6169w== /Pattern:$BlobName
.\azcopy.exe cp $SrcFile $DstFileSAS