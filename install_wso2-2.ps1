write-host -f yellow "install wso2"
#Clear-Host


Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


Unzip "C:\Users\IEUser\Downloads\nssm.zip" "C:\"
Unzip "C:\Users\IEUser\Downloads\wso2is-5.1.0.zip" "C:\"

Rename-Item c:\wso2is-5.1.0 c:\wso2510
Rename-Item c:\nssm-2.24 c:\nssm

$catalina = Get-Content C:\wso2510\repository\conf\tomcat\catalina-server.xml
$catalina[53] = $catalina[53].Replace("9443","443")
$catalina[29] = $catalina[29].Replace("9443","443")
$catalina[28] = $catalina[28].Replace("9763","80")
Set-Content -Path C:\wso2510\repository\conf\tomcat\catalina-server.xml  -Value $catalina

C:\nssm\win64\nssm.exe install wso2 "C:\wso2510\bin\wso2server.bat"

C:\nssm\win64\nssm.exe set wso2 AppEnvironmentExtra JAVA_HOME="C:\jdk18_152\"

C:\nssm\win64\nssm.exe set wso2 AppStdout C:\nssm\service.log

C:\nssm\win64\nssm.exe set wso2 AppStderr C:\nssm\service-err.log

C:\nssm\win64\nssm.exe start wso2

C:\nssm\win64\nssm.exe continue wso2

Start-Sleep -s 60

start-process -filepath chrome.exe https://localhost:443/carbon

if (Test-Path c:\wso2is-5.1.0) {
    Remove-Item c:\wso2is-5.1.0 -Recurse #-verbose
    }
if (Test-Path c:\nssm-2.24) {
    Remove-Item C:\nssm-2.24 -Recurse #-verbose
    }

Get-Content C:\nssm\service.log -Tail 1

Write-Host 'Done. Goodbye.'

#C:\nssm\win64\nssm.exe stop wso2
