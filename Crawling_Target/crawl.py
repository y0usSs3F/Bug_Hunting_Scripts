#!/usr/bin/python3


# The Script is Basically taking from y0u Target URL with -u option then Crawling this Target and Extracting all the URLs on it including css files, js files, different endpoints with different functionalities, every URL within the Target Would be extracted!



import requests
import re
import urllib.parse
import argparse


def get_arguments():
    parser = argparse.ArgumentParser(description="Process The Inputs")
    parser.add_argument("-u", "--url", dest="URL", help="URL To Spider")
    options = parser.parse_args()
    if not options.URL:
        parser.error("[-] Please specify URL Link")

    return options


# def request(url):
#     try:
#         return requests.get("http://" + url)
#     except requests.exceptions.ConnectionError:
#         pass


target_url = get_arguments().URL
target_links = []


def extract_links_from(url):
    response = requests.get(url)
    return re.findall('(?:href=")(.*?)"', str(response.content))    # list contains all link in the website


def crawl(url):
    href_links = extract_links_from(url)
    for link in href_links:
        link = urllib.parse.urljoin(url, link)      # join the links to ensure that it being full url

        if "#" in link:                # not interested in after the hash sign cuz it's already not valid link for me
            link = link.split("#")[0]

        if target_url in link and link not in target_links:     # check to not printing the external urls
            target_links.append(link)
            print(link)
            crawl(link)


crawl(target_url)
