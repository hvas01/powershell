#TO DO : send email alert
$uri = "https://api.sendgrid.com/v3/mail/send"
$token = "xxx"
$body = 
@"
{
    "username": "anh.hong@travel2pay.com",
    "from": "anh.hong@travel2pay.com",
    "to": ["hongvuonganh@gmail.com"],    
    "subject":"Test email",
    "content":"Test email"
}
"@       

        try {
            Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -uri $uri -Method Post -ContentType application/json -Body $body
        }
        catch {            
            throw $_
            Write-Output "Send email failed."
            break
        }
        