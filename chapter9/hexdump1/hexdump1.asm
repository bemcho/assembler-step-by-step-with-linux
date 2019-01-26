;  Executable name : hexdump1
;  Version         : 1.0
;  Created date    : 4/4/2009
;  Last update     : 4/4/2009
;  Author          : Jeff Duntemann
;  Description     : A simple program in assembly for Linux, using NASM 2.05,
;    demonstrating the conversion of binary values to hexadecimal strings.
;    It acts as a very simple hex dump utility for files, though without the
;    ASCII equivalent column.
;
;  Run it this way:
;    hexdump1 < (input file)  
;
;  Build using these commands:
;    nasm -f elf64 -g -F dwarf hexdump1.asm -l hexdump1.lst
;    ld -g -o hexdump1 hexdump1.o
;
SECTION .bss			; Section containing uninitialized data

	BUFFLEN	equ 16		; We read the file 16 bytes at a time
	Buff: 	resb BUFFLEN	; Text buffer itself
	
SECTION .data			; Section containing initialised data

	HexStr:	db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
	HEXLEN equ $-HexStr

	Digits:	db "0123456789ABCDEF"
		
SECTION .text			; Section containing code

global 	_start			; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...

; Read a buffer full of text from stdin:
Read:

	mov rax,0		; Specify sys_read call
	mov rdi,0		; Specify File Descriptor 0: Standard Input
	mov rsi,Buff		; Pass offset of the buffer to read to
	mov rdx,BUFFLEN		; Pass number of bytes to read at one pass
	syscall			; Call sys_read to fill the buffer

	mov r11,rax		; Copy sys_read return value for safekeeping
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin
	je Done			; Jump If Equal (to 0, from compare)



; Set up the registers for the process buffer step:
	mov rdi,HexStr		; Place address of line string into rdi
	xor rcx,rcx		; Clear line string pointer to 0
	xor rdx,rdx
; Go through the buffer and convert binary values to hex digits:
Scan:
	xor rax,rax		; Clear eax to 0
; Here we calculate the offset into HexStr, which is the value in ecx X 3
	
; Copy the character counter into edx
	

; Get a character from the buffer and put it in both eax and ebx:
	mov al, byte [rsi+rcx]	; Put a byte from the input buffer into al
	mov rbx,rax		; Duplicate the byte in bl for second nybble

; Look up low nybble character and insert it into the string:
	and al,0Fh		   ; Mask out all but the low nybble
	mov al,byte [Digits+rax]   ; Look up the char equivalent of nybble
	mov byte [HexStr+rdx+2],al ; Write the char equivalent to line string

; Look up high nybble character and insert it into the string:
	shr bl,4		; Shift high 4 bits of char into low 4 bits
	mov bl,byte [Digits+rbx] ; Look up char equivalent of nybble
	mov byte [HexStr+rdx+1],bl ; Write the char equivalent to line string

; Bump the buffer pointer to the next character and see if we're done:
	inc rcx		; Increment line string pointer
	inc rdx		; 
	inc rdx		; Increment to the next(00 + inreval) slot in HexString	
	inc rdx		;
	cmp rcx,r11	; Compare to the number of characters in the buffer
	jna Scan	; Loop back if ecx is <= number of chars in buffer

								; Write the line of hexadecimal values to stdout:
Write:	
	mov rax,1		; Specify sys_write call
	mov rdi,1		; Specify File Descriptor 1: Standard output
	mov rsi,HexStr		; Pass offset of line string
	mov rdx,HEXLEN		; Pass size of the line string
	syscall
								; Make kernel call to display line string
	jmp Read		; Loop back and load file buffer again

; All done! Let's end this party:
Done:
	mov rax,60		; Code for Exit Syscall
	mov rdi,0		; Return a code of zero	
	syscall			; Make kernel call
