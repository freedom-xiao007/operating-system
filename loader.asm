; BOOT_INFO相关
CYLS	EQU		0x0ff0			; 引导扇区设置
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 关于颜色的信息
SCRNX	EQU		0x0ff4			; 分辨率X
SCRNY	EQU		0x0ff6			; 分辨率Y
VRAM	EQU		0x0ff8			; 图像缓冲区的起始地址

;加载到一块无人用的地址
ORG 10000h
JMP print_load_info

print_load_info:
	;清屏
	MOV AH,6
	MOV AL,0
	MOV CH,0
	MOV CL,0
	MOV DH,26
	MOV DL,79
	MOV BH,7
	INT 10H

	MOV AX,	CS
	MOV DS,	AX
	MOV ES,	AX
	MOV AX,	0x00
	MOV SS,	AX
	MOV SP,	0x7c00
	;=======	display on screen : Start Loader......
	MOV AX,	1301h
	MOV BX,	000fh
	MOV DX,	0200h		;row 2
	MOV CX,	12
	PUSH AX
	MOV AX,	DS
	MOV ES,	AX
	POP AX
	MOV BP,	StartLoaderMessage
	INT 10h
frames_setting:
; 画面モードを設定

		MOV		AL,0x13			; VGA显卡，320x200x8bit
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8	; 屏幕的模式（参考C语言的引用）
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000
bios_Indicator_light_get:
; 通过BIOS获取指示灯状态
		MOV		AH,0x02
		INT		0x16 			; keyboard BIOS
		MOV		[LEDS],AL
show_loader_end:
;=======	display on screen :  Loader end
	MOV AX,	1301h
	MOV BX,	000fh
	MOV DX,	0200h		;row 2
	MOV CX,	12
	PUSH AX
	MOV AX,	DS
	MOV ES,	AX
	POP AX
	MOV BP,	LoaderEndMessage
	INT 10h
fin:
	HLT ;CPU停止,等待指令
	JMP fin ;无限循环

;=======	display messages
StartLoaderMessage:	db	"Start Loader"
LoaderEndMessage:	db	"Loader end"