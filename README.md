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

**Клиентская часть**
-----
Настройки данного раздела проводятся на удаленном хосте, который требуется добавить в систему мониторинга.

**Установка**
-----

**Внимание!** - Перед установкой необходимо наличие в системе установленных компонентов 
 * git
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

Серверная часть
-----
Настройка производится на сервере Zabbix

Установка шаблона на сервер. (Если еще не установлен на сервере)

 * Перейти в контрольную панель вашего Zabbix сервера
 * Меню - Настройка
 * Меню - Шаблоны
 * Вверхнем правом углу - Импорт
 * Поле - Импортировать файл
 * Обзор - указать путь к файлу шаблона 'Template_OS_Linux_IOSTAT.xml'
 * Импорт

Подключение шалона для удаленного хоста.

 * Настройка
 * Узлы сети
 * В поле фильтра - **Имя** указать имя удаленного хоста
 * Если хост найден, нажать на него в списке
 * В свойствах хоста - Шаблоны
 * В поле **Соединить с новыми шаблонами** ввести имя шалона - **Template OS Linux IOPS Iostat**
 * Добавить
 * Обновить


**Проверка**
-----
Проверка автоопределения дисков
```
zabbix_agentd --test iostat.discovery
```
Пример вывода
```
iostat.discovery                              [t|{
	"data":[
		{
			"{#HARDDISK}":"total"},
		{
			"{#HARDDISK}":"sda"},
		{
			"{#HARDDISK}":"dm-0"},
		{
			"{#HARDDISK}":"dm-1"}]}]

```
