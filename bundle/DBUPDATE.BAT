@ECHO OFF

ECHO Start dbupdate.bat..

REM --------Set source--------------
SET DBDIR=%RKDIR%\EXTDB
REM --------------------------------

ECHO ==========================Ag Group RK6 DBUpdate Utility========================== >> %LOGFILE%
timenow >> %LOGFILE%

ECHO Update DHCP lease >> %LOGFILE%
dhcp
IF %ERRORLEVEL% == 0 GOTO DHCPOK
ECHO START DHCP: ERROR >> %LOGFILE%
GOTO END

:DHCPOK
ECHO START DHCP: OK >> %LOGFILE%
ECHO Compare %BUNDLEDIR%\%RKTYPE%.zip CRC32... >> %MAINLOG%
TYPE %CRCDIR%\%RKTYPE%.c32 | TR a-f A-F | PIPESET NEWCRC
CRC32 %BUNDLEDIR%\%RKTYPE%.zip | FAM \F1 | TR a-f A-F | PIPESET OLDCRC
IF "%NEWCRC%" == "%OLDCRC%" GOTO DBCRCOK

ECHO Getting %RKTYPE%.zip from %SERVER%... >> %LOGFILE%
htget %SERVER%/%RKTYPE%.zip > %BUNDLEDIR%\%RKTYPE%.zip
IF %ERRORLEVEL% == 21 GOTO DBZGETOK

ECHO Cannot get %RKTYPE%.zip... >> %LOGFILE%
GOTO END

:DBZGETOK
ECHO Compare %BUNDLEDIR%\%RKTYPE%.zip CRC32... >> %MAINLOG%
TYPE %CRCDIR%\%RKTYPE%.c32 | TR a-f A-F | PIPESET NEWCRC
CRC32 %BUNDLEDIR%\%RKTYPE%.zip | FAM \F1 | TR a-f A-F | PIPESET OLDCRC
IF "%NEWCRC%" == "%OLDCRC%" GOTO DBCRCOK

ECHO CRC32 Verification faild: %NEWCRC% ne %OLDCRC% >> %MAINLOG%
GOTO END

:DBCRCOK
ECHO Unzip %BUNDLEDIR%\%RKTYPE%.zip to %DBDIR%
UNZIP32 -o %BUNDLEDIR%\%RKTYPE%.zip -d %DBDIR%
IF %ERRORLEVEL% == 0 GOTO END

ECHO Cannot unzip %BUNDLEDIR%\%RKTYPE%.zip to %DBDIR%... >> %LOGFILE%

:END
timenow >> %LOGFILE%
ECHO ===============================DBUPDATE COMPLETED=============================== >> %LOGFILE%
ECHO.

REM --------Set source--------------
SET DBDIR=
REM --------------------------------