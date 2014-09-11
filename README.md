RKStation 0.11
==================

Remote maintenance R-Keeper v6 for DOS

Набор BAT файлов для удаленного управления станциями R-Keeper v6 под Dos.

Все управление осуществляется посредством файла CFILE, лежащего на сервере в архиве %BUNDLE%.zip. Касса при запуске скачивает с сервера архив %BUNDLE%.zip, распаковывает его и запускает файл %GO%. Далее, в зависимости от настроек CFILE, выполняет соответствующие функции.

Так же следует учесть, что перед скачиванием любого архива %BUNDLE%.zip, %RKUPDF%.zip или %RKTYPE%.zip касса проверяет были ли сделаны в нем изменения и стоит ли его качать. Для этого самым первым качается файл %MD5%, который содержит MD5 для каждого архива: %BUNDLE%.zip, %RKUPDF%.zip и %RKTYPE%.zip. Поэтому при изменении соответствующего архива на сервере не забудьте поменять MD5 для него в файле %MD5%.  

Основные функции
================
1.	Централизованное обновление RKeeper DB
2.	Централизованное обновление каталога RKCLIENT
3.	Запуск FTP Сервера на кассе
4.	Создание резервной копии всего диска (при наличие Norton GHost)
5.	Запуск Linux под Dos (в данном случае запускается BOOT.BAT из C:\Linux, соответственно можно использовать для запуска любой своей программы)

#Централизованное обновление RKeeper DB
Позволяет обновлять базу централизовано, средствами самой кассы. Касса в момент запуска проверяет наличие на сервере обновленного архива с базой (В зависимости от типа кассы COFFEE.ZIP, HOTEL.ZIP и т.д., тип кассы указывается в файле CFILE), если такой существует – автоматически закачивает его и распаковывает в директорию (по умолчанию DBDIR=C:\RKCLIENT\EXTDB).  

В файле LOCAL.DB RKeeper должна быть указана ссылка на %DBDIR%.

#Централизованное обновление каталога RKCLIENT
Позволяет провести обновление всех касс на новую|старую версию RKeeper. Для этого необходимо на сервере поместить архив %RKUPDF%.zip, содержащий новую версию RKCLIENT (официантская станция) и содержащий папочку SERVER внутри RKCLIENT (содержит файлы для кассовой станции).

#Запуск FTP Сервера на кассе
Запускает полноценный FTP Сервер на кассе.

#Создание резервной копии всего диска
Используя утилиту Norton GHost создает на внешнем диске образ текущего диска. В качестве параметров используется файл GHOST.SCR, в котором путь dst=x:\gho\$$$.gho заменяется на dst=x:\gho\%DATETIME%.gho (DATETIME в формате "DDMMhhmm")

#Запуск Linux под Dos
Запускает BOOT.BAT из C:\Linux, соответственно можно использовать для запуска любой своей программы

Установка
=========
1.	Поместить START.BAT и PARAMS.BAT в корень диска C:\
2.	Прописать в AUTOEXEC.BAT запуск скрипта START.BAT. Прописать TimeZone: TZ=UTC-4 и NORK6=NO (значение по умолчанию)
3.	Установить и настроить MTCP (http://www.brutman.com/mTCP/) и BASIC Linux (либо любой другой Linux, тогда необходимо поменять параметры запуска в переменной %STLINUX%)
4.	Дополнительные утилиты поместить в папку C:\UTILS (Либо в любую другую папку из окружения PATH):
  5.	UNZIP32.EXE (http://www.freedos.org/software/?prog=unzip)
  6.	MD5.EXE (http://thestarman.pcministry.com/DOS/MD5progs.html#3L)
  7.	GHOST.EXE (http://ru.norton.com/)
  8.	REALDATE.COM (http://www.huweb.hu/maques/realdate.htm)
  9.	UNIX2DOS.EXE (http://www.efgh.com/software/unix2dos.htm)
  10.	TIMENOW.EXE
  11.	FAM.COM, PIPESET.COM, TR.COM (http://www.bttr-software.de/products/jhoffmann/dosutils.zip)
  12.	FDAPM.EXE (http://www.freedos.org/software/?prog=fdapm) 
13.	Настроить переменные в файле PARAMS.BAT в соответствии с Вашей системой
14.	Подготовить %BUNDLE%.zip содержащий DBUPDATE.BAT, FTPD.BAT, GHOST.BAT, GO.BAT, MTCP.BAT, RKUPDATE.BAT, CFILE, FTPASSWD
15.	Подготовить файл %MD5%, пример можно посмотреть в папке SAMPLE
16.	Поместить %BUNDLE%.zip, %RKUPDF%.zip, %RKTYPE%.zip и %MD5% на %SERVER%

Файлы
=====
#START.BAT
Стартовый скрипт. Помещается на кассу и организует загрузку %BUNDLE%.zip и %MD5% с сервера. После удачной загрузки и распаковки файлов запускает скрипт из переменной %GO%

#PARAMS.BAT
Скрипт с параметрами для станции. ОБЯЗАТЕЛЬНО исправить переменные перед запуском

#GO.BAT
Стартовый скрипт получаемый с сервера. Запускает все остальные скрипты при необходимости. Легко редактируется, т.к. загружается с сервера

#DBUPDATE.BAT
Скрипт для обновления базы R-Keeper

#FTPD.BAT
Скрипт стартует FTP Server

#GHOST.BAT
Скрипт запускает GHOST.EXE в качестве параметра передается модифицированный GHOST.SCR, в котором вместо $$$ подставляется переменная %DATETIME% (DATETIME в формате "DDMMhhmm"). ОБЯЗАТЕЛЬНО смените пароль в файле GHOST.SCR на свой

#MTCP.BAT
Скрипт обновляет время на кассе, синхронизируя его с %POOLSITE% и отправляет информацию о старте станции на %SYSLOG% сервер на порт %SYSLOGP%

#RKUPDATE.BAT
Скрипт обновляющий RKCLIENT:  
1.  Скрипт берет из CFILE параметр TYPE и загружает с сервера архив %TYPE%.zip  
2.  Производит архивирование текущий директории RKCLIENT в папку %BACKUPDIR%\%DATETIME% (DATETIME в формате "DDMMhhmm")  
3.  Распаковывает новый RKCLIENT и в зависимости от станции (официантская или кассовая) копирует необходимые файлы из папки SERVER  
4.  Восстанавливает исходные RKEEPER6.INI, LOCAL.DB (для кассовой станции), SYSTEM.DB (для кассовой станции) и папку FORMS    

#CFILE
Конфигурационный файл, содержащий в себе настройки для каждого юнита. Первый параметр UNIT должен быть равен параметру HOSTNAME в скрипте PARAMS.BAT соответствующей станции. При использовании параметра RK6 запускается RKEEPER, а, следовательно, использование 5го параметра не обязательно

#FTPASSWD
Содержит список пользователей с паролями, которым разрешен доступ по FTP при запущенном FTP сервере. Данный файл автоматически копируется с сервера в папку MTCP, где располагается FTPSRV.EXE

Changelog
==============
= 0.01 =  
* Выпуск релиза  

= 0.02 =  
* Добавлена переменная NORK6, отвечающая за запуск R-Keeper  

= 0.03 =  
* Временные файлы теперь располагаются на RAM Drive  

= 0.05 =  
* CRC32 заменен на MD5  
* Изменен размен RAM Drive 100 MB -> 50 MB  

= 0.10 =  
* Добавлен номер версии  

= 0.11 =  
* Добавлена отправка номера версии на syslog сервер