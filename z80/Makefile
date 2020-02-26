build : 
	z80asm -v -l ttt.asm

test :
	z80asm -v -l test.asm
	z80sim -z -m 0 -x test.bin

clean :
	rm -f *.bin

run : ttt.bin
	z80sim -z -m 0 -x ttt.bin
