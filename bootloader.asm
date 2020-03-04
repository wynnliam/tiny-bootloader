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

; Finally, we set the stack pointer. This is the "B" part
; in our equation: A * (0x10) + B. To make the equation concrete,
; the last item we put on the stack has physical address:
;
; ss * (0x10) + sp
;
; So going forward, we will have 8k space to put stuff on the
; stack (The stack pointer grows downward).
mov sp, 0x2000
