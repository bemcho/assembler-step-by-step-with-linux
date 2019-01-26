kangaroo: kangaroo.o
	ld -g -o kangaroo kangaroo.o
kangaroo.o: kangaroo.asm
	nasm -f elf64 -g -F dwarf kangaroo.asm -l kangaroo.lst
