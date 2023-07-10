# IMPORTANT: need to run following command first for once
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#
Function Get-TimeStamp {
    return "{0:MM/dd/yy} {0:HH:mm:ss}" -f (Get-Date)
}

Function Create-file {
param(
[String]$log
)
#create log file if not exist
if(![System.IO.File]::Exists($log)){
    New-Item -Path $log -ItemType "file"
}
}

##
## Send report to Infra-DevOps team
##
Function Send-report {
param(
    [Parameter(Mandatory = $true)] [String]$logFileName, 
    [Parameter(Mandatory = $true)] [String]$logFile
)

$uri = "http://localhost:8001/messages/sendmail"
$token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0cmF2ZWwycGF5LmNvbSJ9.eZry8-gg-Bn9CYv1ChyaOo_6xyzxVYf3tKrRmS_kr8s"  
$body = 
@"
{
    "username": "systemmonitor@travel2pay.com",
    "from": "systemmonitor@travel2pay.com",
    "to": ["infra@travel2pay.com", "long.dao@hrs.com", "vi.le@hrs.com", "tan.bui@hrs.com"],    
    "subject":"[Monitor] Report of failed import eml files",
    "content":"Log: https://prtg.travel2pay.com/log/$logFileName"
    
}
"@       

try {
    Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -uri $uri -Method Post -ContentType application/json -Body $body;
}
catch {            
    throw $_;
    Write-Output "$(Get-TimeStamp) | ERROR | Send report failed."  | Out-file $logFile -append
    break;
}
finally {
    Write-Output "$(Get-TimeStamp) | INFO | Send report successfully."  | Out-file $logFile -append
}
}


$logPath = "C:\Production\prtg\log\";
$logdate = Get-Date -Format "yyyyMMdd";
$logName = "monitor-problem-imported-email-platforms.txt";
$log = "$logPath\$logdate-$logName";
Create-file($log);

Send-report -logFileName $logdate-$logName -logFile $log