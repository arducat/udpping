import std.stdio;
import std.socket;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import consolecolors;

void main(string[] args) {
	enableConsoleUTF8(); /* Нужно для корректной работы на Windows */
	if (args.length <= 1) {
		shell();
	} else {
		if (args[1] == "-q") {
        		quick(args);
        	} else {
        		writeln("Аргументы не распознаны.");
        	}
        }
}

void uerr(string error, char type) {
	switch (type) {
		case 'e':
			cwritefln("udpping: <b><red>Ошибка:</red> %s</b>", error);
			break;
		case 'i':
			cwritefln("udpping: <b><cyan>Подсказка:</cyan> %s</b>", error);
			break;
		case 's':
			cwritefln("udpping: <b><lgreen>Успешно!</lgreen></b>");
			break;
		default:
			return;
	}
}

int quick(string[] args) {
	cwritefln("<b>Quick UdpPing</b>:<b><grey> v0.1.3</grey></b>");
	
	if (args.length < 6) {
		uerr("Недостаточно аргументов.", 'e');
		return(-1);
	}
	
	if (!(args[2] == "-a" || args[2] == "--address")) {
		uerr("Неверное использование.", 'e');
		uerr("Вторым аргументом должен быть -a [адрес:порт] или --address [адрес:порт]!", 'i');
		return(-1);
	}
	
	if (!(args[4] == "-s" || args[4] == "--send")) {
		uerr("Неверное использование.", 'e');
		uerr("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!", 'i');
		return(-1);
	}
	
	string[] tmp = args[3].split(":");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0]), to!ushort(tmp[1]));
	udps.connect(addr);
        udps.send(args[5]);
        uerr("", 's');
	return(0);
}

void shell() {
	cwritefln("<b>Консоль UdpPing</b>:<b><grey> v0.1.3</grey></b>");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress("localhost", 25565);
        udps.connect(addr);
        bool gogo = true;

        while (gogo) {
        	write("[udpping] > ");
		stdout.flush();
                string[] input = (stdin.readln().strip()).split();
                switch (input[0]) {
                        case "exit":
                                gogo = false;
                                break;
                        case "connect":
                                if (input.length == 2) {
                                	auto tmp = input[1].findSplit(":");
                                	if (tmp[2] != "") {
                                		addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0].strip()), to!ushort(tmp[2].strip()));
                                		udps.connect(addr);
                                		uerr("", 's');
					} else {
						uerr("Неверное использование.", 'e');
						uerr("Адрес должен быть в формате айпи:порт!", 'i');
					}
                                } else {
                                	write("Адрес UDP сервера: ");
					stdout.flush();
                                	auto tmp = (stdin.readln().strip()).findSplit(":");
                                	if (tmp[2] != "") {
                                		addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0].strip()), to!ushort(tmp[2].strip()));
                                		udps.connect(addr);
                                		uerr("", 's');
                                	} else {
                                		uerr("Неверное использование.", 'e');
						uerr("Адрес должен быть в формате айпи:порт!", 'i');
                                	}
                                }
                                break;
                        case "send":
                                if (input.length == 2) {
                                	udps.send(input[1]);
                                	uerr("", 's');
                                } else {
                                	write("Сообщение: ");
					stdout.flush();
                                	string tmp = stdin.readln().strip();
                                	udps.send(tmp);
                                	uerr("", 's');
                                }
                                break;
                        case "help":
                                cwritefln("<b>Команды:\n  connect [адрес:порт]</b> - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. <b><red>ИСПОЛЬЗОВАТЬ ДО \"send\"!</red>\n  send [сообщение]</b> - Отправляет сообщение на подключенный UDP сервер. <b><red>ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!</red>\n  ver</b> - Выводит версию Консоли UdpPing.\n  <b>exit</b> - Выходит из Консоли UdpPing.");
                                break;
                        case "ver":
                                cwritefln("<b>Консоль UdpPing</b>:<b><grey> v0.1.3</grey></b>");
                                break;
                        
                        default:
                                uerr("Неизвестная команда: \"" ~ input[0] ~ "\"", 'e');
                }
        }
}
