#!/usr/bin/python3

import sys
import threading
import subprocess


threads = []


def fuzzing_with_ffuf(url):
    command = f"ffuf -u https://{url}/FUZZ -w Your_Wordlist.txt -t 200 | tee -a /home/yousseff/Desktop/Bug_Hunting/Targets/test/{url}.txt"
    subprocess.run(command, shell=True)


def main():

    if len(sys.argv) != 2:
        print("(+) Usage: %s <urls_to_fuzz.txt>" % sys.argv[0])
        print("(+) Example: %s urls.txt" % sys.argv[0])
        return

    urls_file = sys.argv[1]

    try:

        with open(urls_file, 'r') as file:
            urls = file.readlines()

            for url in urls:

                url = url.strip()
                t = threading.Thread(target=fuzzing_with_ffuf, args=(url,))
                t.start()
                threads.append(t)

            for thread in threads:
                thread.join()


    except FileNotFoundError:
        print(f"Error: File '{urls_file}' not found.")

    except Exception as e:
        print(f"An error occurred: {e}")


    print("[+] Fuzzing All URLs Done!")


if __name__ == "__main__":
    main()
  

