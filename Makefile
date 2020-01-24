asmc=dasm
main:
	$(asmc) starry/starry.asm -f3 -v5 -ocompiled/starry.bin
	$(asmc) rainbow/rainbow.asm -f3 -v5 -ocompiled/rainbow.bin
	$(asmc) playfield/playfield.asm -f3 -v5 -ocompiled/playfield.bin
	$(asmc) sprites/sprites.asm -f3 -v5 -ocompiled/sprites.bin
	$(asmc) sprites2/sprites2.asm -f3 -v5 -ocompiled/sprites2.bin
