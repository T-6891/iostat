**Мониторинг Zabbix Linux iostat** 
-----

**Описание**
-----

Инструмент мониторинга производительности дисковой подсистемы Linux для Zabbix

Что представляет из себя данный репозиторий?

* Каталог со скриптами и шаблоном для Zabbix

```
 ./iostat/
  ├── README.md
  ├── scripts
  │   ├── iostat-collect.sh
  │   └── iostat-parse.sh
  └── template
      └── Template_OS_Linux_IOSTAT.xml

2 directories, 4 files
```
 * **iostat** - корневой каталог
 * **README.md** - описание репозитория
 * **scripts** - каталог со скриптами
 * **iostat-collect.sh** - скрипт сбор данных
 * **iostat-parse.sh** - скрипр парсер
 * **template** - каталог шаблонов
 * **Template_OS_Linux_IOSTAT.xml** - основной шаблон


**Установка**
-----

**Внимание!** - Перед установкой необходимо наличие в системе установленных компонентов 
 * zabbix-agent
 * sysstat

Загрузить репозиторий

```
cd /tmp/
git clone https://github.com/T-6891/iostat.git
```
Создать рабочий каталог, скопировать в него скрипты.
```
mkdir /opt/.master/zabbix/
cp -R /tmp/iostat/ /opt/.master/zabbix/
chmod +x /opt/.master/zabbix/iostat/scripts/*
```
Добавить задание в планировщик
```
vim /etc/crontab
```
```
# Zabbix monitoring iostat
59 23 * * *      root    /opt/.master/zabbix/iostat-collect.sh
```



**Настройка**
-----


**Проверка**
-----
