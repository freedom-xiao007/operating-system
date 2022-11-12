# !bash
D:\\software\\NASM\\nasm.exe .\\myOS.asm -o .\\os.bin
D:\\software\\NASM\\nasm.exe .\\loader.asm -o .\\loader.bin

./edimg.exe imgin:./fdimg0at.tek wbinimg src:os.bin len:512 from:0 to:0 copy from:./loader.bin to:@: imgout:boot.iso

D:\\software\\qemu\\qemu-system-x86_64.exe -L . -m 64 -fda .\\boot.iso