C:\nssm\win64\nssm.exe stop wso2
del C:\nssm\service.log 
del C:\wso2510\repository\deployment\server\webapps\JavaAPI.war
del C:\wso2510\repository\deployment\server\webapps\JavaAPI 
C:\nssm\win64\nssm.exe start wso2