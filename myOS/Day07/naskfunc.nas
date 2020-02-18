; ; nasmfunc.asm
; ; TAB=4

; section .text
; 		; 以下にこのプログラムに含まれる関数名を書いていく
; 		GLOBAL	io_hlt, io_cli, io_sti, io_stihlt
; 		GLOBAL	io_in8, io_in16, io_in32
; 		GLOBAL	io_out8, io_out16, io_out32
; 		GLOBAL	io_load_eflags, io_store_eflags
; 		GLOBAL	load_gdtr, load_idtr
; 		GLOBAL	asm_inthandler21, asm_inthandler27, asm_inthandler2c
; 		EXTERN	inthandler21, inthandler27, inthandler2c


; ; 以下は実際の関数
; io_hlt:	; void io_hlt(void);
; 		HLT
; 		RET

; io_cli:
; 		CLI
; 		RET

; io_sti:
; 		STI
; 		RET

; io_stihlt:
; 		STI
; 		HLT
; 		RET

; io_in8:
; 		MOV			EDX, [ESP+4]	; port
; 		MOV			EAX, 0
; 		IN			AL, DX
; 		RET

; io_in16:
; 		MOV			EDX, [ESP+4]
; 		MOV			EAX, 0
; 		IN			AX, DX
; 		RET

; io_in32:
; 		MOV			EDX, [ESP+4]
; 		IN			EAX, DX
; 		RET

; io_out8:
; 		MOV			EDX, [ESP+4]		; port
; 		MOV			AL, [ESP+8]			; data
; 		OUT			DX, AL
; 		RET

; io_out16:
; 		MOV			EDX, [ESP+4]
; 		MOV			EAX, [ESP+8]
; 		OUT			DX, AX
; 		RET

; io_out32:
; 		MOV			EDX, [ESP+4]
; 		MOV			EAX, [ESP+8]
; 		OUT			DX, EAX
; 		RET

; io_load_eflags:
; 		PUSHFD		; PUSH EFLAGS という意味……らしい
; 		POP			EAX
; 		RET

; io_store_eflags:
; 		MOV			EAX, [ESP+4]
; 		PUSH		EAX
; 		POPFD		; POP EFLAGS という意味っぽい
; 		RET

; load_gdtr:		; void load_gdtr(int limit, int addr);
; 		MOV		AX,[ESP+4]		; limit
; 		MOV		[ESP+6],AX
; 		LGDT	[ESP+6]
; 		RET

; load_idtr:		; void load_idtr(int limit, int addr);
; 		MOV		AX,[ESP+4]		; limit
; 		MOV		[ESP+6],AX
; 		LIDT	[ESP+6]
; 		RET

; asm_inthandler21:
; 		PUSH	ES
; 		PUSH	DS
; 		PUSHAD
; 		MOV		EAX,ESP
; 		PUSH	EAX
; 		MOV		AX,SS
; 		MOV		DS,AX
; 		MOV		ES,AX
; 		CALL	inthandler21
; 		POP		EAX
; 		POPAD
; 		POP		DS
; 		POP		ES
; 		IRETD

; asm_inthandler27:
; 		PUSH	ES
; 		PUSH	DS
; 		PUSHAD
; 		MOV		EAX,ESP
; 		PUSH	EAX
; 		MOV		AX,SS
; 		MOV		DS,AX
; 		MOV		ES,AX
; 		CALL	inthandler27
; 		POP		EAX
; 		POPAD
; 		POP		DS
; 		POP		ES
; 		IRETD

; asm_inthandler2c:
; 		PUSH	ES
; 		PUSH	DS
; 		PUSHAD
; 		MOV		EAX,ESP
; 		PUSH	EAX
; 		MOV		AX,SS
; 		MOV		DS,AX
; 		MOV		ES,AX
; 		CALL	inthandler2c
; 		POP		EAX
; 		POPAD
; 		POP		DS
; 		POP		ES
; 		IRETD


; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード	
[INSTRSET "i486p"]				; 486の命令まで使いたいという記述
[BITS 32]						; 32ビットモード用の機械語を作らせる
[FILE "naskfunc.nas"]			; ソースファイル名情報

		GLOBAL	_io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL	_io_in8,  _io_in16,  _io_in32
		GLOBAL	_io_out8, _io_out16, _io_out32
		GLOBAL	_io_load_eflags, _io_store_eflags
		GLOBAL	_load_gdtr, _load_idtr
		GLOBAL	_asm_inthandler21, _asm_inthandler27, _asm_inthandler2c
		EXTERN	_inthandler21, _inthandler27, _inthandler2c

[SECTION .text]

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_io_cli:	; void io_cli(void);
		CLI
		RET

_io_sti:	; void io_sti(void);
		STI
		RET

_io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

_io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

_io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

_io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

_io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

_io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS という意味
		POP		EAX
		RET

_io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS という意味
		RET

_load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

_load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD
