hexdump2: hexdump2.o
	ld -g -o hexdump2 hexdump2.o
hexdump2.o: hexdump2.asm
	nasm -f elf64 -g -F dwarf hexdump2.asm -l hexdump2.lst
