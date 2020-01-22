asmc=dasm
main:
	$(asmc) starry/starry.asm -f3 -v5 -ocompiled/starry.bin
	$(asmc) rainbow/rainbow.asm -f3 -v5 -ocompiled/rainbow.bin
