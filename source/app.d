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
        	quick();
        }
}

void quick() {
	writeln("Quick UdpPing: v0.1.2-D");
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
