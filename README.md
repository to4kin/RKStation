RKStation
=========

Remote maintenance R-Keeper for DOS

Набор BAT файлов для удаленного управления станциями R-Keeper под Dos.

Основные функции
================
1.	Централизованное обновление DB
2.	Централизованное обновление RKCLIENT
3.	Запуск FTP Сервера на кассе
4.	Создание резервной копии всего диска
5.	Запуск Linux под Dos

Описание функций
================
1. Централизованное обновление DB
Позволяет обновлять базу централизовано, средствами самой кассы. Касса в момент запуска проверяет наличие на сервере обновленного архива с базой (В зависимости от типа кассы COFFEE.ZIP, HOTEL.ZIP и т.д. Тип кассы указывается в файле CFILE), если такой существует – автоматически закачивает его и распаковывает в директорию (по умолчанию DBDIR=C:\RKCLIENT\EXTDB).
В файле LOCAL.DB R-Keeper должна быть указана ссылка на %DBDIR%.

2. Централизованное обновление RKCLIENT
Позволяет провести обновление всех касс на новую версию R-Keeper. Для этого необходимо на сервере поместить архив %RKUPDF%.zip, содержащий новую версию RKCLIENT (официантская станция) и содержащий папочку SERVER (содержит файлы для кассовой станции).

3. Запуск FTP Сервера на кассе
Запускает полноценный FTP Сервер на кассе.

4. Создание резервной копии всего диска
Используя утилиту GHOST создает на внешнем диске образ текущего диска.

5. Запуск Linux под Dos
Запускает BASIC Linux.

Установка
=========
1.	Поместить START.BAT и PARAMS.BAT в корень диска C:\
2.	Прописать в AUTOEXEC.BAT запуск скрипта
3.	Установить и настроить MTCP и BASIC Linux (либо любйо другой Linux, тогда необходимо поменять параметры запуска %STLINUX%)
4.	Поместить UNZIP32.EXE, CRC32.EXE, GHOST.EXE, REALDATE.EXE, TIMENOW.EXE, FAM.EXE, PIPESET.EXE, TR.EXE, FDAPM.EXE в папку C:\UTILS
5.	Настроить переменные в файле PARAMS.BAT
6.	Подготовить %BUNDLE%.zip содержащий DBUPDATE.BAT, FTPD.BAT, GHOST.BAT, GO.BAT, MTCP.BAT, RKUPDATE.BAT, cfile, ftpasswd
7.	Подготовить %CRC32% содержащий файлы %BUNDLE%.c32, %RKUPDF%.c32 и %RKTYPE%.c32 с CRC32 соответствующих ZIP архивов
8.	Поместить %BUNDLE%.zip, %RKUPDF%.zip, %RKTYPE%.zip и %CRC32% на %SERVER%

Пример конфигурационных файлов
==============================

CFILE
# DOS station startup control file
#
# FORMAT: unit  type  dbupdate	state	action
#
# TYPE: COFFEE | PUB | MAGAZ
# DBUPDATE: YES | NO
# STATE: RK6 | FTPD | UPDATE | GHOST | LINUX
# ACTION: CONTINUE | REBOOT | SHUTDOWN
#
# DEFAULT action CONTINUE

UNIT01	PUB	    YES	UPDATE	SHUTDOWN
UNIT02	COFFEE	YES	FTPD	 REBOOT

FTPASSWD:
Можно посмотреть в C:\MTCP\SETUP.TXT

