; Program name: Playfield and sprite
; Author: Mason Fisher
; Created: Febuary 12th, 2020
; Modified: March 2nd, 2020
; Description: A playfield and a smilely!

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross
					include "lib/xmacro.asm"; 2600 macros or the setHorizPos routine

SpriteHeight	equ #5

					seg.u Variables
					org $80
PFPtr			.word								; pointer to playfield data
PFIndex		.byte								; offset into playfield array
PFCount		.byte								; lines left in this playfield segment

SpritePtr	.word
ColorPtr	.word

XPos			.byte
YPos			.byte


Tempa			.byte
Bit2p0		.byte
Colp0			.byte
YP0				.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #<PlayfieldData
					sta PFPtr
					lda #>PlayfieldData
					sta PFPtr+1
					lda #<sprDat
					sta SpritePtr
					lda #>sprDat
					sta SpritePtr+1
					lda #<SprCol
					sta ColorPtr
					lda #>SprCol
					sta ColorPtr+1
					lda #230						; Starting Y position
					sta YPos
					lda #28							; Starting X position
					sta XPos

NFrame:		lsr SWCHB						; Reset switch
					bcc start						; If the user hit the reset switch jump to the start label
					VERTICAL_SYNC
					TIMER_SETUP 37
					lda #$90						; A dark shade of blue
					sta COLUBK					; Background color
					lda #$32						; A shade of reddish-orange
					sta COLUPF					; Playfield color

					lda #1
					sta CTRLPF					; Set Symetric Playfield Mode to on
					lda #0
					sta PFIndex

					lda YPos						; Load YPos variable to the A register
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

NewPFSegment:
					; I don't know what this part of the code does really but it renders one part of the playfield if I'm correct
					ldy PFIndex
					lda (PFPtr),y				; Get a byte from the PFPtr variable depending on the Y register
					beq NoMoreSegs			; Jump to the "NoMoreSegs" label if there are no PF segments?
					sta PFCount					; Store the A register to the PFCount label

					iny									; Increment the Y register by 1
					lda (PFPtr),y				; Same as line 85
					tax									; Transfer the A register to the X register
					iny									; Increment the Y register by 1
					lda (PFPtr),y				; Same as line 85
					sta Tempa						; Store A into a temporary variable
					iny									; Increment the Y register by 1
					lda (PFPtr),y				; Same as line 85
					iny									; Increment the Y register by 1
					sty PFIndex					; Store the Y register to the PFIndex variable
					tay									; Transfer the A register to the Y register

					sta WSYNC
					stx PF0							; Store the X register into the Playfield 0 controller
					lda Tempa						; Load the Tempa variable into the A register
					sta PF1							; Store the A register into the Playfield 1 controller
					lda Bit2p0					; Load the Bit2p0 variable into the A register
					sta GRP0						; Store the A register into the Player 1 sprite graphics
					sty PF2							; Store the Y register into the Playfield 2 controller

					ldx PFCount

KernelLoop:
					lda SpriteHeight
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
					cpx #254
					bcs SkipUp
					inx

SkipUp:		lda #%00100000	; Player 0 down
					bit SWCHA				; Test that bit
					bne SkipDn			; Branch to SkipUp label if player is not pushing the joystick down
					cpx #175
					bcc SkipDn
					dex

SkipDn:		stx YPos
					ldx XPos
					lda #%01000000	; Player 0 left
					bit SWCHA				; Test that bit
					bne SkipLt			; Branch to SkipUp label if player is not pushing the joystick left
					cpx #1
					bcc SkipLt
					dex

SkipLt:		lda #%10000000	; Player 0 right
					bit SWCHA				; Test that bit
					bne SkipJoy			; Branch to SkipUp label if player is not pushing the joystick right
					cpx #$98
					bcs SkipJoy
					inx

SkipJoy:	stx XPos
					rts

					align $100; make sure data doesn't cross page boundary

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

sprDat:		.byte #0
					.byte #0
        	.byte #%11111111
        	.byte #%10000001
        	.byte #%10111101
        	.byte #%10100101
        	.byte #%10000001
        	.byte #%10100101
        	.byte #%10000001
        	.byte #%11111111

; Sprite color data (A cyanish color pallete)
SprCol:		.byte #$a0
        	.byte #$a2
        	.byte #$a4
        	.byte #$a6
        	.byte #$a8
        	.byte #$aa
        	.byte #$ac
        	.byte #$ae

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
