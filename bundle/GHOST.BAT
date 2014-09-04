@ECHO OFF

ECHO Start ghost.bat...

REM --------Set source--------------
SET SCRIPT=%UNZIPDIR%\ghost.scr
SET MSCRIPT=%UNZIPDIR%\mghost.scr
REM --------------------------------

ECHO ==========================Ag Group GHOST Utility========================== >> %LOGFILE%
timenow >> %LOGFILE%

ECHO Checking %SCRIPT%... >> %LOGFILE%
IF EXIST %SCRIPT% GOTO CFE
ECHO File %SCRIPT% Not Exist >> %LOGFILE%
GOTO END

:CFE
ECHO Set gho name... >> %LOGFILE%
REALDATE /f="DDMMYY-hhmm" | PIPESET DATETIME
SED "s/unit/%HOSTNAME%-%DATETIME%/" %SCRIPT% > %MSCRIPT%
IF %ERRORLEVEL% == 0 GOTO STATUSOK

ECHO Can't modify %SCRIPT% file... >> %LOGFILE%
GOTO END

:STATUSOK
ECHO Start GHOST... >> %LOGFILE%
GHOST @%MSCRIPT%

:END
timenow >> %LOGFILE%
ECHO ===============================GHOST COMPLETED=============================== >> %LOGFILE%
ECHO.