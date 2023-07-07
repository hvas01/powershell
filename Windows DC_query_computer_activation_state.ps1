$ldapSearcher = new-object directoryservices.directorysearcher;
$ldapSearcher.filter = "(objectclass=computer)";
$computers = $ldapSearcher.findall();

foreach ($computer in $computers)
{
    $compname = $computer.properties["name"]
    $ping = gwmi win32_pingstatus -f "Address = '$compname'"
    $compname
    if($ping.statuscode -eq 0)
    {   
	   try
       {
            $ErrorActionPreference = "Stop"
            $wpa = Get-WmiObject -class SoftwareLicensingProduct -ComputerName $compname | Where{$_.LicenseStatus -NotMatch "0"}
                        if($wpa)
            {
                 foreach($item in $wpa)
                 {
                    $status = switch($item.LicenseStatus)
                    {
                      0 {"Unlicensed"}
                      1 {"Licensed"}
                      2 {"Out-Of-Box Grace Period"}
                      3 {"Out-Of-Tolerance Grace Period"}
                      4 {"Non-Genuine Grace Period"}
                      5 {"Notification"}
                      6 {"Extended Grace"}
                      default {"Unknown value"}
                    }
                    "Activation Status: {0}" -f $status
                 }
             }
             else
             {
                write-host ("Unlicensed")
             }
       }
       catch 
       {
            write-host ("Computer does not have SoftwareLicensingProduct class, you have insufficient rights to query the computer or the RPC server is not available")
       }
       finally
       {
            $ErrorActionPreference = "Continue"
       }

    }
    else
    {
         write-host ("Offline")
    }
    [console]::WriteLine()
}