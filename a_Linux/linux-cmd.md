
`apt` is designed for end-users (human) and its output may be changed between versions.
`apt-get` may be considered as lower-level and "back-end", and support other APT-based tools. 
### [LINUX Commands map](https://xmind.app/m/WwtB/#)

## How to view all installed packages in terminal
~$ apt list python3 --installed 
~$ apt list --installed | wc -l      -  see how many entries there are
~$ apt list --installed | grep xfonts  -  find packages of interest
~$ apt list --installed > pkgsInstalled  -  сохранить список в файл
~$ dpkg -l > pkgsInstalledDetailed  -  сохранить ПОДРОБНЫЙ список в файл
~$ dnf list installed
~$ flatpak list --app
~$ snap list
~$ pacman -Q

## Чтение .txt в консоли
~$ `cat logs/iskcon.log`  -  удобна для маленьких файлов:
~$ `less logs/iskcon.log`  -  для БОЛЬШИХ файлов. Можно редактировать.

## Запустить .jar
~$ java -jar TelegramBot.jar                   | run .jar
~$ nohup java -jar TelegramBot.jar        | запускать процессы, которые продолжат работать 
			 | после выхода из системы или закрытия терминала, 
             | игнорируя сигналы завершения работы от системы 
             
Чтобы убить такой процесс:
~$ ps -ef | grep 'file.jar'                           | отфильтровать  по имени  JAR-файла
~S kill 11701                                              | убить процесс  (цифры - PID из прошлого запроса)
~S kill -9 PID

## Работа с файлами (папками)
~$ cd ..                            |  подняться выше (в родителя)
~$ cd /home                    |  перейти в папку /home

~$ ls                                 |  содержимое папки (скрытые НЕ видно)
~$ ls la                              | все содержимое включая скрытые

~$ mkdir newflname        | создать папку
~$ mkdir fl1 fl2                 | создать сразу 2 и более папки
~$ mkdir -p folder/subfolder/subsubfolder

~$ touch filename.txt      | создать пустой файл
~$ nano filename.txt        | простой текст. ред.
~$ vim filename.txt          | мощный текст. ред.

~$ rm file/name.jar           |  удалить файл (папку)  -  БЕЗВОЗВРАТНО
~$ rm -r путь/к/дир         |  удалить папку со всем содержимым   -  БЕЗВОЗВРАТНО

~$ gio trash file.jar            |  удалить файл  -  В КОРЗИНУ  (утилита `gio`)
~$ trash-put file.jar            |  удалить файл  -  В КОРЗИНУ  (утилита `trash-cli`)

## Менеджеры пакетов
~$ rpm  -  Fedora, CentOS, openSuse
~$ dpkg  -  Debian  (.deb)
~$ apt в  -  Ubuntu (.deb)
~$ pacman  -  Arch  (`Octopi` - gui для pacman)
~$ dnf   -   Fedora (змінив Yum)


~$ snap help        система развёртывания программного обеспечения и управления пакетами. 
~$ flatpak —help    утилита-платформа для развёртывания, управления пакетами и виртуализации
                     

Из собственного опыта получил очередь использования менеджеров пакетов:
-  на apt ищем пакет (приложение) в первую очередь. Здесь лежат последние стабильные версии. Это менеджер самой ОС (вроде)
- на **flatpak** обычно самые новые версии. Вроде все нормально работает.
- на *snap* смотрим *в последнюю очередь*. Здесь версии могут быть НЕ последние (как в случае с Android Studio) и не стабильные (как в случае с scrcpy)
## Установка пакета

~$ sudo apt install scrcpy
~$ sudo snap install scrcpy 
     папка /home/samos/snap/scrcpy создается при каждом запуске приложения. Ее можно смело удалять.

## Удаление пакета

~$ dpkg --list                         |    To see all installed packages
~$ apt list --installed             |    The same but more useful

~$ sudo apt purge scrcpy     |  uninstalls scrcpy and deletes all the configuration files
~$ sudo apt remove scrcpy  |  uninstalls scrcpy but not remove configuration files
~$ sudo apt autoremove       | To remove any unused packages
~$ sudo apt update               |  Update all packages
~$ sudo apt full-upgrade      |  Upgrade all packages
~$ sudo apt dist-upgrade

~$ sudo apt clean                  |  If you’re short on space, you can use the “clean” 
											command to remove downloaded archive files

~$ sudo apt-get --fix-broken install          | Identify and Remove Conflicting Packages

~$ xdg-settings get default-web-browser  -  узнать какой сейчас дефолтный браузер
~$ xdg-settings set default-web-browser firefox.desktop -  засетить дефолтный браузер



~$ sudo apt-get install -y java-11-amazon-corretto-jdk 
(https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/generic-linux-install.html)