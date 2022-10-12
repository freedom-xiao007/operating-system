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

OffSetOfLoader	equ	0x0820

;程序核心
entry:
    	MOV AX,0  ;初始化寄存器
    	MOV SS,AX
    	MOV SP,0x7c00
    	MOV DS,AX
    	MOV ES,AX
read_file_ready: ;读软盘准备
	MOV AH, 02 ;指明读扇区功能调用
	MOV AL, 1 ;指明要读的扇区数为1
	MOV DL, 0x00 ;指明要读的驱动为A
	MOV DH, 0 ;指定读取的磁头0
	MOV CH, 0 ;柱面0
	MOV CL, 1 ;读取扇区1（因为目前没有其他文件，就只有扇区1的启动区数据，所以我们这从1开始，不是从2开始）
	;下面三句指定读取到内存地址0x0820处
	MOV AX, OffSetOfLoader
	MOV ES, AX
	MOV BX, 0 ;数据读取后放到的内存地址
read_file:
	;调试用，用于查看读取磁盘是否达到了循环次数,call相当于函数调用
	MOV SI, read_file_msg
	CALL func_show_msg

	;前面调用函数时，改变了有关的寄存器，这里重置回来（也可以使用栈，但这个方便点）
	MOV AH, 02 ;指明读扇区功能调用
	MOV AL, 1 ;指明要读的扇区数为1
	MOV BX, 0 ;数据读取后放到的内存地址

	INT 13H ;调用BIOS文件读取
	JNC read_file_loop
	MOV SI, read_file_error_msg
	JMP show_msg_info
read_file_loop: ;循环读取内容，循环的顺序是扇区->磁头->柱面，不知道这里面是否有什么说法？可以调换吗？
	;把内存地址后移0x200
	MOV AX, ES
	ADD AX, 0x0020
	MOV ES, AX
	ADD CL, 1 ;加1，读取下一个扇区
	CMP CL, 18 ;如果CL扇区大于软盘总扇区数18，则说明读取完成，不再读取
	JBE read_file
	; 上面是扇区的循环，完毕后到磁头的循环,重置扇区，增加磁头到反面1
	MOV CL, 1
	ADD DH, 1
	CMP DH, 2
	JB read_file
	;上面都完成后，到柱面的读取循环，重置扇区(前面已重置）和磁头，增加柱面（不知道为啥书中不是80而是10）
	MOV DH, 0
	ADD CH, 1
	CMP CH, 10
	JB read_file
show_mem_file: ;打印显示刚才加载的文件内容
	MOV AX, OffSetOfLoader
	MOV ES, AX
	MOV DI, 0
show_mem_byte: ;整个数据也就512，所以循环512次即可
	MOV AL, BYTE [ES:DI]
	CMP DI, 512
	JE loader_end
	ADD DI, 1
	MOV AH,0x0e ;显示一个文字
    	MOV BX,15 ;指定字符的颜色
    	INT 0x10 ;调用显卡BIOS	
	JMP show_mem_byte
loader_end: ;启动程序加载完成
	MOV AL,0x0a
    	MOV AH,0x0e ;显示一个文字
    	MOV BX,15 ;指定字符的颜色
    	INT 0x10 ;调用显卡BIOS
	MOV SI,msg
show_msg_info: ;加载完成，成功显示
    	MOV AL,[SI]
    	ADD SI,1
    	CMP AL,0
    	JE fin
    	MOV AH,0x0e ;显示一个文字
    	MOV BX,15 ;指定字符的颜色
    	INT 0x10 ;调用显卡BIOS
    	JMP show_msg_info
fin:
    	HLT ;CPU停止,等待指令
    	JMP fin ;无限循环
func_show_msg:
    	MOV AL,[SI]
    	ADD SI,1
    	CMP AL,0
    	JE func_ret
    	MOV AH,0x0e ;显示一个文字
    	MOV BX,15 ;指定字符的颜色
    	INT 0x10 ;调用显卡BIOS
    	JMP func_show_msg
func_ret:
	RET
read_file_msg:
    	DB "r"
    	DB 0
read_file_error_msg:
    	DB 0x0a , 0x0a ;换行两次
    	DB "read file error!!!"
    	DB 0x0a
    	DB 0
show_mem_info_msg:
	DB 0x0a , 0x0a ;换行两次
    	DB "start show mem file!!!"
    	DB 0x0a
    	DB 0
msg:
    	DB 0x0a , 0x0a ;换行两次
    	DB "hello, my OS, boot loader end"
    	DB 0x0a
    	DB 0
    
boot_flag: ;启动区标识
    	TIMES 0x1fe-($-$$) DB 0 ;填写0x00,直到0x001fe
    	DB 0x55, 0xaa