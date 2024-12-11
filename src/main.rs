use std::env;
use std::net::{UdpSocket, SocketAddr};
use std::io::{self, Write};
use colored::Colorize;

fn print_error(error: &str, type_e: &str) {
    match type_e {
        "err" => {
            println!("udpping: {}: {}", "Ошибка".bright_red().bold(), error.bold());
        }
        "hlp" => {
            println!("udpping: {}: {}", "Подсказка".blue().bold(), error.bold());
        }
        "suc" => {
            println!("udpping: {}", "Успешно!".green().bold());
        }
        _ => {}
    }
}

fn quick_mode(socket: UdpSocket, args: Vec<String>) -> Result<(), Box<dyn std::error::Error>> {
    println!("{}: {}", "Quick UdpPing".bold(), "v0.1.2".bright_black().bold());
    
    if args[2] != "-a" && args[2] != "--address" {
        print_error("Неверные аргументы", "err");
        print_error("Вторым аргументом должен быть -a [адрес udp сервера] или --address [адрес udp сервера]!", "hlp");
        return Ok(());
    }

    if args[4] != "-s" && args[4] != "--send" {
        print_error("Неверные аргументы", "err");
        print_error("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!", "hlp");
        return Ok(());
    }
    
    let server_addr: SocketAddr = match args[3].trim().parse() {
                    Ok(val) => val,
                    Err(_) => {
                        print_error("Неверный адрес!", "err");
                        return Ok(());
                    },
                };
    socket.send_to(args[5].as_bytes(), server_addr)?;
    print_error(" ", "suc");
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    
    let socket = UdpSocket::bind("127.0.0.1:13246")?;
    let mut server_addr: SocketAddr = "127.0.0.1:9082".parse()?;
    
    if args.len() > 1 && args[1] == "-q" {
        return quick_mode(socket, args);
    }

    println!("{}: {}", "Консоль UdpPing".bold(), "v0.1.2".bright_black().bold());
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
            "ver" => println!("{}: {}", "Консоль UdpPing".bold(), "v0.1.2".bright_black().bold()),
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
                print_error(" ", "suc");
            },
            "help" => {
                println!("{}", "Команды:". bold());
                println!("  {} - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. {}", "connect [адрес]".bold(), "ИСПОЛЬЗОВАТЬ ДО \"send\"!".bright_red().bold());
                println!("  {} - Отправляет сообщение на подключенный UDP сервер. {}", "send [сообщение]".bold(), "ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!".bright_red().bold());
                println!("  {} - Выводит версию Консоли UdpPing.", "ver".bold());
                println!("  {} - Выходит из Консоли UdpPing.", "exit".bold());
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
                        print_error("Неверный адрес!", "err");
                        continue;
                    },
                };
                print_error(" ", "suc");
            },
            command => print_error("Неверная команда: \"{command}\"!", "err"),
        }
    }
    
    Ok(())
}
