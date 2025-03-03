
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

~$ apt help
~$ snap help
~$ flatpak —help

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

~$ sudo apt clean                  |  If you’re short on space, you can use the “clean” 
											command to remove downloaded archive files


~$ xdg-settings get default-web-browser  -  узнать какой сейчас дефолтный браузер
~$ xdg-settings set default-web-browser firefox.desktop -  засетить дефолтный браузер

## KDE NEOn
[About KDE Neon](https://www.youtube.com/watch?v=4SegrpFOHDc)
 
[Linux (kde neon 20230928-0718)](https://neon.kde.org/download)   
Plasma: v5.27.8
Frameworks: v5.110.0
Qt: v5.15.10
Kernel: v6.2.0-33-generic (64-bit)
Graphics: X11
 
- качаем iso KDE neon
- (win11) качаем Rufus или то, что предлагают на оф. сайте neon
   (KDE) сработал только         [balenaEtcher](https://etcher.balena.io/#download-etcher)          [storage](https://github.com/balena-io/etcher/releases)
  ![[Pasted image 20230805093053.png]]
- создаём загрузочную флешку. (https://etcher.balena.io/)
- загружаемся с флешки, подключаемся к wifi, ставим ОС

[HotKeys]()
- Ctrl + H  -  показать скрытые папки и файлы (напр.:   .gradle)
- Ctrl + Alt + T  -  открыть терминал

[Obsidian](https://obsidian.md/)
- Discover  ->  flatpak "Obsidian"

[Telegram Linux](https://linux.how2shout.com/how-to-install-telegram-on-linux-desktop-in-2023/)
- **flatpak install [flathub](https://flathub.org/apps/org.telegram.desktop) org.telegram.desktop**

[Android Studio](https://developer.android.com/studio/install)
- лучше Discover -> flatpak
- или качаем Android Studio архив для линукс
- распаковываем архив в samos/Android
- запускаем файл studio.sh правой кнопкой "Запустить в Konsole"
- git clone лучше делать из консоли в нужной папке.
- [Configure hardware acceleration for the Android Emulator](https://developer.android.com/studio/run/emulator-acceleration?utm_source=android-studio#vm-linux)

[scrcpy]()
- $ **sudo apt install scrcpy**
	в snap есть новая версия, но у меня она не работает 
    находим scrcpy в меню "Пуск"
    запускаем и закрепляем иконку на панели задач

[Intellij IDEA]()
- лучше Discover -> flatpak

[VScode](https://code.visualstudio.com/docs/setup/linux)
- скачать file_name.deb
- $ **sudo apt install ./file_name.deb**

[OBS-studio](https://obsproject.com/ru)
- $ **sudo apt install obs-studio**
![[Pasted image 20230806212430.png]]

[ntfs раздел открывается только на чтение](https://www.youtube.com/watch?v=3ooi4zo-mtU) 
- находим путь раздела
  в "Диспетчер разделов от KDE"
  или GParted (ставим в Discover)
- sudo ntfsfix /dev/nvme0n1p5  -  это путь раздела

[ntfs раздел НЕ хочет монтироваться:]()
 "Error mounting /dev/nvme0n1p5 at /media/samos/artsam: Unknown error when mounting /dev/nvme0n1p5"
- Run this command to show disks:  
	~$ lsblk
- Run this command to mount usb:
	~$ sudo ntfsfix /dev/nvme0n1p5

[клавиатура настройки](https://www.linux.org.ru/forum/general/16026269)
- "Область переключения раскладки" - "Окно"
- клавиши переключения раскладки
  "Основные" - "нет"
  "Альтернативные" - "win+space"
- Переназначение кнопок (SharpKeys):
	[StackExchange answer](https://askubuntu.com/a/257497)
	Xev and xmodmap
~$ xev             |  запустит приложение, позволяющее узнать название кнопки
                        |  напр. "keycode 66 (keysym 0xffe5, Caps_Lock)""
~$ xmodmap   |  переназначает кнопки напр.
~$ xmodmap -e "keycode 94 = KP_Home"
~$ xmodmap -e "keycode 82 = KP_Prior"
~$ xmodmap -e "keycode 86 = KP_Next"
~$ xmodmap -e "keycode 91 = Return"

~$ xmodmap -pke > ~/.Xmodmap    //сохраняет карту изменений кнопок в файл
~$ xmodmap ~/.Xmodmap          //активирует эти изменения при след. входе

##### Making changes persistent across reboots:
```
~$ touch ~/.xinitrc    //create a file in your home folder called `.xinitrc`.
```
"xmodmap ~/.Xmodmap"    // Place this line in the file and save it


[The KDE Wallet System](https://docs.kde.org/stable5/en/kwalletmanager/kwallet5/kwallet5.pdf)
Это менеджер паролей
безопасно хранит пароли , ключи сетевых соединений, учетные данные браузера, ключи шифрования и т.д.