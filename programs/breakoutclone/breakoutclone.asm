; Program name: Breakout Clone
; Author: Mason Fisher
; Created: March 4th, 2020
; Modified: March 2nd, 2020
; Description: A little breakout clone

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross
					include "lib/xmacro.asm"; 2600 macros or the setHorizPos routine

SpriteHeight	equ #2

					seg.u Variables
					org $80

SpritePtr	.word

XPos			.byte

Tempa			.byte
Bit2p0		.byte
Colp0			.byte
YP0				.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #<sprDat
					sta SpritePtr
					lda #>sprDat
					sta SpritePtr+1
					lda #$4c						; Starting X position
					sta XPos

NFrame:		lsr SWCHB						; Reset switch
					bcc start						; If the user hit the reset switch jump to the start label
					VERTICAL_SYNC
					TIMER_SETUP 37
					lda #$00						; The darkest black in the palette
					sta COLUBK					; Background color
					lda #$32						; A shade of reddish-orange
					sta COLUPF					; Playfield color

					lda #1
					sta CTRLPF					; Set Symetric Playfield Mode to on

					lda #$af
					sta YP0
					lda XPos
					ldx #0
					jsr SetHorizPos
					sta WSYNC
					sta HMOVE

					TIMER_WAIT					; A macro that makes the TIA timer wait until it counts down to zero
					lda #0
					sta VBLANK

					TIMER_SETUP 192			; Make TIA timer wait for 192 scanlines

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
MoveJoy:	ldx XPos
					lda #%01000000	; Player 0 left
					bit SWCHA				; Test that bit
					bne SkipLt			; Branch to SkipLt label if player is not pushing the joystick left
					cpx #1
					bcc SkipLt
					dex

SkipLt:		lda #%10000000	; Player 0 right
					bit SWCHA				; Test that bit
					bne SkipJoy			; Branch to SkipJoy label if player is not pushing the joystick right
					cpx #$98
					bcs SkipJoy
					inx

SkipJoy:	stx XPos
					rts

					align $100; make sure data doesn't cross page boundary

; The sprite is flipped as that's how it works in the routine

sprDat:		.byte #0
					.byte #0
        	.byte #%11111111

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
