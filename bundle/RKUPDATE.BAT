@ECHO OFF

ECHO Start rkupdate.bat..

REM --------Set source--------------
SET UPDDIR=%UNZIPDIR%\RKEEPER
REM --------------------------------

ECHO ==========================Ag Group RK6 RKUpdate Utility========================== >> %LOGFILE%
timenow >> %LOGFILE%

ECHO Update DHCP lease >> %LOGFILE%
dhcp
IF %ERRORLEVEL% == 0 GOTO DHCPOK
ECHO START DHCP: ERROR >> %LOGFILE%
GOTO END

:DHCPOK
ECHO Compare %BUNDLEDIR%\%RKUPDF%.zip CRC32... >> %MAINLOG%
TYPE %CRCDIR%\%RKUPDF%.c32 | TR a-f A-F | PIPESET NEWCRC
CRC32 %BUNDLEDIR%\%RKUPDF%.zip | FAM \F1 | TR a-f A-F | PIPESET OLDCRC
IF "%NEWCRC%" == "%OLDCRC%" GOTO UPCRCOK

ECHO Getting %RKUPDF%.zip from %SERVER%... >> %LOGFILE%
htget %SERVER%/%RKUPDF%.zip > %BUNDLEDIR%\%RKUPDF%.zip
IF %ERRORLEVEL% == 21 GOTO UPGETOK

ECHO Cannot get %RKUPDF%.zip... >> %LOGFILE%
GOTO END

:UPGETOK
ECHO Compare %BUNDLEDIR%\%RKUPDF%.zip CRC32... >> %MAINLOG%
TYPE %CRCDIR%\%RKUPDF%.c32 | TR a-f A-F | PIPESET NEWCRC
CRC32 %BUNDLEDIR%\%RKUPDF%.zip | FAM \F1 | TR a-f A-F | PIPESET OLDCRC
IF "%NEWCRC%" == "%OLDCRC%" GOTO UPCRCOK

ECHO CRC32 Verification faild: %NEWCRC% ne %OLDCRC% >> %MAINLOG%
GOTO END

:UPCRCOK
ECHO Unzip %BUNDLEDIR%\%RKUPDF%.zip to %UPDDIR%
UNZIP32 -o %BUNDLEDIR%\%RKUPDF%.zip -d %UPDDIR%
IF %ERRORLEVEL% == 0 GOTO BDUZOK

ECHO Cannot unzip %BUNDLEDIR%\%RKUPDF%.zip to %UPDDIR%... >> %LOGFILE%
GOTO END

:BDUZOK
ECHO Checking %BACKUPDIR%... >> %LOGFILE%
IF EXIST %BACKUPDIR%\NUL GOTO BCKDEX
ECHO Creating %BACKUPDIR%... >> %LOGFILE%
MKDIR %BACKUPDIR%

:BCKDEX
REALDATE /f="DDMMhhmm" | PIPESET BCNAME
ECHO Creating %BCNAME%... >> %LOGFILE%
MKDIR %BCNAME%

IF EXIST %BCNAME%\NUL GOTO CBCKDEX 
ECHO %BCNAME% Not Exist >> %LOGFILE%
GOTO END

:CBCKDEX
ECHO Moving %RKDIR% to %BCNAME%... >> %LOGFILE%
MOVE /S %RKDIR% %BCNAME%
ECHO Deleting directory %RKDIR% and subdirectories... >> %LOGFILE%
DELDIR %RKDIR%

IF NOT EXIST %BCNAME%\OLDRES\NUL GOTO WAITER 
ECHO Server station... >> %LOGFILE% 
ECHO Copying servers dll... >> %LOGFILE%
COPY %UPDDIR%\SERVER\*.* C:\RKCLIENT
ECHO Creating OLDRES and RESULTS directories... >> %LOGFILE%
MKDIR %RKDIR%\RESULTS
MKDIR %RKDIR%\OLDRES
GOTO SERVER

:WAITER
ECHO Waiter station... >> %LOGFILE%

:SERVER
ECHO Creating required directories in %RKDIR%... >> %LOGFILE%
MKDIR %RKDIR%\DATABASE
MKDIR %RKDIR%\EXTENS
MKDIR %RKDIR%\FONTS
MKDIR %RKDIR%\FORMS
MKDIR %RKDIR%\TARIF

ECHO Copying files to %RKDIR% directory... >> %LOGFILE%
COPY %UPDDIR%\*.* %RKDIR%\
COPY %UPDDIR%\DATABASE\*.* %RKDIR%\DATABASE
COPY %UPDDIR%\EXTENS\*.* %RKDIR%\EXTENS
COPY %UPDDIR%\FONTS\*.* %RKDIR%\FONTS
COPY %BCNAME%\FORMS\*.* %RKDIR%\FORMS
COPY %UPDDIR%\TARIF\*.* %RKDIR%\TARIF

ECHO Checking required fiscsup.dll... >> %LOGFILE%
IF EXIST %BCNAME%\fiscsup.dll GOTO FISCSUP 
ECHO fiscsup.dll not required... >> %LOGFILE%
ECHO Deleting fiscsup.dll... >> %LOGFILE%
DEL %RKDIR%\fiscsup.dll

:FISCSUP 
ECHO Copying system.db local.db rkeeper.ini... >> %LOGFILE%
COPY %BCNAME%\DATABASE\system.db %RKDIR%\DATABASE
COPY %BCNAME%\local.db %RKDIR%
COPY %BCNAME%\rkeeper6.ini %RKDIR%

ECHO Deleting directory %UPDDIR% and subdirectories... >> %MAINLOG%
DELDIR %UPDDIR%
RD %UPDDIR%

timenow >> %LOGFILE%
ECHO ===============================RKUPDATE COMPLETED=============================== >> %LOGFILE%
ECHO.

REM --------Set source--------------
SET RKUPDF=
SET UPDDIR=
REM --------------------------------