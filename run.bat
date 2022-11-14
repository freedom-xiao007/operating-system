D:\\software\\NASM\\nasm.exe bootsect.asm -o bootsect.bin -l bootsect.lst
D:\\software\\NASM\\nasm.exe setup.asm -o setup.bin  -l setup.lst
D:\\software\\NASM\\nasm.exe head.asm -o head.bin -l head.lst
copy /B bootsect.bin+setup.bin+head.bin  os.iso
@REM copy os.iso D:\\software\\Bochs-2.7\\dlxlinux\\os.iso
D:\\software\\Bochs-2.7\\bochs -q -f D:\\software\\Bochs-2.7\\dlxlinux\\bochsrc_m.bxrc