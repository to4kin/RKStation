@ECHO OFF

ECHO ==========================Ag Group GHOST Utility================================>> %LOGFILE%
TIMENOW >> %LOGFILE%

ECHO Checking %UNZIPDIR%\GHOST.SCR... >> %LOGFILE%
IF EXIST %UNZIPDIR%\GHOST.SCR GOTO CFE
ECHO File %UNZIPDIR%\GHOST.SCR Not Exist >> %LOGFILE%
GOTO END

:CFE
ECHO File %UNZIPDIR%\GHOST.SCR Exist >> %LOGFILE%
ECHO Set GHOST image name... >> %LOGFILE%
REALDATE /f="DDMMhhmm" | PIPESET DATETIME
SED "s/\$\$\$/%DATETIME%/" %UNZIPDIR%\GHOST.SCR > %UNZIPDIR%\MGHOST.SCR
IF %ERRORLEVEL% == 0 GOTO STATUSOK

ECHO Can't modify %UNZIPDIR%\GHOST.SCR file... >> %LOGFILE%
GOTO END

:STATUSOK
ECHO Successfully modified %UNZIPDIR%\GHOST.SCR file... >> %LOGFILE%
ECHO Start GHOST... >> %LOGFILE%
GHOST @%UNZIPDIR%\MGHOST.SCR

:END
TIMENOW >> %LOGFILE%
ECHO ===============================GHOST COMPLETED==================================>> %LOGFILE%
ECHO.