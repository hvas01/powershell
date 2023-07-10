# Monitor storetimprd usage 'HTML Content sensor'
# Require: map storetimprd as network shared folder
function Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}


# Monitor Invoie in OCR and update RBES VM Scale Set instance
$logdate = Get-Date -Format "yyyyMMdd"
$log = "C:\Production\prtg\log\"+ $logdate + "-monitor-tim-storage-usage.txt"
#create log file if not exist
if(![System.IO.File]::Exists($log)){
    New-Item -Path $log -ItemType "file"
}

Write-Output "===========================================================" | Out-File $log -Append
$storetimtest = "C:\Production\prtg\storetimtest.html"
$storetimprd= "C:\Production\prtg\storetimprd.html"
$storebackupprd = "C:\Production\prtg\storebackupprd.html"

# Need to map storetimtest/data-prd as S drive first
#$psdrive = Get-PSDrive -Name S

#"<html>" | Out-File -Encoding utf8 $storetimtest
#"<body>" | Out-File -Encoding utf8 -Append $storetimtest
#"Script gives back (Disk Free %), (Free space in GB), (Used space in GB), (Total space in GB). </br>" | Out-File -Encoding utf8 -Append $storetimtest
#$diskfree = "[" + [math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used)) + "]" | Out-File -Encoding utf8 -Append $storetimtest
#"</body>" | Out-File -Encoding utf8 -Append $storetimtest
#"</html>" | Out-File -Encoding utf8 -Append $storetimtest

#Write-Output "$(Get-TimeStamp) storetimtest free: $([math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used))) %"  | Out-file $log -append

# Need to map storetimprd/data-prd as G drive first
$psdrive = Get-PSDrive -Name G
"<html>" | Out-File -Encoding utf8 $storetimprd
"<body>" | Out-File -Encoding utf8 -Append $storetimprd
"Script gives back (Disk Free %), (Free space in GB), (Used space in GB), (Total space in GB). </br>" | Out-File -Encoding utf8 -Append $storetimprd
$diskfree = "[" + [math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used)) + "]" | Out-File -Encoding utf8 -Append $storetimprd
"</body>" | Out-File -Encoding utf8 -Append $storetimprd
"</html>" | Out-File -Encoding utf8 -Append $storetimprd

Write-Output "$(Get-TimeStamp) storetimprd free: $([math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used))) %"  | Out-file $log -append

# Need to map storebackupprd/data-prd as O drive first
$psdrive = Get-PSDrive -Name O
"<html>" | Out-File -Encoding utf8 $storebackupprd
"<body>" | Out-File -Encoding utf8 -Append $storebackupprd
"Script gives back (Disk Free %), (Free space in GB), (Used space in GB), (Total space in GB). </br>" | Out-File -Encoding utf8 -Append $storebackupprd
$diskfree = "[" + [math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used)) + "]" | Out-File -Encoding utf8 -Append $storebackupprd
"</body>" | Out-File -Encoding utf8 -Append $storebackupprd
"</html>" | Out-File -Encoding utf8 -Append $storebackupprd

Write-Output "$(Get-TimeStamp) storebackupprd free: $([math]::Round($psdrive.Free * 100 / ($psdrive.Free + $psdrive.Used))) %"  | Out-file $log -append
