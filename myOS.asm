; cherry-os
ORG 0x7c00 ;指定程序装载的位置

;下面用于描述FAT12格式的软盘
JMP entry
DB 0x90
DB "CHRRYIPL" ;启动区的名称可以是任意的字符串，但长度必须是8字节
DW 512; 每一个扇区的大小，必须是512字节
DB 1 ;簇的大小（必须为1个扇区)
DW 1 ;FAT的起始位置（一般从第一个扇区开始）
DB 2 ;FAT的个数 必须是2
DW 224;根目录的大小 一般是224项
DW 2880; 该磁盘的大小 必须是2880扇区
DB 0xf0;磁盘的种类 必须是0xf0
DW 9;FAT的长度 必须是9扇区
DW 18;1个磁道(track) 有几个扇区 必须是18
DW 2; 磁头个数 必须是2
DD 0; 不使用分区，必须是0
DD 2880; 重写一次磁盘大小
DB 0,0,0x29 ;扩展引导标记 固定0x29
DD 0xffffffff ;卷列序号
DB "CHERRY-OS  " ;磁盘的名称（11个字节）
DB "FAT12   " ;磁盘的格式名称（8字节）
TIMES 18 DB 0; 先空出18字节 这里与原文写法不同

;程序核心
entry:
    MOV AX,0  ;初始化寄存器
    MOV SS,AX
    MOV SP,0x7c00
    MOV DS,AX
    MOV ES,AX
    MOV SI,msg
putloop:
    MOV AL,[SI]
    ADD SI,1
    CMP AL,0
    JE fin
    MOV AH,0x0e ;显示一个文字
    MOV BX,15 ;指定字符的颜色
    INT 0x10 ;调用显卡BIOS
    JMP putloop
fin:
    HLT ;CPU停止,等待指令
    JMP fin ;无限循环
msg:
    DB 0x0a , 0x0a ;换行两次
    DB "hello, my OS"
    DB 0x0a
    DB 0
    
    TIMES 0x1fe-($-$$) DB 0 ;填写0x00,直到0x001fe
    
    DB 0x55, 0xaa