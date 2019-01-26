uppercaser2: uppercaser2.o
	ld -g -o uppercaser2 uppercaser2.o
uppercaser2.o: uppercaser2.asm
	nasm -f elf64 -g -F dwarf uppercaser2.asm -l uppercaser2.lst
