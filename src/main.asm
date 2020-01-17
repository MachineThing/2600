; Tell DASM we are using 6502 instructions
					processor 6502

			include "src/lib/vcs.asm"
			;include "src/lib/macro.asm" ; not being used right now

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

start:		lda #$56
					sta COLUBK
					jmp start

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start
						.word start
