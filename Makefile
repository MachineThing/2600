asmc=dasm
fold=programs/
flags=-f3 -o
main:
	$(asmc) $(fold)starry/starry.asm $(flags)compiled/starry.bin
	$(asmc) $(fold)rainbow/rainbow.asm $(flags)compiled/rainbow.bin
	$(asmc) $(fold)playfield/playfield.asm $(flags)compiled/playfield.bin
	$(asmc) $(fold)sprites/sprites.asm $(flags)compiled/sprites.bin
	$(asmc) $(fold)sprites2/sprites2.asm $(flags)compiled/sprites2.bin
	$(asmc) $(fold)setHorizPos/setHorizPos.asm $(flags)compiled/setHorizPos.bin
	$(asmc) $(fold)joysticks/joysticks.asm $(flags)compiled/joysticks.bin
	$(asmc) $(fold)complex/complex.asm $(flags)compiled/complex.bin
	$(asmc) $(fold)scoreboard/scoreboard.asm $(flags)compiled/scoreboard.bin
	$(asmc) $(fold)breakoutclone/breakoutclone.asm $(flags)compiled/breakoutclone.bin
