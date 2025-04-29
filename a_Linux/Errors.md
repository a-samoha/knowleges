# НЕ отображается desktop
После установки разных программ или настроек (особенно темы, и т.д.)
может перестать загружаться SDDM (Simple Desktop Display Manager)
- Если запуск компьютера "зависает" нажимаем Alt+F2 
- появится консоль и предложит ввести логин и пароль (имя и пароль которые вводил при установке ОС)
~$ journalctl -xe                               |  Посмотреть логи ошибок
~$ journalctl  -u sddm                     |  конкретно ошибки SDDM
~$ lspci -k | grep -EA3 'VGA|3D'     | Проверьте видеодрайвер
~$ dpkg -l | grep libqt6                    |  какие версии Qt6 установлены
в последний раз помогло "Обновление пакетов" смотри файл  'linux-cmd'

##### ERROR: Failed to load /snap/dotnet-sdk/168/shared/Microsoft.NETCore.App/6.0.5/libcoreclr.so, error: /lib/x86_64-linux-gnu/libpthread.so.0: version `GLIBC_PRIVATE' not found (required by /snap/core18/current/lib/x86_64-linux-gnu/librt.so.1)

Эта ошибка возникает если .NET SDK на KDE Neon установлен криво.
У меня это было когда пытался пользоваться .NET SDK установленным из snap.
RESOLVING: 
	 ~$ sudo snap remove dotnet-sdk   ( uninstall .NET SDK)
	 ~$  sudo apt update
	 ~$ sudo apt-get install -y dotnet-sdk-8.0 



##### ERROR: The requested operation has failed: Error mounting /dev/nvme0n1p5 at /media/samos/artsam: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error

RESOLVING: 
	- install `KDE Partition Manager`
	- run it as admin
	- right click on target disk ( e.g. `nvme0n1p5`)
	- click on `Edit Mount Point`
	- write the path: `/media/samos/artsam`
	- confirm file overwrite
	- now You can mount the disk