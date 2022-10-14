# !bash
D:\\software\\NASM\\nasm.exe .\\myOS.asm -o .\\myOS.img
D:\\software\\NASM\\nasm.exe .\\loader.asm -o .\\loader.bin
cp myOS.img os.img
dd if=./loader.bin of=./os.img oflag=append conv=notrunc
D:\\software\\qemu\\qemu-system-x86_64.exe -L . -m 64 -fda .\\os.img