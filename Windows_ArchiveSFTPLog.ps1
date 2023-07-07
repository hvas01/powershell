####################################################################################################
#  Daily archive SFTP Log file (Cerberus SFTP)
#  By Anh Hong
#  This script does following actions
#
####################################################################################################

function ExportEventLog {
    param( [string] $type , 
            [string] $outputpath
     )
    # Write-Output $DBServer
    # Write-Output $Username 

    # Set log period as of yesterday
    $now = get-date
    $startdate=$now.adddays(-1)
    
    # Create output folder if not exist
    New-Item -ItemType Directory -Force -Path $outputpath

    # Output event log to csv
    $outputfile = $outputpath + $env:COMPUTERNAME + "-" + $type + "-" + $startdate.ToString("yyyyMMdd") + ".csv"
    $compressfile = $outputpath + $env:COMPUTERNAME + "-" + $type + "-" + $startdate.ToString("yyyyMMdd") + ".zip"
    $el = Get-EventLog -ComputerName $env:COMPUTERNAME -LogName  $type -After $startdate
    $el | export-csv $outputfile 

    # Compress file
    Compress-Archive $outputfile $compressfile

    # Delete Output file
    Remove-Item $outputfile 
}

$srcPath = "D:\sftpsrc\"
$dstPath = "D:\sftplog\"
$daystokeep = -1

# Get list of file to compress
$itemsToZip = dir $srcPath -Recurse -File *.log | Where LastWriteTime -lt ((get-date).AddDays($daystokeep)) 
If ($itemsToZip.Count -gt 0)
{ 
    ForEach ($item in $itemsToZip)
    { 
        # Write log file        
        "$(get-date): compress $($item.FullName) " | Write-Host #$logFile        
        $zipFile = $item.FullName + ".zip"

        # Compress the files
        Compress-Archive -Path $item.FullName -DestinationPath $zipFile -CompressionLevel Optimal | Write-Host
        
        # Remove log files older than $daystokeep
        "$(get-date): remove $($item.FullName) " | Write-Host 
        Remove-Item $item.FullName -Verbose 
    } 
} 


# Copy zip file to Azure storage


Start-Sleep -Seconds 10