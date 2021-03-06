@ECHO OFF

REM -----------------------------
SET RKUPDF=update
SET FTPDLOG=%LOGDIR%\FTPD.LOG
SET MTCPLOG=%LOGDIR%\MTCP.LOG
SET GHOSTLOG=%LOGDIR%\GHOST.LOG
SET DBUPDLOG=%LOGDIR%\DBUPDATE.LOG
SET RKUPDLOG=%LOGDIR%\RKUPDATE.LOG
REM -----------------------------

ECHO ============================Ag Group RK6 GO Utility=============================>> %MAINLOG%
TIMENOW >> %MAINLOG%

ECHO Start %UNZIPDIR%\MTCP.BAT >> %MAINLOG%
SET LOGFILE=%MTCPLOG%
CALL %UNZIPDIR%\MTCP.BAT

ECHO Checking %CFILE%... >> %MAINLOG%
IF EXIST %CFILE% GOTO CFE
ECHO File %CFILE% Not Exist >> %MAINLOG%
GOTO END

:CFE
ECHO File %CFILE% Exist >> %MAINLOG%
ECHO Parsing %CFILE%... >> %MAINLOG%
TYPE %CFILE% | FAM /M0=%HOSTNAME% \F2 \F3 \F4 | PIPESET UPDDB STATE ACTION
TYPE %CFILE% | FAM /M0=%HOSTNAME% \F1 | TR A-Z a-z | PIPESET RKTYPE

IF "%UPDDB%" == "YES" GOTO 1
GOTO 2

:1
ECHO Start %UNZIPDIR%\DBUPDATE.BAT >> %MAINLOG%
SET LOGFILE=%DBUPDLOG%
CALL %UNZIPDIR%\DBUPDATE.BAT

:2
IF "%STATE%" == "UPDATE" GOTO 3
GOTO 4

:3
ECHO Start %UNZIPDIR%\RKUPDATE.BAT >> %MAINLOG%
SET LOGFILE=%RKUPDLOG%
CALL %UNZIPDIR%\RKUPDATE.BAT
GOTO 9

:4
IF "%STATE%" == "FTPD" GOTO 5
GOTO 6

:5
ECHO Start %UNZIPDIR%\FTPD.BAT >> %MAINLOG%
SET LOGFILE=%FTPDLOG%
CALL %UNZIPDIR%\FTPD.BAT
GOTO 9

:6
IF "%STATE%" == "GHOST" GOTO 7
GOTO 8

:7
ECHO Start %UNZIPDIR%\GHOST.BAT >> %MAINLOG%
SET LOGFILE=%GHOSTLOG%
CALL %UNZIPDIR%\GHOST.BAT
GOTO 9

:8
IF "%STATE%" == "LINUX" GOTO LINUX
IF "%STATE%" == "RK6" GOTO END
IF "%STATE%" == "NORK6" GOTO NORK6

:9
IF "%ACTION%" == "CONTINUE" GOTO END
IF "%ACTION%" == "REBOOT" GOTO REBOOT
IF "%ACTION%" == "SHUTDOWN" GOTO SHUTDOWN
GOTO END

:NORK6
ECHO SET NORK6 = YES >> %MAINLOG%
SET NORK6=YES
GOTO END

:REBOOT
ECHO. >> %MAINLOG%
ECHO Automatic restart the system >> %MAINLOG%
ECHO. >> %MAINLOG%
FDAPM /COLDBOOT
GOTO END

:SHUTDOWN
ECHO. >> %MAINLOG%
ECHO Automatic shutdown the system >> %MAINLOG%
ECHO. >> %MAINLOG%
FDAPM /POWEROFF
GOTO END

:LINUX
ECHO. >> %MAINLOG%
ECHO Start linux OS >> %MAINLOG%
ECHO. >> %MAINLOG%
CD %LINUXDIR%
%STLINUX%
GOTO END

:END
TIMENOW >> %MAINLOG%
ECHO ===============================GO COMPLETED=====================================>> %MAINLOG%
ECHO.