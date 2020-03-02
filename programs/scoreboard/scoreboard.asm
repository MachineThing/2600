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

NFrame:		VERTICAL_SYNC
					TIMER_SETUP 37
					lda Score0
					ldx #0
					jsr GetBitmap
					lda Score1
					ldx #5
					jsr GetBitmap
					TIMER_WAIT
					TIMER_SETUP 192

					lda #%00010010	; Score mode with a 2 pixel ball
					sta CTRLPF
					lda #$26
					sta COLUP0
					lda #$84
					sta COLUP1

					ldy #0

ScanLoop:	sta WSYNC
					tya
					lsr
					tax
					lda FontBuf+0,x
					sta PF1
					SLEEP 28
					lda FontBuf+5,x
					sta PF1
					iny
					cpy #10
					bcc ScanLoop

; Clear the playfield

					lda #0
					sta WSYNC
					sta PF1

					lda #%00010100
					sta CTRLPF

					TIMER_WAIT
					TIMER_SETUP 29
					TIMER_WAIT
					jmp NFrame

GetBitmap:pha
					and #$0f
					sta Temp
					asl
					asl
					adc Temp
					tay
					lda #5
					sta Temp

loop1:		lda DigitsBitmap,y
					and #$0f
					sta FontBuf,x
					iny
					inx
					dec Temp
					bne loop1

					pla
					lsr
					lsr
					lsr
					lsr
					sta Temp
					asl
					asl
					adc Temp
					tay
					dex
					dex
					dex
					dex
					dex
					lda #5
					sta Temp

loop2:		lda DigitsBitmap,y
					and #$f0
					ora FontBuf,x
					sta FontBuf,x
					iny
					inx
					dec Temp
					bne loop2
					rts

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
