@ECHO OFF

ECHO Start ftpd.bat..

ECHO ==========================Ag Group RK6 FTPD Utility========================== >> %LOGFILE%
timenow >> %LOGFILE%

ECHO Update DHCP lease >> %LOGFILE%
dhcp
IF %ERRORLEVEL% == 0 GOTO DHCPOK
ECHO START DHCP: ERROR >> %LOGFILE%
GOTO END

:DHCPOK
ECHO Starting ftp server... >> %LOGFILE%
ECHO Copy ftpasswd to C:\MTCP... >> %LOGFILE%
COPY %UNZIPDIR%\ftpasswd C:\MTCP
IF %ERRORLEVEL% == 0 GOTO FTPSTART
ECHO Copy ftpasswd: ERROR >> %LOGFILE%
GOTO END

:FTPSTART
ECHO START FTPSRV >> %LOGFILE%
ftpsrv

:END
timenow >> %LOGFILE%
ECHO ===============================FTPD COMPLETED=============================== >> %LOGFILE%
ECHO.