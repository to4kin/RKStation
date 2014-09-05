@ECHO OFF
PROMPT $p$g
PATH=C:\NET;C:\DRDOS;C:\UTIL;C:\RKCLIENT;C:\VC;C:\;C:\TOUCH;C:\MTCP;C:\QEMM
SET TEMP=C:\TEMP
SET TZ=UTC-4

loadhi /r:1 /lo cyrkeyb
loadhi /r:1 /lo vga#font

mode com3: 9600,n,8,1
mode com4: 9600,n,8,1

:chkdsk c: /F

net init
loadhi /r:1 /lo share
loadhi /r:1 /lo netbind
loadhi /r:1 /lo umb
loadhi /r:1 /lo tcptsr
loadhi /r:1 /lo tinyrfc
loadhi /r:1 /lo nmtsr
loadhi /r:1 /lo emsbfr
loadhi /r:1 /lo sockets

net logon unit /yes<c:\net\sys.sys

net share /yes
net use * /d
net use x: \\nas\volume_3 /persistent:no
:net use x: \\praxidike\rk6_pub

cd \touch
utch627

call start.bat

cd \rkclient
dmove buf rkclient
:cor
IF EXIST x:\rkeeper\upd\nork6 SET NORK6=YES
IF "%NORK6%" == NO rkeeper6
vc
