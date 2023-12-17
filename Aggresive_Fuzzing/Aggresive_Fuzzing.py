#!/usr/bin/python3

import sys
import threading
import subprocess


threads = []


def fuzzing_with_ffuf(url_or_domain, wordlist):
    command = f"ffuf -u https://{url_or_domain}/FUZZ -w {wordlist} -t 200 | tee -a /home/yousseff/Desktop/Bug_Hunting/Targets/test/{url_or_domain}.txt"
    subprocess.run(command, shell=True)


def main():

    if len(sys.argv) != 3:
        print("(+) Usage: %s <urls_or_domains_to_fuzz.txt> <wordlist.txt>" % sys.argv[0])
        print("(+) Example: %s urls_or_domains.txt wordlist.txt" % sys.argv[0])
        return

    urls_or_domains_file = sys.argv[1]
    wordlist = sys.argv[2]


    try:

        with open(urls_or_domains_file, 'r') as file:
            urls_or_domains = file.readlines()

            for url_or_domain in urls_or_domains:

                url_or_domain = url_or_domain.strip()
                t = threading.Thread(target=fuzzing_with_ffuf, args=(url_or_domain,wordlist))
                t.start()
                threads.append(t)

            for thread in threads:
                thread.join()


    except FileNotFoundError:
        print(f"Error: File '{urls_or_domains_file}' not found.")

    except Exception as e:
        print(f"An error occurred: {e}")


    print("[+] Fuzzing All URLs Done!")


if __name__ == "__main__":
    main()
  

