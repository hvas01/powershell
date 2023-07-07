$EmailFrom = “systemmonitor@travel2pay.com”
$EmailTo = “anh.hong@hrs.com”
$Subject = “Test smtp”
$Body = “Test smtp”
$SMTPServer = “smtp.office365.com”
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("invoice1@hrs.com", "A36PaXD92t$h");
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("systemmonitor@travel2pay.com", "HJs7!!FCF!7c!");
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)