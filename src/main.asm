; Tell DASM we are using 6502 instructions
			processor 6502

; 4 kilobyte Atari 2600 cartridges start at f000
				org $f000

start:	ldx #100
loop:		dex
				bne loop

; Skip to address FFFC in the ROM
			org $fffc
				.word start
				.word start
