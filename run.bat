D:\\software\\NASM\\nasm.exe bootsect.asm -o bootsect.bin -l bootsect.lst
D:\\software\\NASM\\nasm.exe setup.asm -o setup.bin  -l setup.lst

gcc -m32 -fno-asynchronous-unwind-tables -s -O2 -c -o .\\c\\start.o .\\c\\start.c
D:\\software\\objconv\\objconv.exe -fnasm .\\c\\start.o .\\c\\nasm\\start.asm
D:\\software\\python3\\python.exe E:\\code\\python\\self\\tools\\tools\\objconv2nasm_clearn.py
copy /B head.asm+.\\c\\clean\\start.asm+func.asm  kernel.asm
D:\\software\\NASM\\nasm.exe kernel.asm -o kernel.bin -l kernel.lst
copy /B bootsect.bin+setup.bin+kernel.bin  os.iso
D:\\software\\Bochs-2.7\\bochs -q -f D:\\software\\Bochs-2.7\\dlxlinux\\bochsrc_m.bxrc