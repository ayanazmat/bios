; source: http://www.brokenthorn.com/Resources/OSDev4.html
;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************

bits	16							; We are still in 16 bit Real Mode

org		0x7c00						; We are loaded by BIOS at 0x7C00

start:          jmp loader	


msg	db	"Welcome to My Operating System!", 0		; the string to print

;***************************************
;	Prints a string
;	DS=>SI: 0 terminated string
;***************************************

Print:
			lodsb					; load next byte from string from SI to AL
			or			al, al		; Does AL=0?
			jz			PrintDone	; Yep, null terminator found-bail out
			mov			ah,	0eh	; Nope-Print the character
			int			10h
			jmp			Print		; Repeat until null terminator found
PrintDone:
			ret					; we are done, so return

;*************************************************;
;	Bootloader Entry Point
;*************************************************;

loader:
	xor	ax, ax		; Setup segments to insure they are 0. Remember that
	mov	ds, ax		; we have ORG 0x7c00. This means all addresses are based
	mov	es, ax		; from 0x7c00:0. Because the data segments are within the same
				; code segment, null em.

	mov	si, msg						; our message to print
	call	Print						; call our print function

	xor	ax, ax						; clear ax
	int	0x12						; get the amount of KB from the BIOS

	cli							; Clear all Interrupts
	hlt							; halt the system
	
times 510 - ($-$$) db 0						; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55							; Boot Signiture