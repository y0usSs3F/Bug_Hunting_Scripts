#!/usr/bin/python3

import sys

def insert_peter(file_path):
    try:
        with open(file_path, 'r+') as file:
            lines = file.readlines()
            file.seek(0)  # Move the file cursor to the beginning

            for line in lines:
                file.write("peter\n")
                file.write(line)

        print("Lines modified successfully in the file: " + file_path)
    except FileNotFoundError:
        print("File not found.")

def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        insert_peter(file_path)
    else:
        print("Please provide the file path as an argument.")


if __name__ == "__main__":
    main()



