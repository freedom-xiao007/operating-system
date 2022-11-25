[BITS 32]                          ; 制作32位模式用的机器语言
        GLOBAL  _io_hlt, _io_cli, _io_sti, io_stihlt
        GLOBAL  _io_in8,  _io_in16,  _io_in32
        GLOBAL  _io_out8, _io_out16, _io_out32
        GLOBAL  _io_load_eflags, _io_store_eflags
[SECTION .text]
_io_hlt:     ; void io_hlt(void);
        HLT
        RET
_io_cli:     ; void io_cli(void);
        CLI
        RET
_io_sti:     ; void io_sti(void);
        STI
        RET
_io_stihlt: ; void io_stihlt(void);
        STI
        HLT
        RET
_io_in8:     ; int io_in8(int port);
        MOV      EDX, [ESP+4]      ; port
        MOV      EAX,0
        IN       AL, DX
        RET
_io_in16:   ; int io_in16(int port);

        MOV      EDX, [ESP+4]      ; port
        MOV      EAX,0
        IN       AX, DX
        RET
_io_in32:   ; int io_in32(int port);
        MOV      EDX, [ESP+4]      ; port
        IN       EAX, DX
        RET
_io_out8:   ; void io_out8(int port, int data);
        MOV      EDX, [ESP+4]      ; port
        MOV      AL, [ESP+8]       ; data
        OUT      DX, AL
        RET
_io_out16:  ; void io_out16(int port, int data);
        MOV      EDX, [ESP+4]      ; port
        MOV      EAX, [ESP+8]      ; data
        OUT      DX, AX
        RET
_io_out32:  ; void io_out32(int port, int data);
        MOV      EDX, [ESP+4]      ; port
        MOV      EAX, [ESP+8]      ; data
        OUT      DX, EAX
        RET
_io_load_eflags:     ; int io_load_eflags(void);
        PUSHFD       ; 指PUSH EFLAGS
        POP      EAX
        RET
_io_store_eflags:   ; void io_store_eflags(int eflags);
        MOV      EAX, [ESP+4]
        PUSH EAX
        POPFD ; 指POP EFLAGS
        RET
_print_s:
        mov  esi,[esp+4H]                 ;保护模式DS=0,数据用绝对地址访问
        mov  cl, 0x09                   ;蓝色字体
        mov  edi, 0xb8000+22*160        ;指定显示在某行,显卡内存地址也需用绝对地址访问     
        call printnew
        RET
_get_char:
        RET