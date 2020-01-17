asmc=dasm
main:
	$(asmc) src/main.asm -f3 -v5 -ogame.bin
