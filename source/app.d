import std.stdio;
import std.socket;
import std.algorithm;
import std.array;
import std.string;
import std.conv;

void main(string[] args) {
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

int quick(string[] args) {
	writeln("Quick UdpPing: v0.1.2-D");
	
	if (args.length < 6) {
		writeln("Недостаточно аргументов.");
		return(-1);
	}
	
	if (!(args[2] == "-a" || args[2] == "--address")) {
		writeln("Аргументы неверны");
		writeln("Вторым аргументом должен быть -a [адрес:порт] или --address [адрес:порт]!");
		return(-1);
	}
	
	if (!(args[4] == "-s" || args[4] == "--send")) {
		writeln("Аргументы неверны");
		writeln("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!");
		return(-1);
	}
	
	string[] shit = args[3].split(":");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress(std.socket.InternetAddress.parse(shit[0]), to!ushort(shit[1]));
	udps.connect(addr);
        udps.send(args[5]);
	return(0);
}

void shell() {
	writeln("Консоль UdpPing: v0.1.2-D");
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
                                	writeln("Подключено успешно!");
                                } catch (core.exception.ArrayIndexError e) {
                                	writeln("Похоже, что вы использовали эту команду неверно.");
                                	writeln("Использование: connect адрес:порт");
                                }
                                break;
                        case "send":
                                try {
                                	udps.send(w[1]);
                                	writeln("Отправлено успешно!");
                                } catch (core.exception.ArrayIndexError e) {
                                	writeln("Похоже, что вы использовали эту команду неверно.");
                                	writeln("Использование: send сообщение");
                                }
                                break;
                        case "help":
                                writeln("Команды:\nconnect [адрес:порт] - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. ИСПОЛЬЗОВАТЬ ДО \"send\"!\nsend [сообщение] - Отправляет сообщение на подключенный UDP сервер. ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!\nver - Выводит версию Консоли UdpPing.\nexit - Выходит из Консоли UdpPing.");
                                break;
                        case "ver":
                                writeln("Консоль UdpPing: v0.1.2-D");
                                break;
                        
                        default:
                                writeln("Команда ", w[0], " не найдена.");
                }
        }
}
