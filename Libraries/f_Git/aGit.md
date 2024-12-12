Official [documentation](https://git-scm.com/book/uk/v2) (ua)

# Help

```console
git help config    - откроет в браузере инфо про команду "config"
git cofig --help     - тот же результат
git cofig -h         - покажет короткие подсказки по "config" прямо в косноли 
```
<br/>
<br/>
<br/>

# Config

```console
$ git config --list   - список всех текщих настроек

$ git config --global user.name "Vasya Pupkin"           - установит значение для всех проектов на компе
$ git config --global user.email "vasya.pupkin@gmail.com"
```

```console
$ git config user.name "Vasya Pupkin"          - установит значение локально (только для данного проекта)
$ git config user.email "vasya@ukr.net"
```
<br/>
<br/>
<br/>

# Создание репозитория

```console
$ git init   - создаст папку .git внутри проекта
```

```console
$ git clone https://ghp_rK39wfhexamplePAToijf30jecHucw@github.com/SamoshkinR-Tem/knowleges.git
	                - это PAT(Personal Access Token)   - это адресс рекозитория

$ git clone https://github.com/libgit2/libgit2 mylibgit   - "mylibgit" это кастомное имя локальной папки проекта
```
<br/>
<br/>
<br/>

# Работа с файлами

###### Статуси файлов:
- **Tracked**
	- **Unmodified**  - после ``` $ git commit -m "Commit message"```
	- **Modified**      - внесли изменения (NOT Staged "**НЕпроиндексированный**")
	- **Staged**         - "проиндексированный", после ``` $ git add filename ```
- **Untracked**

<br/>

```console
$ git init                               - создаст папку .git внутри проекта

										   Индексация фалов:
$ git add *.c                            - добавит в stage все файлы с расширением начинающимся на букву "с"
$ git add .                              - обновит stage всеми изменениями, удалениями и новыми файлами
$ git add -u                             - добавит все изменения и удаления КРОМЕ новых файлов
$ git add LICENSE                        - индексация файла "LICENSE" в слепок будущего комита 
										   нужно выполнять какждый раз после изменения файла
$ git reset                              - используется для отмены команды 'git add .'

$ git status                             - покажет текущий stage (слепок) то, что войдет в коммит
$ git status -s                          - упрощонней вывод той же инфо. вывод
         M README                                - Modified but NOT staged
        MM Rakefile                              - Modified & staged & modified (not staged now)
        A  lib/git.rb                            - tracked
        M  lib/simplegit.rb                      - Modified & staged
?? LICENSE.txt                           - Untracked 


$ git diff                               - просмотр НЕпроиндексированных изменений
$ git diff --staged                      - просмотр только проиндексированных изменений
$ git diff --cached                      - `--staged` и `--cached` синонимы
$ git difftool                           - запускает внешнее приложение для показа изменений


$ git commit -m 'Initial project version'   
$ git commit -a -m 'Initial ...'         '-a' заставляет Git автоматически индексировать каждый отслеживаемый файл
```

<br/>

### Отмена (commit msg)

```console

$ git commit --amend -m 'Initial commit'   - смена commit MESSAGE + сохранит изменения кода, если были

$ git checkout -- LICENSE.txt            - отмена UNstaged изменений в файле "LICENSE.txt" как "revert" в AStudio

$ git restore LICENSE.txt                - отмена UNstaged изменений в файле "LICENSE.txt" как "revert" в AStudio
$ git restore --staged README.md         - отмена отслеживания (превращает в Untracked) с v2.23.0

$ git reset HEAD README.md               - отмена отслеживания (превращает в Untracked)
$ git rm --cached PROJECTS.md            - то же самое

$ git rm PROJECTS.md                     - удалит файл и из отслеживания и из каталога (физически)

$ git mv README.md README                - переместит или просто rename:    README.md -> README
```

<br/>
<br/>
<br/>

# FORCE PUSH

- **Стягиваем нужную ветку (напр. "master").**
- **Стягиваем эту же ветку "master" в соседнюю папку.**
- **В соседней папке переходим на ветку "develop"** .
	$  `git checkout develop`
- **Удалаяем в первой папке (ветка "master") все кроме папки ".git"**. (все локальные ветки сохранятся)
- Копируем все **(кроме папки ".git")** из соседней папки (ветка "develop") в первую (ветка "master")
- **Добавляем все "Untracked" в первой папке с помощью** 
	$ git add .              (точка  это часть команды)
- Проверяем проект что он запускается
- **Создаем коммит
	$ git commit -m "VERSION 2.18.2" 
- Пушим
	$ git push 
