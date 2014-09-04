RKStation
=========

Remote maintenance R-Keeper for DOS

Набор BAT файлов для удаленного управления станциями R-Keeper под Dos.

Все управление осуществляется посредством файла CFILE, лежащего на сервере в архиве %BUNDLE%.zip. Касса при запуске скачивает с сервера архив %BUNDLE%.zip, распаковывает его и запускает файл %GO%. Далее, в зависимости от настроек CFILE, выполняет соответствующие функции.

Так же следует учесть, что перед скачиванием любого архива %BUNDLE%.zip, %RKUPDF%.zip или %RKTYPE%.zip касса проверяет были ли сделаны в нем изменения и стоит ли его качать. Для этого самым первым качается %CRC32%, который содержит соответствующие файлы %BUNDLE%.c32, %RKUPDF%.c32 и %RKTYPE%.c32 с CRC32 каждого архива. Поэтому при изменении соответствующего архива на сервере не забудьте поменять соответствующий ему файл *.c32

Основные функции
================
1.	Централизованное обновление DB
2.	Централизованное обновление RKCLIENT
3.	Запуск FTP Сервера на кассе
4.	Создание резервной копии всего диска
5.	Запуск Linux под Dos

#Централизованное обновление DB
Позволяет обновлять базу централизовано, средствами самой кассы. Касса в момент запуска проверяет наличие на сервере обновленного архива с базой (В зависимости от типа кассы COFFEE.ZIP, HOTEL.ZIP и т.д. Тип кассы указывается в файле CFILE), если такой существует – автоматически закачивает его и распаковывает в директорию (по умолчанию DBDIR=C:\RKCLIENT\EXTDB).
В файле LOCAL.DB R-Keeper должна быть указана ссылка на %DBDIR%.

#Централизованное обновление RKCLIENT
Позволяет провести обновление всех касс на новую версию R-Keeper. Для этого необходимо на сервере поместить архив %RKUPDF%.zip, содержащий новую версию RKCLIENT (официантская станция) и содержащий папочку SERVER (содержит файлы для кассовой станции).

#Запуск FTP Сервера на кассе
Запускает полноценный FTP Сервер на кассе.

#Создание резервной копии всего диска
Используя утилиту GHOST создает на внешнем диске образ текущего диска.

#Запуск Linux под Dos
Запускает BASIC Linux.

Установка
=========
1.	Поместить START.BAT и PARAMS.BAT в корень диска C:\
2.	Прописать в AUTOEXEC.BAT запуск скрипта START.BAT. Прописать TimeZone: TZ=UTC-4
3.	Установить и настроить MTCP (http://www.brutman.com/mTCP/) и BASIC Linux (либо любой другой Linux, тогда необходимо поменять параметры запуска в переменной %STLINUX%)
4.	Дополнительные утилиты поместить в папку C:\UTILS (Либо в любую другую папку из окружения PATH):
  5.	UNZIP32.EXE (http://www.freedos.org/software/?prog=unzip)
  6.	CRC32.EXE
  7.	GHOST.EXE
  8.	REALDATE.COM (http://www.huweb.hu/maques/realdate.htm)
  9.	TIMENOW.EXE
  10.	FAM.COM, PIPESET.COM, TR.COM (http://www.bttr-software.de/products/jhoffmann/dosutils.zip)
  11.	FDAPM.EXE (http://www.freedos.org/software/?prog=fdapm) 
12.	Настроить переменные в файле PARAMS.BAT в соответствии с Вашей системой
13.	Подготовить %BUNDLE%.zip содержащий DBUPDATE.BAT, FTPD.BAT, GHOST.BAT, GO.BAT, MTCP.BAT, RKUPDATE.BAT, CFILE, FTPASSWD
14.	Подготовить %CRC32%.zip содержащий файлы %BUNDLE%.c32, %RKUPDF%.c32 и %RKTYPE%.c32 с CRC32 соответствующих ZIP архивов
15.	Поместить %BUNDLE%.zip, %RKUPDF%.zip, %RKTYPE%.zip и %CRC32%.zip на %SERVER%

Файлы
=====
#START.BAT
Стартовый скрипт. Помещается на кассу и организует загрузку %BUNDLE%.zip и %CRC32%.zip с сервера. После удачной загрузки и распаковки файлов запускает скрипт из переменной %GO%

#PARAMS.BAT
Скрипт с параметрами для станции. ОБЯЗАТЕЛЬНО исправить переменные перед запуском

#GO.BAT
Стартовый скрипт получаемый с сервера. Запускает все остальные скрипты при необходимости. Легко редактируется, т.к. загружается с сервера

#DBUPDATE.BAT
Скрипт для обновления базы R-Keeper

#FTPD.BAT
Скрипт стартует FTP Server

#GHOST.BAT
Скрипт запускает GHOST.EXE в качестве параметра передается модифицированный GHOST.SCR, в котором вместо UNIT подставляется переменная %HOSTNAME%-DATETIME (DATETIME в формате "DDMMYY-hhmm")

#MTCP.BAT
Скрипт обновляет время на кассе, синхронизируя его с %POOLSITE% и отправляет информацию о старте станции на %SYSLOG% сервер на порт %SYSLOGP%

#RKUPDATE.BAT
Скрипт обновляющий RKCLIENT. Скрипт берет из CFILE параметр TYPE и загружает с сервера архив %TYPE%.zip. После чего производит архивирование текущий директории RKCLIENT в папку %BACKUPDIR%\DATETIME (DATETIME в формате "DDMMhhmm"). После чего распаковывает новый RKCLIENT и в зависимости от станции (официантская или кассовая) копирует необходимые файлы из папки SERVER. Далее он восстанавливает исходные RKEEPER6.INI, LOCAL.DB, SYSTEM.DB и папку FORMS

#CFILE
Конфигурационный файл, содержащий в себе настройки для каждого юнита. Первый параметр UNIT должен быть равен параметру HOSTNAME в скрипте PARAMS.BAT соответствующей станции. При использовании параметра RK6 запускается RKEEPER, а, следовательно, использование 5го параметра не обязательно

#FTPASSWD
Содержит список пользователей с паролями, которым разрешен доступ по FTP при запущенном FTP сервере. Данный файл автоматически копируется в папку MTCP, где располагается FTPSRV.EXE
