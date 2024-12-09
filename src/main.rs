use std::net::{UdpSocket, SocketAddr};
use std::io::{self, Write};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("UdpPing Console: v0.1.0");
    
    let socket = UdpSocket::bind("127.0.0.1:13246")?;
    
    let mut server_addr: SocketAddr = "127.0.0.1:9082".parse()?;
    
    let mut start = true; 

    while start {
        print!("[udpping] > ");
        io::stdout().flush().unwrap();

        let mut command = String::new();
        io::stdin().read_line(&mut command).expect("Failed to read line");
        let command = command.trim();

        match command {
            "help" => {
                println!("Commands:");
                println!("  connect - Connect to a UDP server. You will be asked for an IP address. USE THIS COMMAND BEFORE \"SEND\"!");
                println!("  send - Send a message to the connected UDP server. Make sure to \"connect\" first!");
                println!("  ver - Outputs the version of the UdpPing console.");
                println!("  exit - Exit from the UdpPing console.");
            }
            "ver" => {
                println!("UdpPing Console: v0.1.0");
            }
            "exit" => {
                start = false;
            }
            "connect" => {
                print!("Server address: ");
                io::stdout().flush().unwrap();
                
                let mut ip = String::new();
                io::stdin().read_line(&mut ip).expect("Failed to read line");
                server_addr = ip.trim().parse()?;
            }
            "send" => {
                print!("Message: ");
                io::stdout().flush().unwrap();
                
                let mut message = String::new();
                io::stdin().read_line(&mut message).expect("Failed to read line");
                let message = message.trim();
                socket.send_to(message.as_bytes(), server_addr)?;
                println!("Sent!");
            }
            _ => {
                println!("Command not found.");
            }
        }
    }
    
    Ok(())
}