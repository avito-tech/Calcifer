# Lint

* [CI linting](#ci_linting)
* [Xcode prebuild linting](#xcode_prebuild_linting)
* [Xcode full linting](#xcode_full_linting)
* [Autocorrection](#autocorrection)
* [Troubleshooting](#troubleshooting)
* [Enabled rule descriptions](docs/enabled-rule-descriptions.md)
* [All rule descriptions](docs/all-rule-descriptions.md)

В папке рядом с текущим `README` содержатся скрипты для линтования и автокоррекции `swift`'ового кода основного репозитория, файлы настройки этих скриптов и прочие нужные для линтера вещи.

На данный момент линтуются все локальные поды и основной проект `Avito.xcworkspace`. Демо проекты локальных подов не линтуются. Тесты тоже не линтуются.

Бинарники `swiftlint`'а лежат `./swiftlint` относительно текущего `README` и трекаются `git`'ом. Таким образом достигаются следующие требования:
1. Удобство распространения актуальной версии `swiftlint`'a на машины разработчиков и сборщиков
2. Возможность использования старой версии `swiftlint`'a при переходе на прошлую ревизию

## <a name="ci_linting"/> CI linting
Для удобства линтовая проекта билд машинами заведен скрипт `ci-lint`.

По результатам его работы создаются файлы:
* отчет линтовщика в виде html файла. Скрипт напишет в консоль что-то вроде `Linter reports are available at /path/to/reports.html`
* бенчмарк линтовщика по файлам. Файлик будет называться `benchmark_files_*.txt`
* бенчмарк линтовщика по правилам. Файлик будет называться `benchmark_rules_*.txt`

В `TeamCity` эти файлы отчетов будут прикрепляться к билду через артифакты.

## <a name="xcode_prebuild_linting"/> Xcode prebuild linting
Для удобства пресечения ошибок линтовщика во время написания нового кода заведен скрипт `xcode-prebuild-lint`, выполняющий линтование только измененных файлов. Правила линтования и проверяемые файлы совпадают с таковыми при [CI linting](#ci_linting).

Скрипт запускается через `Run script phase`, добавленный к таргету `Avito`. Скрипт выполняется до компиляции файлов таргета. Ошибки и варнинги будут подсвечены внутри `Xcode`, поэтому исправлять их удобно. 

## <a name="xcode_full_linting"/> Xcode full linting
Для удобства исправления ошибок линтовщика заведен скрипт `xcode-lint`. Правила линтования и проверяемые файлы совпадают с таковыми при [CI linting](#ci_linting).

Скрипт запускается через `Run script phase`, добавленный к таргету `Lint`. Ошибки и варнинги будут подсвечены внутри `Xcode` как и при [Xcode prebuild linting](#xcode_prebuild_linting).
Некоторые ошибки могут быть исправлены [автокорректором](#autocorrection). 
Советуется пробовать автокоррекцию прежде ручных правок ошибок при [Xcode full linting](#xcode_full_linting).

## <a name="autocorrection"/> Autocorrection
Некоторые правила поддерживают автокоррекцию. Автокоррекция позволяет ускорить процесс правки ошибок линтовщика. 

Для запуска актокоррекции есть скрипт `autocorrect`. После его работы нужно визуально проверить правильность правок и запустить [Xcode full linting](#xcode_full_linting).

Скрипт автокоррекции вырезает некоторые правила, участвующие в линтовке, потому что они дают много ложнопозитивных результатов, а именно: `colon`. В будущем это правила будут отключено или модифицировано.

Ранее было еще одно вырезаемое правило: `opening_brace`. Оно уже отключено.


## <a name="troubleshooting"/> Troubleshooting
Если скрипт ругается, что на компьютер не установлен `swiftlint`, то его можно установить через скрипт `install-swiftlint` [тут](http://stash.msk.avito.ru/projects/MA/repos/avito-ios-lint/browse/Avito).