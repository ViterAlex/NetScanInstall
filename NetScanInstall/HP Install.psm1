function Add-PrinterPort ($printerSource) {
    &cscript C:\Windows\System32\Printing_Admin_Scripts\ru-RU\prnport.vbs `
    -a -r $printerSource -h $printerSource -o RAW -n 9100 | Out-Null
}

function Add-PrinterDriver ($printerName, $driverPath) {
    $folder = Split-Path $driverPath
    &cscript C:\Windows\System32\Printing_Admin_Scripts\ru-RU\prndrvr.vbs `
    -a -m $printerName -e Get-Platform -h $folder -i $driverPath
}

function Get-Platform {
    if ([System.Environment]::Is64BitOperatingSystem) {
        "Windows x64"
    } else {
        "Windows NT x86"
    }
}

function Add-Scanner ($ipaddress, $printername) {
    switch -regex ($printername) {
        # добавить других мфу по вкусу
        "1530" {
            Push-Location 'C:\Drivers\Scanners\ip\1536scan\'
            if ($(Get-Platform) -eq "Windows x64") {
                .\hppniscan64.exe -f "hppasc16.inf" -m "vid_03f0&pid_012a&IP_SCAN" -a $ipaddress -n 1
            } else {
                .\hppniscan01.exe -f "hppasc16.inf" -m "vid_03f0&pid_012a&IP_SCAN" -a $ipaddress -n 1
            }
            Pop-Location
        }        
        "(305\d)|(3390)" {
            Push-Location 'C:\Drivers\Scanners\ip\3055scan\'
            switch -regex ($printername) {
                "3050" {
                    .\hppniscan01.exe -f "hppasc01.inf" -m "vid_03f0&pid_3217&IP_SCAN" -a $ipaddress -n 1
                }
                "3052" {
                    .\hppniscan01.exe -f "hppasc01.inf" -m "vid_03f0&pid_3317&IP_SCAN" -a $ipaddress -n 1
                }
                "3055" {
                    .\hppniscan01.exe -f "hppasc01.inf" -m "vid_03f0&pid_3417&IP_SCAN" -a $ipaddress -n 1
                }
                "3390" {
                    .\hppniscan01.exe -f "hppasc01.inf" -m "vid_03f0&pid_3517&IP_SCAN" -a $ipaddress -n 1
                }
            }
            Pop-Location
        }
		"2727"{
			Push-Location 'C:\Drivers\Scanners\ip\2727scan\'
            if ($(Get-Platform) -eq "Windows x64") {
                .\hppniscan64.exe -f "hppasc07.inf" -m "vid_03f0&pid_4D17&IP_SCAN" -a $ipaddress -n 1
            } else {
                .\hppniscan01.exe -f "hppasc07.inf" -m "vid_03f0&pid_4D17&IP_SCAN" -a $ipaddress -n 1
            }
            Pop-Location
		}
    }
}

Add-Type -As Microsoft.VisualBasic

function Get-PrinterNames{
    "HP LJ M2727nf Scan"
    "HP LaserJet M1530 MFP Series PCL 6"
}

function Run-Install($printerIP, $printerName, $driverpath){
    if ($printerIP -match "^192\.168\.[0-9]{1,3}\.[0-9]{1,3}$") {

        Add-PrinterPort $printerIP
        Add-PrinterDriver $printername $driverPath
        # знак & перед коммандой переключит режим и параметры не сломаются
        &rundll32 printui.dll,PrintUIEntry /if /b $printername /r $printerIP /m $printername /u /K /q /Gw
        Start-Sleep -Seconds 10

        Add-Scanner $printerIP $printername
    }
}