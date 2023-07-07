#TO DO : send email alert
$uri = "https://notification.travel2pay.com/messages/sendmail"
$token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0cmF2ZWwycGF5LmNvbSJ9.eZry8-gg-Bn9CYv1ChyaOo_6xyzxVYf3tKrRmS_kr8s"
$body = 
@"
{
    "username": "invoice@smartbilling.com",
    "from": "invoice@smartbilling.com",
    "to": ["anh.hong@hrs.com"],    
    "subject":"Test send email",
    "content":"Test send email"
}
"@       

        try {
            Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -uri $uri -Method Post -ContentType application/json -Body $body
        }
        catch {            
            #throw $_
            Write-Output "Send email failed."
            break
        }
        