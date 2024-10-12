
~$ `sudo apt update` 
~$ `sudo apt install postgresql postgresql-contrib`   -   установить
~$ `sudo systemctl status postgresql`   -   статус
~$ `sudo systemctl start postgresql`   -   запустить
~$ `sudo systemctl enable postgresql`  -  автоматически запускать при загрузке системы
~$ `sudo systemctl restart postgresql`  -  перезагрузить
~$ `sudo systemctl stop postgresql`       -  остановить
~$ `sudo systemctl disable postgresql`  - отключить автозапуск при загрузке

~$ `ps aux`  -  вывести все запущенные процессы
~$ `ps aux | grep postgres`  -  отфильтровать процессы по "postgres"

~$ `sudo ss -tuln | grep 5432`  -   проверить, на каком порту запущена PostgreSQL
~$ `cat /etc/postgresql/<версия>/main/postgresql.conf | grep -i port`  
					-   прочитать файл настроек и увидеть какой порт

## Настройка PostgreSQL
 **Default настройка PostgreSQL**. По-умолчанию PostgreSQL создает пользователя `postgres` для управления базами данных. Чтобы начать использовать PostgreSQL, нкжно переключиться на этого пользователя (есть 2 варианта):

### Переключив cmd полностью на user `postgres`:
~$ `sudo -i -u postgres`  -  `-i` переключает оболочку на user `postgres` 
							(включая его пути, переменные окружения и т.д)
~$ `psql`  -  войти в командную строку PostgreSQL
			в cmd будет видно именно БД к которой сейчас подключены, напр.:
			 ~postgres=>

### Oставаясь под оболочкой `samos`:
~$ `sudo -u postgres psql`  -  выполняет команду `psql` авторизуясь как user `postgres`
		ПО-УМОЛЧАНИЮ пытается подключиться к БД с именем идентичным username (`postgres`)
		Если мы создали user, а БД с идентичным username НЕТ - получаем ERROR, напр.:
		~$ `sudo -u username psql`  -   выдаст ошибку   "FATAL:  database "username" does not exist"
			НО, можно с кастомным user подключиться к дефолтной БД `postgres`:
		~$ `sudo -u samos psql -d postgres`
### Создаем пользователя:
~postgres=> `\du`  -  список существующих пользователей
~postgres=> `\l`  -  список существующих БД

~postgres=> `CREATE ROLE samos CREATEDB LOGIN PASSWORD '35487';`  -   создать user "samos" & psw "35487"
		                    `CREATEDB`       -   дать право создавать БД
		                    `SUPERUSER`     -   назначить супер-пользователем
		                     `CREATEROLE`  -   дать право создавать других пользователей
		                     можно использовать все вместе

~$ `sudo -u samos psql -d postgres`  -  войдем в БД `postgres` как user `samos`

~postgres=> `CREATE DATABASE db_name`   -   создадим БД `db_name`
~postgres=> `\c db_name`   -   переключимся на  БД `db_name` как user `samos`

~db_name=> `CREATE TABLE chat_records (id SERIAL PRIMARY KEY, chat_id BIGINT NOT NULL, action VARCHAR(255) NOT NULL, is_chanting BOOLEAN NOT NULL DEFAULT false, timestamp TIMESTAMP NOT NULL)`
	- создаем таблицу

~db_name=> `DROP DATABASE db_name;`        -   удалить БД
~db_name=> `DROP TABLE chat_records;`    -   удалить ТАБЛИЦУ


~$ `\q`   -   Выйти из psql


~$ `createuser --interactive`  -   создать ползователя
~$ `createdb mydatabase`  -   создать БД
~$ `psql -d mydatabase`  -  подключиться к БД

### Внутренние команды `psql`

- **`\q`**: Выход из `psql`.
- **`\c [database] [user]`**: Подключение к другой базе данных или смена пользователя.
- **`\d`, `\dt`, `\di`, `\dv`, `\ds`, `\df`**: Список таблиц, индексов, представлений, последовательностей, функций соответственно.
- **`\l` или `\list`**: Список баз данных.
- **`\du` или `\dg`**: Список пользователей и их прав.
- **`\g` или `;`**: Выполнить последний запрос.
- **`\i filename`**: Выполнить SQL-скрипт из файла.
- **`\s [filename]`**: Показать или сохранить историю команд.
- **`\e`**: Открыть последний запрос в редакторе.
- **`\x`**: Включение/выключение расширенного режима отображения результатов.
- **`\?`**: Показать справку по внутренним командам `psql`.

### Флаги командной строки `psql`

- **`-d dbname`, `--dbname=dbname`**: Подключение к указанной базе данных.
- **`-U username`, `--username=username`**: Использование указанного имени пользователя для подключения.
- **`-W`, `--password`**: Принудительный запрос пароля перед подключением к базе данных.
- **`-h hostname`, `--host=hostname`**: Подключение к серверу баз данных на указанном хосте.
- **`-p port`, `--port=port`**: Подключение к серверу баз данных на указанном порту.
- **`-e`, `--echo-queries`**: Показывать запросы, отправляемые в базу данных.
- **`-c command`, `--command=command`**: Выполнить указанную команду (SQL или внутреннюю команду `psql`), а затем выйти.
- **`-f file`, `--file=file`**: Выполнить команды из указанного файла, а затем выйти.
- **`-l`, `--list`**: Вывести список всех баз данных и выйти.
- **`-v variable=value`, `--set=variable=value`**: Установить переменную `psql` или переменную среды.
- **`-X`, `--no-psqlrc`**: Не читать стартовый файл `.psqlrc` при запуске.
- **`-q`, `--quiet`**: Подавить приветственные сообщения и другие несущественные выводы.
- **`-a`, `--echo-all`**: Показывать все вводимые команды.
- **`-i`, `--ignore-space`**: Игнорировать пробелы в начале строки при выполнении скриптов.

Это основные, но не все флаги и команды, доступные в `psql`. Для получения полной информации вы можете обратиться к официальной документации PostgreSQL или использовать команду `psql --help` для флагов и `\?` для внутренних команд в `psql`.

### Дополнительные Настройки

 **Настройте PostgreSQL** по вашим потребностям. Можете настроить аутентификацию, доступы и т.д. в файле конфигурации PostgreSQL, обычно находящемся в `/etc/postgresql/<версия>/main/pg_hba.conf`.


### Errors
- Почему выполняя `psql -U iskcon -d iskcon` я получаю ошибку: `FATAL: Peer authentication failed for user "iskcon"`    -     Метод `peer` позволяет подключаться к базе данных, **если имя пользователя операционной системы совпадает с именем пользователя базы данных** и не требует пароля.