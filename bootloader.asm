; Specifies 16 bit real mode
bits 16

; Our code resides at physical address 0x7C00. So we move
; logical address 0x7C0 into the data segment. To translate
; a logical address to phsycal, we do the following equation:
;
; Physical Addr = A * (0x10) + B
;
; Where A denotes the 64k segment, and B the offset within that
; segment. Note that segments in Real Mode are addressed with
; 16 bits, which gives us an integer from 0 to 64k.

; These lines set the data segment to point to the start of
; our code.
mov ax, 0x7C0
mov ds, ax

; These lines set the stack segment 512 bytes after the data
; segment. We choose 512 bytes because that's how many we have
; for our bootloader.
mov ax, 0x7E0
mov ss, ax

; Do clearscreen call
call clearscreen

; Move cursor to correct position
push 0x0000
call movecursor
add sp, 2

; Print the message
push msg
call print
add sp, 2

; Stop accepting interrupts
cli
; Halt all processing
hlt

; Finally, we set the stack pointer. This is the "B" part
; in our equation: A * (0x10) + B. To make the equation concrete,
; the last item we put on the stack has physical address:
;
; ss * (0x10) + sp
;
; So going forward, we will have 8k space to put stuff on the
; stack (The stack pointer grows downward).
mov sp, 0x2000

clearscreen:
	push bp
	mov bp, sp
	; Push all general registers onto the stack
	pusha

	; Tells BIOS to scroll down the window
	mov ah, 0x07
	; Tells BIOS to clear entire window
	mov al, 0x00
	; Specifies white on black
	mov bh, 0x07
	; Specifies top left as (0, 0)
	mov cx, 0x00
	; 0x18 says 24 rows of chars
	mov dh, 0x18
	; 0x4f says 79 cols of chars
	mov dl 0x4f

	; Video interrupt
	int 0x10

	; Pop all general registers off the stack
	popa
	mov sp, bp
	pop bp
	ret

movecursor:
	push bp
	mov bp, sp
	; Push all general registers onto the stack
	pusha

	; Get the arguments. The contents of bp is 2 bytes,
	; and each argument is a byte. Thus, we need to move 4 bytes
	mov dx, [bp+4]

	; Specify the move cursor interrupt
	mov ah, 0x02
	; The the page to draw to. Since we aren't doing double
	; buffering, we can leave this at 0
	mov bh, 0x00

	int 0x10
	
	; Pop all general registers off the stack
	popa
	mov sp, bp
	pop bp
	ret

print:
	push bp
	mov bp, sp
	; Push all general registers onto the stack
	pusha

	; Grab the argument
	mov si, [bp+4]

	; Set current render page to 0
	mov bh, 0x00
	; Set foreground color. Sine we are in text mode, this
	; is irrelevent.
	mov bl, 0x00
	; Print character to TTY
	mov ah, 0x0E

	.char:
		; grab current character
		mov al, [si]
		; Move string pointer to next character
		add si, 1
		; if al == 0, return
		or al, 0
		je .return
		; Do BIOS interrupt
		int 0x10
		jmp .char

	.return:
		; Pop all general registers off the stack
		popa
		mov sp, bp
		pop bp
		ret

; db command declares and initializes data in the resulting output file
msg:	db "Hello, world!", 0

; Pads the rest of bootloader to have zeros
times 510-(\$-$$) db 0
; Writes the boot signature to end of bootloader
dw 0xAA55
