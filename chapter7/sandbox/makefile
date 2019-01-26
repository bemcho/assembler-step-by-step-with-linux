sandbox: sandbox.o
	ld -g -o sandbox sandbox.o
sandbox.o: sandbox.asm
	nasm -f elf64 -w -g -F dwarf sandbox.asm -l sandbox.lst
clean:
	rm -rf sandbox sandbox.o
