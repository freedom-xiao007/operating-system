import os


def clean_nasm_file(file_name, nasm_path, clean_path):
    nasm_file = nasm_path + "\\" + file_name
    clean_file = clean_path + "\\" + file_name
    with open(clean_file, "w") as fw:
        with open(nasm_file, "r") as fr:
            content = fr.readline()
            while content:
                if content.startswith("global") or content.startswith("extern"):
                    content = fr.readline()
                    continue
                content = content.replace("noexecute", "")
                content = content.replace("execute", "")
                fw.write(content)
                content = fr.readline()


if __name__ == "__main__":
    nasm_path = "E:\\code\\other\\self\\operating-system\\c\\nasm"
    clean_path = "E:\\code\\other\\self\\operating-system\\c\\clean"
    files = os.listdir(nasm_path)
    for file in files:
        if not os.path.isdir(file):
            clean_nasm_file(file, nasm_path, clean_path)

