#!/usr/bin/python3

import sys
import hashlib
import base64


def Base64_Encoder_for_list_of_hashed_passwords(file_path):

	try:

		with open(file_path, 'r') as file:
			passwords = file.readlines()

		Base64_Encoding_passwords = []
		for password in passwords:
			password = password.strip()
			hashed_password = hashlib.md5(password.encode()).hexdigest()
			string_to_encode = 'carlos:' + hashed_password

			base64_encoded_password = base64.b64encode(string_to_encode.encode('utf-8'))
			Base64_Encoding_passwords.append(base64_encoded_password.decode('utf-8') + '\n')

		new_file_path = 'b64encoded_' + file_path

		with open(new_file_path, 'w') as new_file:
			new_file.writelines(Base64_Encoding_passwords)

		print("Hashed passwords saved successfully in the file: " + new_file_path)


	except FileNotFoundError:
		print("File not found.")



def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        Base64_Encoder_for_list_of_hashed_passwords(file_path)
    else:
        print("Please provide the file path as an argument.")


if __name__ == "__main__":
    main()

