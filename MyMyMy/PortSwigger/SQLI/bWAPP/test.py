#!/usr/bin/python3

from urllib.parse import urlencode

def handle_url_parameters(url, params):
    # encoded_params = urlencode(params)
    full_url = f"{url}?{params}"
    # Perform further actions with the encoded URL
    print(full_url)  # Output the final encoded URL for demonstration purposes

# Example usage
url = "https://example.com/search"
params = {
    "title": "SQL Injection",
    "action": "search"
}

handle_url_parameters('http://192.168.1.9/bWAPP/sqli_4.php', params)
