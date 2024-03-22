import socket
import struct
import random

def generate_random_ip():
    return socket.inet_ntoa(struct.pack('>I', random.randint(1, 0xffffffff)))

def main():
    for _ in range(300):
        random_ip = generate_random_ip()
        print(random_ip)

if __name__ == "__main__":
    main()
