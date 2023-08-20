#!/usr/bin/python3

import sys
import hashlib

def hash_passwords(file_path):

	try:

		with open(file_path, 'r') as file:
			passwords = file.readlines()

		hashed_passwords = []
		for password in passwords:
			password = password.strip()
			hashed_password = hashlib.md5(password.encode()).hexdigest()
			hashed_passwords.append('carlos:' + hashed_password + '\n')

		new_file_path = 'hashed_' + file_path

		with open(new_file_path, 'w') as new_file:
			new_file.writelines(hashed_passwords)

		print("Hashed passwords saved successfully in the file: " + new_file_path)


	except FileNotFoundError:
		print("File not found.")



def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        hash_passwords(file_path)
    else:
        print("Please provide the file path as an argument.")


if __name__ == "__main__":
    main()

