hexdump1: hexdump1.o
	ld -g -o hexdump1 hexdump1.o
hexdump1.o: hexdump1.asm
	nasm -f elf64 -g -F dwarf hexdump1.asm -l hexdump1.lst
