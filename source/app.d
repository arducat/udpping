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
			int a = 23434234;
	}
}

int quick(string[] args) {
	cwritefln("<b>Quick UdpPing</b>:<b><grey> v0.1.2-D</grey></b>");
	
	if (args.length < 6) {
		uerr("Недостаточно аргументов.", 'e');
		return(-1);
	}
	
	if (!(args[2] == "-a" || args[2] == "--address")) {
		uerr("Аргументы неверны.", 'e');
		uerr("Вторым аргументом должен быть -a [адрес:порт] или --address [адрес:порт]!", 'i');
		return(-1);
	}
	
	if (!(args[4] == "-s" || args[4] == "--send")) {
		uerr("Аргументы неверны.", 'e');
		uerr("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!", 'i');
		return(-1);
	}
	
	string[] shit = args[3].split(":");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress(std.socket.InternetAddress.parse(shit[0]), to!ushort(shit[1]));
	udps.connect(addr);
        udps.send(args[5]);
        uerr("", 's');
	return(0);
}

void shell() {
	cwritefln("<b>Консоль UdpPing</b>:<b><grey> v0.1.2-D</grey></b>");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress("localhost", 25565);
        udps.connect(addr);
        bool gogo = true;

        while (gogo) {
        	write("[udpping] > ");
                string input = stdin.readln().strip();
                string[] w = input.split();
                switch (w[0]) {
                        case "exit":
                                gogo = false;
                                break;
                        case "connect":
                                try {
                                	string[] shit = w[1].split(":");
                                	addr = new InternetAddress(std.socket.InternetAddress.parse(shit[0]), to!ushort(shit[1]));
                                	udps.connect(addr);
                                	uerr("", 's');
                                } catch (core.exception.ArrayIndexError e) {
                                	write("Адрес UDP сервера: ");
                                	string kakpravilno = stdin.readln().strip();
                                	string[] shit = kakpravilno.split(":");
                                	addr = new InternetAddress(std.socket.InternetAddress.parse(shit[0]), to!ushort(shit[1]));
                                	udps.connect(addr);
                                	uerr("", 's');
                                }
                                break;
                        case "send":
                                try {
                                	udps.send(w[1]);
                                	uerr("", 's');
                                } catch (core.exception.ArrayIndexError e) {
                                	write("Сообщение: ");
                                	string kakpravilno = stdin.readln().strip();
                                	udps.send(kakpravilno);
                                	uerr("", 's');
                                }
                                break;
                        case "help":
                                cwritefln("<b>Команды:\n  connect [адрес:порт]</b> - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. <b><red>ИСПОЛЬЗОВАТЬ ДО \"send\"!</red>\n  send [сообщение]</b> - Отправляет сообщение на подключенный UDP сервер. <b><red>ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!</red>\n  ver</b> - Выводит версию Консоли UdpPing.\n  <b>exit</b> - Выходит из Консоли UdpPing.");
                                break;
                        case "ver":
                                cwritefln("<b>Консоль UdpPing</b>:<b><grey> v0.1.2-D</grey></b>");
                                break;
                        
                        default:
                                uerr("Неизвестная команда: \"" ~ w[0] ~ "\"", 'e');
                }
        }
}
