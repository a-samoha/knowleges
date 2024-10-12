
- EC2 (Elastic Compute Cloud), один из самых популярных и универсальных вариантов для запуска серверных приложений.

- Развертывание и запуск бота в AWS

### 1. Создание сервера EC2 Instance:
    - Войдите в AWS Management Console.
    - Перейдите в сервис "EC2".
    - Нажмите кнопку “Launch Instance” для создания нового экземпляра.
    - Выберите подходящий образ ОС (например, Ubuntu Server).
    - Выберите тип инстанса (например, t2.micro, который входит в бесплатный тариф).
    - Пройдите процесс настройки инстанса (настройки сети, группы безопасности и т.д.).
    - Создайте новую пару ключей (ключ доступа и закрытый ключ) для доступа к инстансу через SSH.

![[t2-server-settings.png]]

### 2. Подключение к работающему EC2 Instance:
    - Используйте SSH для подключения к нему. 
    - Для этого вам понадобится закрытый ключ, который вы создали.
    - $ ssh -i /path/to/your-key.pem ubuntu@<public-ip-address> 
    - переходим в папку где храним key.pem
    - $ ssh -V                           // проверить версию ssh
    - $ sudo apt update                  // обновить пакеты
    - $ sudo apt install openssh-client  // если ssh не установлен
    
    - $ ssh -i ISKCON-Telegram-Bot-Key-pair.pem ubuntu@ec2-3-70-237-51.eu-central-1.compute.amazonaws.com
    - // если получили ошибку "Permissions 0777 for 'I...r.pem' are too open" делаем:
    - chmod 600 ISKCON-Telegram-Bot-Key-pair.pem      // выполнить в папке с ключем
    - ls -l ISKCON-Telegram-Bot-Key-pair.pem          // проверить, что права доступа изменились 

### 3. Установка необходимых зависимостей:
    - Установите Java (Kotlin требует JVM для выполнения):
    - $ java -version
    - $ sudo apt install openjdk-17-jre-headless

### 4. Загрузка и запуск бота:
    - Вы можете загрузить код вашего бота на сервер через SCP:
    - $ scp -i ISKCON-Telegram-Bot-Key-pair.pem iskcon-realtime-japa.jar ubuntu@ec2-3-70-237-51.eu-central-1.compute.amazonaws.com:/home/ubuntu
    - $ cd /home/ubuntu
    - $ ls  // покажет список файлов в текущей папке (TelegramBot.jar)
    - Запустить бот: 
    - $ java -jar TelegramBot.jar

- Запустить JAR-файл так, чтобы он продолжал работать после закрытия SSH-сессии
#### nohup
`~$ nohup java -jar TelegramBot.jar`        | запускать процессы, которые продолжат работать 
                                    | после выхода из системы или закрытия терминала, 
                                    | игнорируя сигналы завершения работы от системы 
Чтобы убить такой процесс:
`~$ ps -ef | grep 'file.jar'`                     | отфильтровать  по имени  JAR-файла
`~S kill 11701`                                                | убить процесс  (цифры - PID из прошлого запроса)
`~S kill -9 PID`

#### screen
позволяет создавать несколько терминальных сессий в одном SSH и 
продолжать работу в них даже после выхода из SSH-соединения.

``~$ sudo apt install screen`      |  **Установите `screen`**, если он еще не установлен:
`~$ screen`                                      |  **Создайте новую сессию `screen`**
`~$ java -jar /path/to/file.jar`     |  **Запустите ваш JAR-файл**    
~$  Нажмите `Ctrl` + `A`, затем `D` для отключения от сессии `screen`.
~$  Вернуться к сессии позже, используя команду `screen -r`.