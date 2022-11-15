_put_str:
	mov  esi, esp ;保护模式DS=0,数据用绝对地址访问
	mov  cl, 0x09                   ;蓝色
	mov  edi, 0xb8000+22*160        ;指定显示在某行,显卡内存地址需用绝对地址
	call printnew                   ;0xb8000为字符模式下显卡映射到的内存地址 
	ret  

_write_mem8:     ; void write_mem8(int addr, int data);
        MOV      ECX, [ESP+4]      ; [ESP + 4]中存放的是地址，将其读入ECX
        MOV      AL, [ESP+8]       ; [ESP + 8]中存放的是数据，将其读入AL
        MOV      [ECX], AL
        RET
