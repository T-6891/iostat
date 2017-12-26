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

**Внимание!** - Перед установкой необходимо наличие в систему установленного пакета zabbix-agent

Загрузить репозиторий
```
cd /tmp/
git clone https://github.com/T-6891/iostat.git
cd iostat/

```

**Настройка**
-----


**Проверка**
-----
