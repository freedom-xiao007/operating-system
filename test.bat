D:\\software\\NASM\\nasm.exe bootsect.asm -o bootsect.bin -l bootsect.lst
D:\\software\\NASM\\nasm.exe setup.asm -o setup.bin  -l setup.lst

@REM 主函数编译
gcc -m32 -fno-asynchronous-unwind-tables -s -O2 -c -o .\\c\\test.o .\\c\\test.c
D:\\software\\objconv\\objconv.exe -fnasm .\\c\\test.o .\\c\\nasm\\test.asm

@REM 字体文件编译
.\makefont.exe .\hankaku.txt .\hankaku.bin
.\bin2obj.exe .\hankaku.bin .\hankaku.obj _hankaku
D:\\software\\objconv\\objconv.exe -fnasm .\hankaku.obj .\\c\\nasm\\hankaku.asm

@REM 处理生成的nasm不合理的的地方
D:\\software\\python3\\python.exe E:\\code\\python\\self\\tools\\tools\\objconv2nasm_clearn.py

@REM 合并文件，编译运行
copy /B head.asm+.\\c\\clean\\test.asm+func.asm+.\\c\\clean\\hankaku.asm kernel.asm
D:\\software\\NASM\\nasm.exe kernel.asm -o kernel.bin -l kernel.lst
copy /B bootsect.bin+setup.bin+kernel.bin  os.iso
D:\\software\\Bochs-2.7\\bochs -q -f D:\\software\\Bochs-2.7\\dlxlinux\\bochsrc_m.bxrc