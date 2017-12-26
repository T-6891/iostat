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
rm -rf /tmp/iostat/
```

**Настройка**
-----

Добавить задание в планировщик
```
vim /etc/crontab
```
```
# Zabbix monitoring iostat
59 23 * * *      root    /opt/.master/zabbix/iostat/scripts/iostat-collect.sh > /dev/null 2>&1
```
Добавить параметры сбора статистики в конфигурационный файл Zabbix агента
```
vim /etc/zabbix/zabbix_agentd.conf
```
```
# Disk statistics iostat
UserParameter=iostat.discovery, iostat -d | awk 'BEGIN {check=0;count=1;array[0]="total";} {if(check==1 && $1 != ""){array[count]=$1;count=count+1;}if($1=="Device:"){check=1;}} END {printf("{\n\t\"data\":[\n");for(i=0;i<count;++i){printf("\t\t{\n\t\t\t\"{#HARDDISK}\":\"%s\"}", array[i]); if(i+1<count){printf(",\n");}} printf("]}\n");}'
UserParameter=iostat.metric[*],/opt/.master/zabbix/iostat/scripts/iostat-parse.sh /tmp/iostat-collect.tmp $1 $2
```
Запуск сбора статистики
```
/opt/.master/zabbix/iostat/scripts/iostat-collect.sh
```
Применение настроек агентом
```
systemctl restart zabbix-agent.service
```

**Проверка**
-----
