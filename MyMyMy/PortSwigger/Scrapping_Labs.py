#!/usr/bin/python3
import requests
from bs4 import BeautifulSoup


# Function to display colored level on the screen
def colored_text(text, color):
    color_code = {
        'red': '\033[91m',
        'green': '\033[92m',
        'blue': '\033[94m',
        'yellow': '\033[93m',
        'cyan': '\033[96m',
        'magenta': '\033[95m',
    }
    end_code = '\033[0m'
    
    text = f"{color_code[color]}{text}{end_code}"
    return text


# Function to parse HTML content
def parse_html_content(html_content):
    Number_Of_Total_Labs = 0
    Number_Of_Labs_for_each_Vulnerability_list_Saver = []
    # Create BeautifulSoup object
    soup = BeautifulSoup(html_content, 'html.parser')

    # Perform actions on the parsed content
    div_id = 'all-labs'
    div_container = soup.find('div', attrs={'id': div_id})
    Vulnerabilities = div_container.find_all('h2')


    for i in range(len(Vulnerabilities)):
        Number_of_apprentice = Number_of_practitioner = Number_of_expert = 0
        Vulnerability = Vulnerabilities[i]
        print(Vulnerability.text)
        print('-' * len(Vulnerability.text))

        # Find the corresponding div containers
        next_sibling = Vulnerability.next_sibling
        while next_sibling and next_sibling.name != 'h2':

            if next_sibling.name == 'div':
                # here we are doing stuff on each lab inside the Vulnerability!

                div_container = next_sibling.find('div', attrs={'class': "flex-columns"})
                solving_status_container = next_sibling.find('span', attrs={'class': "lab-status-icon"})

                if div_container.find('span', attrs={'class': "lab-level-display__apprentice"}):
                    level_span_container = div_container.find('span', attrs={'class': "lab-level-display__apprentice"})
                    Number_of_apprentice += 1
                    Number_Of_Total_Labs += 1
                    Color = 'green'

                elif div_container.find('span', attrs={'class': "lab-level-display__practitioner"}):
                    level_span_container = div_container.find('span', attrs={'class': "lab-level-display__practitioner"})
                    Number_of_practitioner += 1
                    Number_Of_Total_Labs += 1
                    Color = 'yellow'

                elif div_container.find('span', attrs={'class': "lab-level-display__expert"}):
                    level_span_container = div_container.find('span', attrs={'class': "lab-level-display__expert"})
                    Number_of_expert += 1
                    Number_Of_Total_Labs += 1
                    Color = 'red'


                LabName = div_container.find('a').get_text()
                level_name = level_span_container.get_text()
                level_name_colored = colored_text(level_name, Color)

                print(LabName + "\t\t" + level_name_colored)

            Number_Of_Labs_Per_Vulnerability = Number_of_apprentice + Number_of_practitioner + Number_of_expert
            next_sibling = next_sibling.next_sibling


        print("\n****************************************************")
        print(str(Number_of_apprentice) + " " + colored_text("Apprentice", 'green') + " Lab, " + str(Number_of_practitioner) + " " + colored_text("Practitioner", 'yellow') + " Lab, " + str(Number_of_expert) + " " + colored_text("Expert", 'red') + " Lab")
        Number_Of_Labs_for_each_Vulnerability_list_Saver.append(Number_Of_Labs_Per_Vulnerability)
        print("Number of labs: " + str(Number_Of_Labs_Per_Vulnerability))
        print("****************************************************")
        print("\n\n")


    print("Summary: " + '\n' + '-' * 10 + '\n\n')
    for i in range(len(Number_Of_Labs_for_each_Vulnerability_list_Saver)):
        Vulnerability = Vulnerabilities[i]
        print(Vulnerability.text + ': ' + str(Number_Of_Labs_for_each_Vulnerability_list_Saver[i]))
        print('-' * len(Vulnerability.text) + '-' * 6)

    print("\nNumber Of Total Labs: " + str(Number_Of_Total_Labs))



# Make a request to a website and get the HTML content
url = 'https://portswigger.net/web-security/all-labs'
response = requests.get(url)
html_content = response.text

# Parse the HTML content
parse_html_content(html_content)
