asmc=dasm
main:
	$(asmc) src/main.s -f3 -v5 -ogame.bin
