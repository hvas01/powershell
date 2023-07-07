<#
This scripts is used to export windows even log of yesterday to csv and compress for archiving.
Usage
  Save this ps1 to a local folder
  Add new windows scheduler 
    Action: start a program
    Program/script: powershell.exe
    Add argument: -ExecutionPolicy Bypass [path to ps1] > [path to log file optional]
License
  Anh: Still not think about this ^_^
Contact
  anh.hong@hrs.com
  hongvuonganh@gmail.com
  https://github.com/hvas01
#>


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




$outputpath = "D:\eventlog\"

$type = "Application"
ExportEventLog -type $type -outputpath $outputpath

$type = "System"
ExportEventLog -type $type -outputpath $outputpath

$type = "Security"
ExportEventLog -type $type -outputpath $outputpath
