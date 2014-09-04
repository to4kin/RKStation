@ECHO OFF

ECHO Start go.bat...

REM --------Set source--------------
SET CFILE=%UNZIPDIR%\CFILE
SET LOGFILE=%LOGDIR%\UPDATE.LOG

SET DBUPDATE=%UNZIPDIR%\DBUPDATE.BAT
SET RKUPDATE=%UNZIPDIR%\RKUPDATE.BAT
SET FTPSTART=%UNZIPDIR%\FTPD.BAT
SET GHOST=%UNZIPDIR%\GHOST.BAT
REM --------------------------------

ECHO ==========================Ag Group RK6 GO Utility========================== >> %MAINLOG%
timenow >> %MAINLOG%

ECHO Start %UNZIPDIR%\MTCP.BAT >> %MAINLOG%
CALL %UNZIPDIR%\MTCP.BAT

ECHO Checking %CFILE%... >> %LOGFILE%
IF EXIST %CFILE% GOTO CFE
ECHO File %CFILE% Not Exist >> %LOGFILE%
GOTO END

:CFE
ECHO File %CFILE% Exist >> %LOGFILE%
ECHO Parsing %CFILE%... >> %LOGFILE%
TYPE %CFILE% | FAM /M0=%HOSTNAME% \F2 \F3 \F4 | PIPESET UPDDB STATE ACTION
TYPE %CFILE% | FAM /M0=%HOSTNAME% \F1 | TR A-Z a-z | PIPESET RKTYPE

IF "%UPDDB%" == "YES" CALL %DBUPDATE%
IF "%STATE%" == "UPDATE" CALL %RKUPDATE%
IF "%STATE%" == "FTPD" CALL %FTPD%
IF "%STATE%" == "GHOST" CALL %GHOST%
IF "%STATE%" == "LINUX" GOTO LINUX
IF "%STATE%" == "RK6" GOTO END

IF "%ACTION%" == "CONTINUE" GOTO END
IF "%ACTION%" == "REBOOT" GOTO REBOOT
IF "%ACTION%" == "SHUTDOWN" GOTO SHUTDOWN
GOTO END

:REBOOT
ECHO >> %LOGFILE%
ECHO Automatic restart the system >> %LOGFILE%
ECHO >> %LOGFILE%
timenow >> %MAINLOG%
ECHO ===============================GO COMPLETED=============================== >> %MAINLOG%
fdapm /COLDBOOT

:SHUTDOWN
ECHO >> %LOGFILE%
ECHO Automatic shutdown the system >> %LOGFILE%
ECHO >> %LOGFILE%
timenow >> %MAINLOG%
ECHO ===============================GO COMPLETED=============================== >> %MAINLOG%
fdapm /POWEROFF

:LINUX
ECHO >> %LOGFILE%
ECHO Start linux OS >> %LOGFILE%
ECHO >> %LOGFILE%
timenow >> %MAINLOG%
ECHO ===============================GO COMPLETED=============================== >> %MAINLOG%
CD %LINUXDIR%
%STLINUX%

:END
timenow >> %MAINLOG%
ECHO ===============================GO COMPLETED=============================== >> %MAINLOG%
ECHO.

REM --------Set source--------------
SET CFILE=
SET LOGFILE=

SET DBUPDATE=
SET RKUPDATE=
SET FTPSTART=
REM --------------------------------