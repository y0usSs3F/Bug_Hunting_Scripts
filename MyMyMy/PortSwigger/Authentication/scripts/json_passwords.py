#!/usr/bin/python3

import sys


def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]

        new_lines = []
        with open(file_path, 'r+') as file:
        	lines = file.readlines()
        	for line in lines:
        		json_line = f'"{line.strip()}",'
        		new_lines.append(json_line)

        	for line in new_lines:
        		print(line)

    else:
        print("Please provide the file path as an argument.")


if __name__ == "__main__":
    main()
