use std::env;
use std::net::{UdpSocket, SocketAddr};
use std::io::{self, Write};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    
    let socket = UdpSocket::bind("127.0.0.1:13246")?;
    
    let mut server_addr: SocketAddr = "127.0.0.1:9082".parse()?;
    
    let mut start = true; 
    
    if (args.len() > 1) {
        if (args[1] == "-q") {
            println!("Quick UdpPing: v0.1.1 beta");
            start = false; 
            
            if (args[2] == "-a" || args[2] == "--address") {
                server_addr = args[3].trim().parse()?;
            } else {
                println!("Вторым аргументом должен быть -a [адрес udp сервера] или --address [адрес udp сервера]!");
                return Ok(());
            }
            
            if (args[4] == "-s" || args[4] == "--send") {
                socket.send_to(args[5].as_bytes(), server_addr)?;
            } else {
                println!("Третьим аргументом должен быть -s [сообщение] или --send [сообщение]!");
                return Ok(());
            }
            
            println!("Отправлено!");
        }
    } else {
        println!("Консоль UdpPing: v0.1.1 beta");
    }

    while start {
        print!("[udpping] > ");
        io::stdout().flush().unwrap();

        let mut command = String::new();
        io::stdin().read_line(&mut command).expect("Не удалось прочитать строку");
        let command = command.trim();
        
        let command: Vec<char> = command.chars().collect();
        
        /* Узрите говно-код от SvZ_FTeam! */
        
        if (command[0] == 'v' && command[1] == 'e' && command[2] == 'r') {
            println!("Консоль UdpPing: v0.1.1 beta");
        } else if (command[0] == 's' && command[1] == 'e' && command[2] == 'n' && command[3] == 'd' && command.len() == 4) {
            print!("Сообщение: ");
            io::stdout().flush().unwrap();
                
            let mut message = String::new();
            io::stdin().read_line(&mut message).expect("Не удалось прочитать строку");
            let message = message.trim();
            socket.send_to(message.as_bytes(), server_addr)?;
            println!("Отправлено!");
        } else if (command[0] == 'h' && command[1] == 'e' && command[2] == 'l' && command[3] == 'p') {
            println!("Команды:");
            println!("  connect [адрес] - Подключает к UDP серверу. Если адрес сервера не указан, Вас его спросят. ИСПОЛЬЗОВАТЬ ДО \"send\"!");
            println!("  send [сообщение] - Отправляет сообщение на подключенный UDP сервер. ИСПОЛЬЗОВАТЬ ПОСЛЕ \"connect\"!");
            println!("  ver - Выводит версию Консоли UdpPing.");
            println!("  exit - Выходит из Консоли UdpPing.");
        } else if (command[0] == 'e' && command[1] == 'x' && command[2] == 'i' && command[3] == 't') {
            start = false;
        } else if (command[0] == 'c' && command[1] == 'o' && command[2] == 'n' && command[3] == 'n' && command[4] == 'e' && command[5] == 'c' && command[6] == 't' && command.len() == 7) {
            print!("Адрес UDP сервера: ");
            io::stdout().flush().unwrap();
                
            let mut ip = String::new();
            io::stdin().read_line(&mut ip).expect("Не удалось прочитать строку");
            server_addr = ip.trim().parse()?;
            println!("Подключено!");
        } else if (command[0] == 's' && command[1] == 'e' && command[2] == 'n' && command[3] == 'd' && command.len() > 4) {
            let message: Vec<char> = command[5..].to_vec();
            let message: String = message.iter().collect();
            socket.send_to(message.as_bytes(), server_addr)?;
            println!("Отправлено!");
        } else if (command[0] == 'c' && command[1] == 'o' && command[2] == 'n' && command[3] == 'n' && command[4] == 'e' && command[5] == 'c' && command[6] == 't' && command.len() > 7) {
            let ip: Vec<char> = command[8..].to_vec();
            let ip: String = ip.iter().collect();
            server_addr = ip.trim().parse()?;
            println!("Подключено!");
        }
    }
    
    Ok(())
}
