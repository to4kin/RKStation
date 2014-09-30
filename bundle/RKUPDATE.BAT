@ECHO OFF

ECHO ==========================Ag Group RK6 RKUpdate Utility=========================>> %LOGFILE%
TIMENOW >> %LOGFILE%

ECHO Compare %BUNDLEDIR%\%RKUPDF%.zip MD5... >> %LOGFILE%
TYPE %UNZIPDIR%\%MD5% | FAM /M1=%BUNDLE%.zip \F0 | TR a-f A-F | PIPESET NEWMD5
MD5 %BUNDLEDIR%\%RKUPDF%.zip | FAM \F3 | TR a-f A-F | PIPESET OLDMD5
IF "%NEWMD5%" == "%OLDMD5%" GOTO UPMD5OK

ECHO Getting %RKUPDF%.zip from %SERVER%... >> %LOGFILE%
HTGET %SERVER%/%RKUPDF%.zip > %BUNDLEDIR%\%RKUPDF%.zip
IF %ERRORLEVEL% == 21 GOTO UPGETOK

ECHO Cannot get %RKUPDF%.zip... >> %LOGFILE%
GOTO END

:UPGETOK
ECHO Getting successfully %RKUPDF%.zip from %SERVER%... >> %LOGFILE%
ECHO Compare %BUNDLEDIR%\%RKUPDF%.zip MD5... >> %LOGFILE%
TYPE %UNZIPDIR%\%MD5% | FAM /M1=%BUNDLE%.zip \F0 | TR a-f A-F | PIPESET NEWMD5
MD5 %BUNDLEDIR%\%RKUPDF%.zip | FAM \F3 | TR a-f A-F | PIPESET OLDMD5
IF "%NEWMD5%" == "%OLDMD5%" GOTO UPMD5OK

ECHO MD5 Verification faild: %NEWMD5% ne %OLDMD5% >> %LOGFILE%
GOTO END

:UPMD5OK
ECHO Compare successfully %BUNDLEDIR%\%RKUPDF%.zip MD5... >> %LOGFILE%
ECHO Unzip %BUNDLEDIR%\%RKUPDF%.zip to %UPDDIR%
UNZIP32 -o %BUNDLEDIR%\%RKUPDF%.zip -d %UPDDIR%
IF %ERRORLEVEL% == 0 GOTO BDUZOK

ECHO Cannot unzip %BUNDLEDIR%\%RKUPDF%.zip to %UPDDIR%... >> %LOGFILE%
GOTO END

:BDUZOK
ECHO Unzip successfully %BUNDLEDIR%\%RKUPDF%.zip to %UPDDIR%
ECHO Checking %BACKUPDIR%... >> %LOGFILE%
IF EXIST %BACKUPDIR%\NUL GOTO BCKDEX
ECHO Creating %BACKUPDIR%... >> %LOGFILE%
MKDIR %BACKUPDIR%

:BCKDEX
ECHO %BACKUPDIR% EXIST... >> %LOGFILE%
REALDATE /f="DDMMhhmm" | PIPESET BCNAME
SET BCNAME=%BACKUPDIR%\%BCNAME%
ECHO Creating %BCNAME%... >> %LOGFILE%
MKDIR %BCNAME%

IF EXIST %BCNAME%\NUL GOTO CBCKDEX 
ECHO %BCNAME% Not Exist >> %LOGFILE%
GOTO END

:CBCKDEX
ECHO %BCNAME% EXIST >> %LOGFILE%
ECHO Moving %RKDIR% to %BCNAME%... >> %LOGFILE%
MOVE /S %RKDIR% %BCNAME%
ECHO Deleting directory %RKDIR% and subdirectories... >> %LOGFILE%
DELDIR %RKDIR%

IF NOT EXIST %BCNAME%\OLDRES\NUL GOTO WAITER 
ECHO Server station... >> %LOGFILE% 
ECHO Copying servers dll... >> %LOGFILE%
COPY %UPDDIR%\SERVER\*.* C:\RKCLIENT
ECHO Creating DATABASE, OLDRES and RESULTS directories... >> %LOGFILE%
MKDIR %RKDIR%\DATABASE
MKDIR %RKDIR%\RESULTS
MKDIR %RKDIR%\OLDRES
ECHO Copying DATABASE files to %RKDIR%\DATABASE directory... >> %LOGFILE%
COPY %UPDDIR%\DATABASE\*.* %RKDIR%\DATABASE
ECHO Copying system.db and local.db... >> %LOGFILE%
COPY %BCNAME%\DATABASE\system.db %RKDIR%\DATABASE
COPY %BCNAME%\local.db %RKDIR%
GOTO SERVER

:WAITER
ECHO Waiter station... >> %LOGFILE%

:SERVER
ECHO Creating required directories in %RKDIR%... >> %LOGFILE%
MKDIR %RKDIR%\EXTENS
MKDIR %RKDIR%\FONTS
MKDIR %RKDIR%\FORMS
MKDIR %RKDIR%\TARIF

ECHO Copying files to %RKDIR% directory... >> %LOGFILE%
COPY %UPDDIR%\*.* %RKDIR%\
COPY %UPDDIR%\EXTENS\*.* %RKDIR%\EXTENS
COPY %UPDDIR%\FONTS\*.* %RKDIR%\FONTS
COPY %UPDDIR%\TARIF\*.* %RKDIR%\TARIF
ECHO Restore FORMS directory... >> %LOGFILE%
COPY %BCNAME%\FORMS\*.* %RKDIR%\FORMS

ECHO Checking required fiscsup.dll... >> %LOGFILE%
IF EXIST %BCNAME%\fiscsup.dll GOTO FISCSUP 
ECHO fiscsup.dll not required... >> %LOGFILE%
ECHO Deleting fiscsup.dll... >> %LOGFILE%
DEL %RKDIR%\fiscsup.dll

:FISCSUP 
ECHO Copying rkeeper.ini... >> %LOGFILE%
COPY %BCNAME%\rkeeper6.ini %RKDIR%

ECHO Deleting directory %UPDDIR% and subdirectories... >> %LOGFILE%
DELDIR %UPDDIR%
RD %UPDDIR%
ECHO Deleting log files and errors.txt in %RKDIR%... >> %LOGFILE%
DEL %RKDIR%\*.log
DEL %RKDIR%\errors.txt

TIMENOW >> %LOGFILE%
ECHO ===============================RKUPDATE COMPLETED===============================>> %LOGFILE%
ECHO.