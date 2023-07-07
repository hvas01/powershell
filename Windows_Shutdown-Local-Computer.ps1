Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@

$exclusion = @(
    "DC-Development",
    "dc02",
    "Server-01",
    "DinhTienHoang",
    "T2P-CPU016"
)

$LastInput = [PInvoke.Win32.UserInput]::LastInput
$IdleTime = [PInvoke.Win32.UserInput]::IdleTime
$Idle = $IdleTime.TotalMinutes
$log = "$env:TEMP\T2P-util-shutdown-pc.log"

If(!(Test-Path $log -PathType leaf))
{
      New-Item -ItemType "file" -Path "$log"
}
Clear-Content $log

#"" | Out-File $log -Append
"T2P scheduler shutting down local computer." | Out-File $log -Append
"Current time : $(Get-Date)" | Out-File $log -Append
"Idle time (m): $Idle" | Out-File $log -Append

if ($exclusion -contains $env:computername) { 
    "Computer in exclusion list. Shutdown is denied." | Out-File $log -Append
}
else {
    if ($Idle -gt 120) {
        "Idle time more than 120 minutes" | Out-File $log -Append
        "Start shutting down computer" | Out-File $log -Append
        Clear-Host | Out-File $log -Append
        #Stop-Computer -Force | Out-File $log -Append
        "Computer shutdown!" | Out-File $log -Append
    }
    else {
	    "Idle time less than 120 minutes. Wait for next run." | Out-File $log -Append
    }
}
