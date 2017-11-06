C:\nssm\win64\nssm.exe stop wso2
Remove-Item C:\nssm\service.log 
Remove-Item C:\wso2510\repository\deployment\server\webapps\JavaAPI.war
Remove-Item C:\wso2510\repository\deployment\server\webapps\JavaAPI 
C:\nssm\win64\nssm.exe start wso2