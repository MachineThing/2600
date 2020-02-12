; Program name: Playfield time!
; Author: Mason Fisher
; Created: January 23rd, 2020
; Modified: Febuary 11th, 2020
; Description: A (really crappy) test of playfields

					processor 6502					; Tell DASM we are using 6502 instructions

					include "lib/vcs.asm"		; Atari 2600 library
					include "lib/macro.asm"	; 2600 macross

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

counter		equ $80

start:		CLEAN_START
NFrame:		VERTICAL_SYNC

					ldx #255
					lda #0
					ldy counter

lvscan:		sta WSYNC
					sta PF0			; First 4 bits of the playfield
					sta PF1			; Second 8 bits of the playfield
					sta PF2			; Last 8 bits of the playfield

					sta COLUBK
					sty COLUPF
					clc
					adc #1
					dex
					bne lvscan

					inc counter

					lda #66
					sta WSYNC
					sta WSYNC
					sta WSYNC
					jmp NFrame

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
