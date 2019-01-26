;  Executable name : uppercaser2
;  Version         : 1.0
;  Created date    : 3/25/2009
;  Last update     : 3/25/2009
;  Author          : Jeff Duntemann
;  Description     : A simple program in assembly for Linux, using NASM 2.05,
;    demonstrating simple text file I/O (through redirection) for reading an
;    input file to a buffer in blocks, forcing lowercase characters to 
;    uppercase, and writing the modified buffer to an output file.
;
;  Run it this way:
;    uppercaser2 > (output file) < (input file)  
;
;  Build using these commands:
;    nasm -f elf -g -F stabs uppercaser2.asm
;    ld -o uppercaser2 uppercaser2.o
;
SECTION .bss			; Section containing uninitialized data

	BUFFLEN	equ 1024	; Length of buffer
	Buff: 	resb BUFFLEN	; Text buffer itself
	
SECTION .data			; Section containing initialised data

SECTION .text			; Section containing code

global 	_start			; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...

; Read a buffer full of text from stdin:
read:

	mov rax,0		; Specify sys_read call
	mov rdi,0		; Specify File Descriptor 0: Standard Input
	mov rsi,Buff		; Pass offset of the buffer to read to
	mov rdx,BUFFLEN		; Pass number of bytes to read at one pass
	syscall			; Call sys_read to fill the buffer

	
	mov rbx,rax		; Copy sys_read return value for safekeeping
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin
	je Done			; Jump If Equal (to 0, from compare)

; Set up the registers for the process buffer step:
     
	mov rcx,rbx		; Place the number of bytes read into ecx
	mov rbp,Buff		; Place address of buffer into ebp
	dec rbp			; Adjust count to offset
	;; 
; Go through the buffer and convert lowercase to uppercase characters:
Scan:
	cmp byte [rbp+rcx],61h	; Test input char against lowercase 'a'
	jb Next			; If below 'a' in ASCII, not lowercase
	cmp byte [rbp+rcx],7Ah	; Test input char against lowercase 'z'
	ja Next			; If above 'z' in ASCII, not lowercase
				; At this point, we have a lowercase char
	sub byte [rbp+rcx],20h	; Subtract 20h to give uppercase...
Next:	dec rcx			; Decrement counter
	jnz Scan		; If characters remain, loop back

; Write the buffer full of processed text to stdout:
Write:
	mov rax,1		; Specify sys_write call
	mov rdi,1		; Specify File Descriptor 1: Standard output
	mov rsi,Buff		; Pass offset of the buffer
	mov rdx,rbx		; Pass the # of bytes of data in the buffer
	syscall			; Make kernel call

	jmp read		; Loop back and load another buffer full

; All done! Let's end this party:
Done:
	mov rax,60		; Code for Exit Syscall
	mov rdi,0		; Return a code of zero	
	syscall			; Make kernel call
