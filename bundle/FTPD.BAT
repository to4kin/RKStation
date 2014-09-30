@ECHO OFF

ECHO ==========================Ag Group RK6 FTPD Utility=============================>> %LOGFILE%
TIMENOW >> %LOGFILE%

ECHO Starting ftp server... >> %LOGFILE%
ECHO Copy FTPASSWD to C:\MTCP... >> %LOGFILE%
COPY %UNZIPDIR%\FTPASSWD C:\MTCP
IF %ERRORLEVEL% == 25 GOTO FTPSTART
ECHO Copy FTPASSWD: ERROR >> %LOGFILE%
GOTO END

:FTPSTART
ECHO Copy FTPASSWD: OK >> %LOGFILE%
ECHO START FTPSRV >> %LOGFILE%
FTPSRV

:END
TIMENOW >> %LOGFILE%
ECHO ===============================FTPD COMPLETED===================================>> %LOGFILE%
ECHO.