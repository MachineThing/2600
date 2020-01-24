; Program name: Sprites 2: The sequel
; Author: Mason Fisher
; Created: January 24rd, 2020
; Modified: January 24th, 2020
; Description: Sprites but they are not stripes.

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross

SpriteHeight	equ #8

					seg.u Variables
					org $80
YPos					.byte

					seg Code
					org $f000

Counter				equ $80

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
					lda #0
					ldy Counter

ScanLoop:	sta WSYNC	; wait for next scanline
					sta COLUBK	; set the background color
					sta GRP0	; set sprite 0 pixels
					adc #1		; increment A to cycle through colors and bitmaps
					dex
					bne ScanLoop

					stx COLUBK
					stx GRP0
				; 30 lines of overscan
					ldx #30
LVOver:		sta WSYNC
					dex
					bne LVOver

				; Cycle the sprite colors for the next frame
					inc Counter
					lda Counter
					sta COLUP0
					jmp NFrame

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
