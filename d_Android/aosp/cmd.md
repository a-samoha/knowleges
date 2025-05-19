### Native Google (aosp)  
  
##### Download

`repo`— это инструмент командной строки, разработанный Google специально для работы с исходным кодом Android (AOSP) потому, что очень много разных репозиториев где лежат исходники. repo сам знает что откуда скачивать.
- `repo init --partial-clone --no-use-superproject -b android-latest-release -u https://android.googlesource.com/platform/manifest` 

– Initialize your working directory for source control
- `repo sync -j1` — скачивает репозитории **по одному** (медленно, но стабильно).
- `repo sync -j8` — скачивает **до 8 репозиториев одновременно** (быстрее, но требует больше ресурсов).
- `repo sync -j$(nproc)` — использует **все доступные ядра** твоего процессора.
- `repo sync -c -j8`  -  The `-c` argument instructs Repo to fetch the current manifest branch from the server.

##### Build
 Выполняем в корне исходников AOSP:
(где есть `.repo/`, `build/`, `device/`, `frameworks/` и т.д.)

1. **Подготовка окружения**
- `source build/envsetup.sh`  --  Загружает переменные и функции сборочной среды (обязательный шаг перед сборкой).
2. **Выбор конфигурации сборки**
- `lunch aosp_x86_64-eng`  --  Выбирает целевое устройство и тип сборки. (у меня aosp_cf_x86_64_phone-trunk_staging-eng)
3. **Cборка Android**
- `make -j$(nproc)`  --  Собирает Android с использованием всех доступных ядер процессора (`$(nproc)` = число ядер).
4.  **Запуск Android в эмуляторе**
- `sudo apt install qemu-kvm`  -  Установи необходимые зависимости
- `emulator`  --  Запускает стандартный эмулятор (если установлен через SDK).
- `out/soong/host/linux-x86/bin/emulator`  --  Запускает эмулятор, **собранный из AOSP**.
	- `out/host/linux-x86/bin/emulator`  --  Запускает эмулятор, **собранный из AOSP**.
- `emulator -verbose -show-kernel -no-snapshot -wipe-data`  --  подробный запуск, с очисткой состояния и выводом ядра.
1. **Проверка образов после сборки**
- `ls out/target/product/*/`  --  Убедись, что есть образы: system.img, userdata.img, ramdisk.img ...

### Custom aosp  (AndroidHMI)
  
Download
1. Download aosp 14 with branch android-14.0.0_r22
    - `repo init --depth=1 --partial-clone -b android-14.0.0_r22 -u https://android.googlesource.com/platform/manifest`
    - `repo sync -c -j8`

2. Download and paste FOXCONN source code files to 
	- AOSP-R22/vendor/ceer/  
		[посилання на  vendor](https://luxproject.luxoft.com/stash/projects/FOXCOA/repos/androidhmi/browse?at=refs%2Fheads%2Flfs-vendor)
		Vendor - промежуточный слой между "чистым" Android и "железом" (hardware).
	- AOSP-R22/device/foxconn/foxconn_emu_car
		[посилання на device](https://luxproject.luxoft.com/stash/projects/FOXCOA/repos/androidhmi/browse?at=refs%2Fheads%2Fdevice)
		Device - файлы настройки сборки для конкретных моделей устройств.

3. Build  
    ~$ source build/envsetup.sh  
    ~$ lunch foxconn_emu_car-userdebug  
    ~$ m j16 (make -j18 -C $TOP)