bits 	16

org 	0x7C00

times 510 - ($-$$) db 0						; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55							; Boot Signiture