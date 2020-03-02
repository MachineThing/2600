; Program name: Scoreboard
; Author: Mason Fisher
; Created: March 2nd, 2020
; Modified: March 2nd, 2020
; Description: A scoreboard, pretty much in almost every Atari 2600 game out there

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross
					include "lib/xmacro.asm"; 2600 macros or the setHorizPos routine

SpriteHeight	equ #5

					seg.u Variables
					org $80

Score0		.byte					; score of player 0
Score1		.byte					; score of player 1
FontBuf		.ds 10				; 2x5 array of playfield bytes
Temp			.byte

					seg Code
					org $f000

start:		CLEAN_START
					lda #$17
					sta Score0
					lda #$56
					sta Score1
					jmp start
					
					org $FF00

; Bitmap pattern for digits
DigitsBitmap ;;{w:8,h:5,count:10,brev:1};;
					.byte $EE,$AA,$AA,$AA,$EE
					.byte $22,$22,$22,$22,$22
					.byte $EE,$22,$EE,$88,$EE
					.byte $EE,$22,$66,$22,$EE
					.byte $AA,$AA,$EE,$22,$22
					.byte $EE,$88,$EE,$22,$EE
					.byte $EE,$88,$EE,$AA,$EE
					.byte $EE,$22,$22,$22,$22
					.byte $EE,$AA,$EE,$AA,$EE
					.byte $EE,$AA,$EE,$22,$EE

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
