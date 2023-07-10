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

Function Resend-problematic-emails
{
param(
    [Parameter(Mandatory = $true)] [String]$PlatformName, 
    [Parameter(Mandatory = $true)] [String]$PlatformBasePath,
    [Parameter(Mandatory = $true)] [int]$ScanFlag,
    [Parameter(Mandatory = $true)] [String]$logFile
)

#Write-Output "$(Get-TimeStamp) Platform:$PlatformName"  | Out-file $logFile -append
#Write-Output "$(Get-TimeStamp) Platform base path:$PlatformBasePath "  | Out-file $logFile -append
#Write-Output "$(Get-TimeStamp) Scan flag:$ScanFlag"  | Out-file $logFile -append

$ListEmls = @()
if ($ScanFlag -eq 1)
{
#Get emls in Error, Timeout, NotProcess folder
#Write-Output "$(Get-TimeStamp) Scan for emls in Error, Timeout, NotProcess folders"  | Out-file $logFile -append

if ($PlatformName -eq "DeutscheBahn" ) {
    $ErrorPath = "$PlatformBasePath\$PlatformName\Error"
} else {
    $ErrorPath = "$PlatformBasePath\$PlatformName\$PlatformName" + "_Processing\Error"
}

$TimeOutPath = "$PlatformBasePath\$PlatformName\TimeOut"
$NotProcessPath = "$PlatformBasePath\$PlatformName\NotProcess"

#Write-Output "$(Get-TimeStamp) Scan path:$ErrorPath"  | Out-file $logFile -append
Get-ChildItem -Path $ErrorPath -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".eml" } | foreach { $ListEmls += $_.FullName }

#Write-Output "$(Get-TimeStamp) Scan path:$TimeOutPath"  | Out-file $logFile -append
Get-ChildItem -Path $TimeOutPath -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".eml" } | foreach { $ListEmls += $_.FullName }

#Write-Output "$(Get-TimeStamp) Scan path:$NotProcessPath"  | Out-file $logFile -append
Get-ChildItem -Path $NotProcessPath -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".eml" } | foreach { $ListEmls += $_.FullName }
}

if ($ListEmls.Count -gt 0) 
{   
    #Logging
    Write-Output "$(Get-TimeStamp) | INFO | Found problematic eml files of $PlatformName. Prepare to send email."  | Out-file $logFile -append
    
    ForEach ($eml in $ListEmls) { 

        $uri = "http://localhost:8001/messages/sendmail"
        #$uri = "https://notification.travel2pay.com/messages/sendmail"
        $token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0cmF2ZWwycGF5LmNvbSJ9.eZry8-gg-Bn9CYv1ChyaOo_6xyzxVYf3tKrRmS_kr8s"
        
        # Encode
        $emlfilename = Split-Path $eml -Leaf 
        $Encoded = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($eml))

$body = 
@"
{
    "username": "systemmonitor@travel2pay.com",
    "from": "systemmonitor@travel2pay.com",
    "to": ["mai.ngo@hrs.com", "linh.dinh@hrs.com", "anh.nguyen@hrs.com", "huyen.truong@hrs.com", "trang.vu@hrs.com"],    
    "subject":"($PlatformName) Problem email",
    "content":"Nho Team import lai giup email ($PlatformName) nay nha",
    "listAttachments":[
    {
        "name": "$($emlfilename)",
        "base64Content" : "$($Encoded)"
    }
    ]
}
"@       

        try {
            Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -uri $uri -Method Post -ContentType application/json -Body $body
        }

        catch {            
            throw $_
            Write-Output "$(Get-TimeStamp) | ERROR | Send email failed."  | Out-file $logFile -append
            break
        }
                  
        
        #Logging
        Write-Output "$(Get-TimeStamp) | INFO | Sent file:$emlfilename"  | Out-file $logFile -append

        #TOBE delete email
        Remove-Item -Path $eml
    }
}
}


$logPath = "C:\Production\prtg\log\";
$logdate = Get-Date -Format "yyyyMMdd";
$logName = "monitor-problem-imported-email-platforms.txt";
$log = "$logPath\$logdate-$logName";
Create-file($log);

Write-Output "$(Get-TimeStamp) | INFO | Start task."  | Out-file $log -append;

##### HRS ######
$PlatformName = "HRS";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### BCD ######
$PlatformName = "BCD";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### HDE ######
$PlatformName = "HDE";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### Cytric ######
$PlatformName = "Cytric";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### Meeting ######
$PlatformName = "Meeting";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### Offline ######
$PlatformName = "Offline";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

##### DeutscheBahn ######
$PlatformName = "DeutscheBahn";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail_DB";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;


##### TESTING ONLY ######
$PlatformName = "TestOnly";
$PlatformBasePath = "\\storetimprd.file.core.windows.net\data-prd\Notification\DownloadedEmail";
$ScanFlag = 1;
Resend-problematic-emails $PlatformName $PlatformBasePath $ScanFlag $log;

Write-Output "$(Get-TimeStamp) | INFO | End task."  | Out-file $log -append;

