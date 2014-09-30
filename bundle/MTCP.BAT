@ECHO OFF

REM -----------------------------
SET POOLSITE=ru.pool.ntp.org
SET SYSLOG=syslog.vpn
SET SYSLOGP=514
REM -----------------------------

ECHO ==========================Ag Group RK6 MTCP Utility=============================>> %LOGFILE%
TIMENOW >> %LOGFILE%

ECHO Update DATETIME >> %LOGFILE%
SNTP -set %POOLSITE%
IF %ERRORLEVEL% == 0 GOTO SNTPOK

ECHO START SNTP: ERROR >> %LOGFILE%
GOTO STATUS

:SNTPOK
ECHO START SNTP: OK >> %LOGFILE%

:STATUS
STRINGS MEM=MEMFREE
echo %HOSTNAME% mtcp[0]: %Day%/%Month%/%Year% %Hour24%:%Minute%:%Second% %OS% %VER% StartScript v%SVERMAYOR%.%SVERMINOR% FreeMem %MEM% RKeeper6 loading | NC -target %SYSLOG% %SYSLOGP%
IF %ERRORLEVEL% == 0 GOTO STATUSOK

ECHO SEND STATUS TO %SYSLOG%: ERROR >> %LOGFILE%
GOTO END

:STATUSOK
ECHO SEND STATUS TO %SYSLOG%: OK >> %LOGFILE%

:END
TIMENOW >> %LOGFILE%
ECHO ===============================MTCP COMPLETED===================================>> %LOGFILE%
ECHO.