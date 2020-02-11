asmc=dasm
flags=-f3 -v5 -o
main:
	$(asmc) starry/starry.asm $(flags)compiled/starry.bin
	$(asmc) rainbow/rainbow.asm $(flags)compiled/rainbow.bin
	$(asmc) playfield/playfield.asm $(flags)compiled/playfield.bin
	$(asmc) sprites/sprites.asm $(flags)compiled/sprites.bin
	$(asmc) sprites2/sprites2.asm $(flags)compiled/sprites2.bin
	$(asmc) setHorizPos/setHorizPos.asm $(flags)compiled/setHorizPos.bin
	$(asmc) joysticks/joysticks.asm $(flags)compiled/joysticks.bin
