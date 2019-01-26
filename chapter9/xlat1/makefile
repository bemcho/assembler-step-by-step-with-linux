xlat1: xlat1.o
	ld -g -o xlat1 xlat1.o
xlat1.o: xlat1.asm
	nasm -f elf64 -g -F dwarf xlat1.asm -l xlat.lst
