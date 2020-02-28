; Program name: Playfield and sprite
; Author: Mason Fisher
; Created: Febuary 12th, 2020
; Modified: Febuary 19th, 2020
; Description: A playfield and a smilely!

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross
					include "lib/xmacro.asm"; 2600 macros or the setHorizPos routine

SpriteHeight	equ #10

					seg.u Variables
					org $80
PFPtr					.word	; pointer to playfield data
PFIndex				.byte	; offset into playfield array
PFCount				.byte	; lines left in this playfield segment

SpritePtr			.word
ColorPtr			.word

XPos					.byte
YPos					.byte

Tempx					.byte
Tempa					.byte
Bit2p0				.byte
Colp0					.byte
YP0						.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #<PlayfieldData
					sta PFPtr
					lda #>PlayfieldData
					sta PFPtr+1
					lda #<sprDat
					lda SpritePtr
					lda #>sprDat
					lda SpritePtr+1
					lda #<SprCol
					lda ColorPtr
					lda #>SprCol
					sta ColorPtr+1
					lda #235
					sta YPos
					lda #39
					sta XPos

NFrame:		lsr SWCHB
					bcc start
					VERTICAL_SYNC
					TIMER_SETUP 37
					lda #$88
					sta COLUBK
					lda #$5b
					sta COLUPF
					lda #$68
					sta COLUP0
					lda #1
					sta CTRLPF			; Set Symetric Playfield Mode to on
					lda #0
					sta PFIndex

					lda YPos
					sta YP0
					lda XPos
					ldx #0
					jsr SetHorizPos
					sta WSYNC
					sta HMOVE

					TIMER_WAIT
					lda #0
					sta VBLANK

					TIMER_SETUP 192
					SLEEP 10

NewPFSegment:
					ldy PFIndex
					lda (PFPtr),y
					beq NoMoreSegs
					sta PFCount

					iny
					lda (PFPtr),y
					tax
					iny
					lda (PFPtr),y
					sta Tempa
					iny
					lda (PFPtr),y
					iny
					sty PFIndex
					tay

					sta WSYNC
					stx PF0
					lda Tempa
					sta PF1
					lda Bit2p0
					sta GRP0
					sty PF2

					ldx PFCount

KernelLoop:
					lda #SpriteHeight
					inc YP0
					sbc YP0
					bcs DoDraw
					lda #0

DoDraw:		pha
					tay
					lda (ColorPtr),y
					sta Colp0

					pla
					asl
					tay
					lda (SpritePtr),y
					sta Bit2p0
					iny
					lda (SpritePtr),y

					sta WSYNC
					sta GRP0
					lda Colp0
					sta COLUP0
					dex
					beq NewPFSegment

					sta WSYNC
					lda Bit2p0
					sta GRP0
					jmp KernelLoop

NoMoreSegs
					lda #0
					sta COLUBK

					TIMER_WAIT

					TIMER_SETUP 29
					lda #2
					sta VBLANK
					jsr MoveJoy
					TIMER_WAIT
					jmp NFrame

SetHorizPos:
					sta WSYNC
					bit 0
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

					; Joystick code goes here
MoveJoy:	ldx YPos
					lda #%00010000	; Player 0 up
					bit SWCHA				; Test that bit
					bne SkipUp			; Branch to SkipUp label if player is not pushing the joystick up
					cpx #175
					bcc SkipUp
					inx

SkipUp:		lda #%00100000	; Player 0 down
					bit SWCHA				; Test that bit
					bne SkipDn			; Branch to SkipUp label if player is not pushing the joystick down
					cpx #1
					bcs SkipDn
					dex

SkipDn:		stx YPos
					ldx XPos
					lda #%01000000	; Player 0 left
					bit SWCHA				; Test that bit
					bne SkipLt			; Branch to SkipUp label if player is not pushing the joystick left
					cpx #254
					bcc SkipLt
					dex

SkipLt:		lda #%10000000	; Player 0 right
					bit SWCHA				; Test that bit
					bne SkipJoy			; Branch to SkipUp label if player is not pushing the joystick right
					cpx #1
					bcc SkipJoy
					inx

SkipJoy:	stx XPos
					rts

PlayfieldData:
        	.byte 13,#%00000000,#%00000000,#%00000000

        	.byte 04,#%00000000,#%00011000,#%00011000
        	.byte 04,#%00000000,#%00111100,#%00111100
        	.byte 04,#%00000000,#%01111110,#%01111110
        	.byte 04,#%00000000,#%00111100,#%00111100

        	.byte 9,#%00000000,#%00000000,#%00000000

        	.byte 04,#%00000000,#%00011000,#%00011000
        	.byte 04,#%00000000,#%00111100,#%00111100
        	.byte 04,#%00000000,#%01111110,#%01111110
        	.byte 04,#%00000000,#%00111100,#%00111100

        	.byte 9,#%00000000,#%00000000,#%00000000

        	.byte 04,#%00000000,#%00011000,#%00011000
        	.byte 04,#%00000000,#%00111100,#%00111100
        	.byte 04,#%00000000,#%01111110,#%01111110
        	.byte 04,#%00000000,#%00111100,#%00111100

        	.byte 16,#%00000000,#%00000000,#%00000000
        	.byte 0

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

; Sprite color data
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
