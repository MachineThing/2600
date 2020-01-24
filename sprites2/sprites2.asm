; Program name: Sprites 2: The sequel
; Author: Mason Fisher
; Created: January 24rd, 2020
; Modified: January 24th, 2020
; Description: Sprites but they are not stripes.

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross

SpriteHeight	equ #10

					seg.u Variables
					org $80
YPos					.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #75
					sta YPos

NFrame:		VERTICAL_SYNC
					ldx #36

LVBlank:	sta WSYNC
					dex
					bne LVBlank

					SLEEP 35
					sta RESP0

					ldx #192
10000001
LVScan:		txa
					sec
					sbc YPos
					cmp SpriteHeight
					bcc InSprite
					lda #0

InSprite:	tay
					lda sprDat,Y
					sta WSYNC
					sta GRP0
					lda SprCol,Y
					sta COLUP0

					dex
					bne LVScan

				; 29 lines of overscan
					ldx #29
LVOver:		sta WSYNC
					dex
					bne LVOver

				; Cycle the sprite colors for the next frame
					jmp NFrame

; The sprite is flipped as that's how it works in the routine

sprDat:		.byte #0        ; zero padding, also clears register
        	.byte #%11111111
        	.byte #%10000001
        	.byte #%10111101
        	.byte #%10100101
        	.byte #%10000001
        	.byte #%10100101
        	.byte #%10000001
        	.byte #%11111111

; Cat-head color data
SprCol:		.byte #0        ; unused (for now)
        	.byte #$90
        	.byte #$92
        	.byte #$94
        	.byte #$96
        	.byte #$98			; A friend picked this color :)
        	.byte #$9A
        	.byte #$9C
        	.byte #$9E

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
