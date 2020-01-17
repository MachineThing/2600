; Tell DASM we are using 6502 instructions
					processor 6502

; Saving these libraries for later!
			;include "src/lib/vcs.asm"
			;include "src/lib/macro.asm"

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

start:		ldx #100
loop:			dex
					bne loop
					jmp start

; Skip to address FFFC in the ROM
					org $fffc
						.word start
						.word start
