# UdpPing v0.1.2

Простая утилита для отправления запросов на UDP сервер.

## Компилирование и запуск приложения


Сначала клонируем репозиторий:
`git clone https://gitverse.ru/fteam/udpping.git`


Если вы хотите скомпилировать и сразу запустить:
`cargo run --release --bin udpping`


Если вы хотите просто скомпилировать:
`cargo build --release --bin udpping`

Скомпилированная версия соберется в udpping/target/release.

Так же готовый бинарный файл и скрипт-установщик можно найти в релизах.

## Использование приложения

В UdpPing есть два типа использования:
1. "Быстрый" режим (появился в v0.1.1)
2. Консоль UdpPing (появился в v0.1.0, был дополнен в v0.1.1)

### Использование "быстрого" режима

За "быстрый" режим отвечает флаг `-q`.  
Сразу после него должен быть либо `-a [адрес udp сервера]`, либо `--address [адрес udp сервера]`.  
После адреса должен быть либо `-s [сообщение]`, либо `--send [сообщение]`.  

Это должно отправить на указаный UDP сервер Ваше сообщение.  
Пример:  
`udpping -q -a 127.0.0.1:1234 -s Привет`  

### Использование Консоли UdpPing

Чтобы войти в Консоль UdpPing, достаточно не указывать аргументы.  

Внутри консоли есть следующие команды:  
 -  help - показывает справку  
 -  ver - показывает версию  
 -  connect \[адрес] - подключает к UDP серверу. Если Вы не указали адрес, то программа у Вас его спросит.  
 -  send \[сообщение] - отправляет на UDP сервер сообщение. Если Вы не указали сообщение, то программа у Вас его спросит.  

Внимание: используйте send до connect. Иначе сообщение не будет отправлено.

## Благодарность Grisshink за замену говнокода на нормальный код!
