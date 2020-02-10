; Program name: setHorizPos: because positioning is not enough
; Author: Mason Fisher
; Created: January 24rd, 2020
; Modified: January 24th, 2020
; Description: Sprites but they are not stripes.

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross
					include "lib/xmacro.asm"; 2600 macros or the setHorizPos routine

SpriteHeight	equ #10

					seg.u Variables
					org $80
XPos					.byte
YPos					.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #5
					sta XPos
					sta YPos

NFrame:
					lsr SWCHB
					bcc start
					VERTICAL_SYNC
					ldx #35

LVBlank:	sta WSYNC
					dex
					bne LVBlank

					inc XPos
        	inc YPos

					lda XPos
					ldx #0
					jsr SetHorizPos
					sta WSYNC
					sta HMOVE

					ldx #192

LVScan:		txa
					sec
					sbc YPos
					cmp SpriteHeight				; If the SprightHeight is greater than the Y position
					bcc InSprite
					lda #0

InSprite:	tay											; Transfer the A register's value to the Y register
					lda sprDat,Y						; Load bitmap data
					sta WSYNC								; Wait for sync
					sta GRP0								; Set the sprite bitmap
					lda SprCol,Y						; Load color data
					sta COLUP0							; Set the sprite color

					dex
					bne LVScan

				; 29 lines of overscan
					ldx #29
LVOver:		sta WSYNC
					dex
					bne LVOver

				; Cycle the sprite colors for the next frame
					jmp NFrame

SetHorizPos:
					sta WSYNC
					sec
DivideLoop:
					sbc #15
					bcs DivideLoop
					eor #7
					asl
					asl
					asl
					asl
					sta RESP0,x
					sta HMP0,x
					rts

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
