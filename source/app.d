import std.stdio;
import std.socket;
import std.algorithm;
import std.array;
import std.string;
import std.conv;

void main() {
        auto udps = new UdpSocket();
        auto addr = new InternetAddress("localhost", 25565);
        udps.connect(addr);
        bool gogo = true;

        while (gogo) {
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
                                } finally {
                                	
                                }
                                break;
                        case "send":
                                try {
                                	udps.send(w[1]);
                                	writeln("Отправлено успешно!");
                                } finally {
                                	
                                }
                                break;
                        
                        default:
                                writeln("Команда ", w[0], " не найдена.");
                }
        }

}
