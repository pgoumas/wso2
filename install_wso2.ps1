write-host -f yellow "install wso2"
cls

Invoke-AzureRmVmScript @params -ScriptBlock {

$source = "http://nssm.cc/release/nssm-2.24.zip";
$destination = "nssm.zip"
$source2 = "https://github.com/pgoumas/test/raw/release/wso2is-5.1.0.zip";
$destination2 = "wso2is.zip"

if (Test-Path $env:TEMP\$destination) {
  Write-host -f Yellow "File nssm Exists!"
}
else {
   

    $WC = New-Object System.Net.WebClient
    $WC.DownloadFile($source,"$env:TEMP\$destination")
    $WC.Dispose()
    Write-host -f Yellow "File nssm Downloaded!"
}
    
if (Test-Path $env:TEMP\$destination2) {
  Write-host -f Yellow "File $destination2 Exists!"
}
else {
$WC = New-Object System.Net.WebClient
$WC.DownloadFile($source2,"$env:TEMP\$destination2")
$WC.Dispose()
Write-host -f Yellow "File $destination2 Downloaded!"
}


Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

if (Test-Path c:\nssm) {
    C:\nssm\win64\nssm.exe stop wso2
    C:\nssm\win64\nssm.exe remove wso2 confirm
    Start-Sleep -s 10
    Remove-Item C:\nssm -Recurse #-verbose
    if (Test-Path c:\wso2510) {
            Remove-Item c:\wso2510 -Recurse #-verbose
        }
    }
if (Test-Path c:\wso2is-5.1.0) {
    Remove-Item c:\wso2is-5.1.0 -Recurse #-verbose
    }
if (Test-Path c:\nssm-2.24) {
    Remove-Item C:\nssm-2.24 -Recurse #-verbose
    }

#Start-Sleep -s 10

Unzip "$env:TEMP\$destination" "C:\"
Unzip "$env:TEMP\$destination2" "C:\"

Rename-Item c:\wso2is-5.1.0 c:\wso2510
Rename-Item c:\nssm-2.24 c:\nssm

$catalina = Get-Content C:\wso2510\repository\conf\tomcat\catalina-server.xml
$catalina[53] = $catalina[53].Replace("9443","443")
$catalina[29] = $catalina[29].Replace("9443","443")
$catalina[28] = $catalina[28].Replace("9763","80")
Set-Content -Path C:\wso2510\repository\conf\tomcat\catalina-server.xml  -Value $catalina

C:\nssm\win64\nssm.exe install wso2 "C:\wso2510\bin\wso2server.bat"

C:\nssm\win64\nssm.exe set wso2 AppEnvironmentExtra JAVA_HOME="C:\Program Files\Java\jre1.8.0_144"

C:\nssm\win64\nssm.exe set wso2 AppStdout C:\nssm\service.log

C:\nssm\win64\nssm.exe set wso2 AppStderr C:\nssm\service-err.log

C:\nssm\win64\nssm.exe start wso2

C:\nssm\win64\nssm.exe continue wso2

Start-Sleep -s 60

Get-Content C:\nssm\service.log -Tail 1

Write-Host 'Done. Goodbye.'
} -Verbose -force 


$locName2 = $locName.replace(" ","")

write-host https://"$customDomain.$locName2.cloudapp.azure.com":9443/carbon

start-process -filepath chrome.exe https://"$customDomain.$locName2.cloudapp.azure.com":443/carbon

start-process -filepath chrome.exe http://"$customDomain.$locName2.cloudapp.azure.com"/carbon

<#start-process -filepath chrome.exe https://localhost:9443/carbon

start-process -filepath chrome.exe https://localhost:443/carbon

start-process -filepath chrome.exe http://localhost:9763/carbon

C:\nssm\win64\nssm.exe restart wso2

Start-Sleep -s 60

Get-Content C:\nssm\service.log -Tail 1

start-process -filepath chrome.exe http://localhost/carbon

start-process -filepath chrome.exe https://localhost:8005/carbon

start-process -filepath chrome.exe http://localhost:11111/carbon
#>