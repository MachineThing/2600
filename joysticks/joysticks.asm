; Program name: setHorizPos: because positioning is not enough
; Author: Mason Fisher
; Created: Febuary 11th, 2020
; Modified: Febuary 11th, 2020
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
Tempx					.byte

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
					ldx #30

LVBlank:	sta WSYNC
					dex
					bne LVBlank

					; Joystick code goes here
MoveJoy:	lda #%00010000	; Player 0 up
					bit SWCHA				; Test that bit
					bne SkipUp			; Branch to SkipUp label if player is not pushing the joystick up
					inc YPos				; Increment YPos

SkipUp:		lda #%00100000	; Player 0 down
					bit SWCHA				; Test that bit
					bne SkipDn			; Branch to SkipUp label if player is not pushing the joystick down
					dec YPos				; Increment YPos

SkipDn:		lda #%01000000	; Player 0 left
					bit SWCHA				; Test that bit
					bne SkipLt			; Branch to SkipUp label if player is not pushing the joystick left
					dec XPos				; Increment YPos

SkipLt:		lda #%10000000	; Player 0 right
					bit SWCHA				; Test that bit
					bne SkipJoy			; Branch to SkipUp label if player is not pushing the joystick right
					inc XPos				; Increment YPos

SkipJoy:	lda XPos
					ldx #0
					jsr SetHorizPos
					sta WSYNC
					sta HMOVE

					ldx #192

LVScan:		txa
					sta Tempx
					lda #$26
					sta COLUBK
					lda Tempx
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

				; 34 lines of overscan
					ldx #34
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
