
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
		качаем    sudo apt install ./balena-etcher_version_amd64.deb
		дабл клик по этому файлу.
		откроется Discover и  устанавливаем
![[Pasted image 20230805093053.png]]
- создаём загрузочную флешку. (https://etcher.balena.io/)
- загружаемся с флешки, подключаемся к wifi, ставим ОС
- после установки :
  - $ **sudo apt update**
  - $ **sudo apt full-upgrade** (если ручками) **sudo apt-get dist-upgrade** (если в скрипте)
  - меняем Global Theme:  Apple WhiteSur-dark (0.5M downloads)                  - Apple Venture Dark P6 + Edna (тут берем Colors & Window Decoration)
  - ставим Widow Rules:
  ![[Plasma_win_rules.png]]

[Смонтировать диск в нужное место]()
- ~$ sudo blkid                         | получить UUID всех физических разделов
- ~$ sudo nano /etc/fstab       | открыть файл fstab на редактирование
- записать в нем строки:
	`UUID=6..f   /home/samos/develop   ext4    nofail   0 0`
	`UUID=A...d  /home/samos/artsam    ntfs    nofail   0 0`

[Установить подходящие драйвера]()
- ~$ ubuntu-drivers devices
- ~$ sudo ubuntu-drivers autoinstall //  ОПАСНО!!! В последний раз переустанавливал ОС

[HotKeys]()
- Ctrl + H  -  показать скрытые папки и файлы (напр.:   .gradle)
- Ctrl + Alt + T  -  открыть терминал

[Obsidian](https://obsidian.md/)
- Discover  ->  flatpak "Obsidian"

[Telegram Linux](https://linux.how2shout.com/how-to-install-telegram-on-linux-desktop-in-2023/)
- лучше Discover -> flatpak
- или $**flatpak install [flathub](https://flathub.org/apps/org.telegram.desktop) org.telegram.desktop**

[Android Studio](https://developer.android.com/studio/install)
- лучше Discover -> flatpak
- или качаем Android Studio архив для линукс
- распаковываем архив в samos/Android
- запускаем файл studio.sh правой кнопкой "Запустить в Konsole"
- git clone лучше делать из консоли в нужной папке.
- [Configure hardware acceleration for the Android Emulator](https://developer.android.com/studio/run/emulator-acceleration?utm_source=android-studio#vm-linux)
- Студия выжерает всю оперативную память (ставил из flatpak). Лечим:
	  [Inotify Watches Limit (Linux)](https://youtrack.jetbrains.com/articles/SUPPORT-A-1715/Inotify-Watches-Limit-Linux)
	  it is recommended to increase the watches limit (to, say, 1048576):
		1. Add the following line to a new `*.conf` file (e.g. `idea.conf`) under `/etc/sysctl.d/` directory:  
		    `fs.inotify.max_user_watches = 1048576`
		2. Then run this command to apply the change:  
		    `sudo sysctl -p --system`
			And don't forget to restart your IDE.
- Ограничение памяти (при установке студии из flatpak):
	~$ nano ~/.var/app/com.google.AndroidStudio/config/studio.vmoptions    | создать файл в указанной папке
	в этом файле сохранить настройки (комментарии удалить):
	```
	-Xms4096m  // устанавливает начальный размер кучи JVM в 4 ГБ
	-Xmx8192m  // устанавливает максимальный размер кучи JVM в 8 ГБ
	-XX:ReservedCodeCacheSize=1024m  // размер кэширования скомпилированного кода
	-XX:+UseCompressedOops // включает использование сжатых указателей (может снизить потребление памяти)
	```
	Metaspace — область памяти вне кучи (off-heap), для хранения метаданных классов, загружаемых JVM. Начиная с Java 8, Metaspace заменил PermGen и по умолчанию может автоматически расширяться, ограничиваясь только доступной физической памятью .
	Потребление памяти Metaspace зависит от количества и сложности загружаемых классов. В типичных приложениях Metaspace использует от 50 до 300 МБ. Однако при работе с большими проектами или множеством плагинов, особенно в Android Studio, это значение может быть выше. 
	Если возникнет необходимость в ограничении Metaspace, добавьте параметр `-XX:MaxMetaspaceSize=512m` (или другое подходящее значение).
    Для большинства случаев рекомендуется НЕ устанавливать ограничение на размер Metaspace, позволяя JVM управлять им автоматически.
	Добавьте следующую строку в файл `~/.bashrc`, или соответствующий файл конфигурации вашей оболочки:
	```
	export STUDIO_VM_OPTIONS=~/.var/app/com.google.AndroidStudio/config/studio.vmoptions
	```
	Затем примените изменения:
	 - ~$ source ~/.bashrc


[scrcpy]()
- $ **sudo apt install scrcpy**
	в snap есть новая версия, но у меня она не работает 
    находим scrcpy в меню "Пуск"
    запускаем и закрепляем иконку на панели задач

[Intellij IDEA]()
- лучше Discover -> flatpak

[VScode](https://code.visualstudio.com/docs/setup/linux)
- скачать file_name.deb (e.g.: `code_1.97.2-1739406807_amd64.deb`)
- $ **sudo apt install ./file_name.deb**
- можно дважды кликнуть на .deb файл и Discover предложит установить этот файл. Install ...

[.net Install the SDK](https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install?tabs=dotnet8&pivots=os-linux-ubuntu-2410#install-the-sdk)
	~$  sudo apt update
	~$  sudo apt-get install -y dotnet-sdk-8.0 
    ~$  dotnet --version  -  проверить версию
	[Hello World tutorial](https://dotnet.microsoft.com/en-us/learn/dotnet/hello-world-tutorial/next)

[QEMU/KVM (Kernel-based Virtual Machine)](https://developer.android.com/studio/run/emulator-acceleration)
	Если ваш процессор поддерживает виртуализацию (**VT-x** для Intel, **AMD-V** для AMD)
	**Установите QEMU и KVM**
		~$  sudo apt install qemu-kvm virt-manager libvirt-daemon-system libvirt-clients bridge-utils
		~$  sudo systemctl enable --now libvirtd
	**Добавьте себя в группу KVM**
		~$  sudo usermod -aG libvirt $(whoami)
Запустите Virtual Machine Manager (virt-manager)
		~$  virt-manager
	Создай VM (RAM 8192, CPU 12, SATA  65,536; Display Spice Address port 5900; Video VGA or QXL)
 Чтобы масштабировать окно VM  выполни в консоли (при рабоающей VM):
         ~$ remote-viewer spice://localhost:5900

Failed to load /snap/dotnet-sdk/168/shared/Microsoft.NETCore.App/6.0.5/libcoreclr.so, error: /lib/x86_64-linux-gnu/libpthread.so.0: version `GLIBC_PRIVATE' not found (required by /snap/core18/current/lib/x86_64-linux-gnu/librt.so.1)

[OBS-studio](https://obsproject.com/ru)
- $ **sudo apt install obs-studio**
  - Sources: "Screen Capture(Pipe wire)"
  - Left click on preview -> Transform -> Edit Transform
	- Position Alignment: "Top Left"
	- Bounding Box Type: "Stretch to bounds"
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

- **Переназначение кнопок на х11** (не работает на Wayland) (SharpKeys):
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

- **Переназначение кнопок на Wayland** 
~$ xev             |  запустит приложение, позволяющее узнать название кнопки
            |  напр. "keycode 66 (keysym 0xffe5, Caps_Lock)""
~$ sudo apt install input-remapper
~$ sudo input-remapper-gtk
		- AT Translated Set 2 keyboard
		- Create new preset
		- Set name: `plus-to-next`.
		- Turn on `Autoload`
		- Input: `Add`
			- Record: target click btn `+`
		- Output: `Key or Macro`
			- Target : `keyboard`
			- Print: `KP_Next`

##### Making changes persistent across reboots:
```
~$ touch ~/.xinitrc    //create a file in your home folder called `.xinitrc`.
```
"xmodmap ~/.Xmodmap"    // Place this line in the file and save it


[The KDE Wallet System](https://docs.kde.org/stable5/en/kwalletmanager/kwallet5/kwallet5.pdf)
Это менеджер паролей
безопасно хранит пароли , ключи сетевых соединений, 
учетные данные браузера, ключи шифрования и т.д.
