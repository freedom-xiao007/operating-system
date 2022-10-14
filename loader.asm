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

	JMP	fin
fin:
	HLT ;CPU停止,等待指令
	JMP fin ;无限循环

;=======	display messages
StartLoaderMessage:	db	"Start Loader"