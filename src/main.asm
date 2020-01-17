; Tell DASM we are using 6502 instructions
					processor 6502

			include "src/lib/vcs.asm"
			include "src/lib/macro.asm"

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

start:		sei
					cld
					ldx #$ff
					txs

					ldx #$ff
					lda #$00
zeroZP		sta COLUBK ; Set the color of the background to black
					dex
					bne zeroZP

					lda #$0e
					sta COLUBK ; Set the color of the background to white
					lda #$00
					sta COLUBK ; Set the color of the background to black

					jmp start

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start
						.word start
