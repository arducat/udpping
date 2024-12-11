use std::env;
use std::net::{UdpSocket, SocketAddr};
use std::io::{self, Write};

fn quick_mode(socket: UdpSocket, args: Vec<String>) -> Result<(), Box<dyn std::error::Error>> {
    println!("Quick UdpPing: v0.1.1");
    
    if args[2] != "-a" && args[2] != "--address" {
        println!("Вторым аргументом должен быть -a [адрес udp сервера] или --address [адрес udp сервера]!");
        return Ok(());
    }

    if args[4] != "-s" && args[4] != "--send" {
        println!("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!");
        return Ok(());
    }

    let server_addr = args[3].trim().parse::<SocketAddr>()?;
    socket.send_to(args[5].as_bytes(), server_addr)?;
    println!("Отправлено!");
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    
    let socket = UdpSocket::bind("127.0.0.1:13246")?;
    let mut server_addr: SocketAddr = "127.0.0.1:9082".parse()?;
    
    if args.len() > 1 && args[1] == "-q" {
        return quick_mode(socket, args);
    }

    println!("Консоль UdpPing: v0.1.1");
    loop {
        print!("[udpping] > ");
        io::stdout().flush().unwrap();

        let mut command = String::new();
        io::stdin().read_line(&mut command).expect("Не удалось прочитать строку");

        let split = command
            .trim()
            .split(' ')
            .filter(|v| !v.is_empty())
            .collect::<Vec<_>>();

        let (command, args) = match split.split_first() {
            Some(val) => val,
            None => {
                println!();
                continue;
            },
        };

        match command.trim() {
            "ver" => println!("Консоль UdpPing: v0.1.1"),
            "send" => {
                let mut message = String::new();
                let arg = if args.is_empty() {
                    print!("Сообщение: ");
                    io::stdout().flush().unwrap();

                    io::stdin().read_line(&mut message).expect("Не удалось прочитать строку");
                    message.trim().to_string()
                } else {
                    args.join(" ")
                };

                socket.send_to(arg.as_bytes(), server_addr)?;
                println!("Отправлено!");
            },
            "help" => {
                println!("Команды:");
                println!("  connect [адрес] - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. ИСПОЛЬЗОВАТЬ ДО \"send\"!");
                println!("  send [сообщение] - Отправляет сообщение на подключенный UDP сервер. ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!");
                println!("  ver - Выводит версию Консоли UdpPing.");
                println!("  exit - Выходит из Консоли UdpPing.");
            },
            "exit" => break,
            "connect" => {
                let mut ip = String::new();
                let arg = if args.is_empty() {
                    print!("Адрес UDP сервера: ");
                    io::stdout().flush().unwrap();

                    io::stdin().read_line(&mut ip).expect("Не удалось прочитать строку");
                    ip.trim()   
                } else {
                    args[0]
                };

                server_addr = match arg.parse() {
                    Ok(val) => val,
                    Err(_) => {
                        println!("Неверный адрес!");
                        continue;
                    },
                };
                println!("Подключено!");
            },
            command => println!("Неверная команда: \"{command}\"!"),
        }
    }
    
    Ok(())
}
