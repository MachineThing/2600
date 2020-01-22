asmc=dasm
main:
	$(asmc) starry/starry.asm -f3 -v5 -ocompiled/starry.bin
