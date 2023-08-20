import sys

def insert_peter(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()

        new_lines = []
        for line in lines:
            new_lines.append("peter\n")
            new_lines.append(line)

        new_file_path = 'peter_' + file_path

        with open(new_file_path, 'w') as new_file:
            new_file.writelines(new_lines)

        print("New file created successfully: " + new_file_path)
    except FileNotFoundError:
        print("File not found.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        insert_peter(file_path)
    else:
        print("Please provide the file path as an argument.")
