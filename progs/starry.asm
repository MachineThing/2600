; Program name: Starry Night
; Author: Mason Fisher
; Created: January 17th, 2020
; Modified: January 18th, 2020

; Tell DASM we are using 6502 instructions
					processor 6502

			include "progs/lib/vcs.asm"
			include "progs/lib/macro.asm"

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

start:		sei						; Disable interrupts
					cld						; Disable BCD math mode
					ldx #$ff			; Set X to $FF
					txs						; Transfer the X regoster to the stack pointer

					ldx #$ff			; Set X to $FF
					lda #$00			; Set A to $FF
zeroZP		sta COLUBK		; Set the color of the background to black
					dex						; Decrement X by one
					bne zeroZP		; Jump to the "zeroZP" label unless X is zero

					lda #$0e			; Set A to $0e
					sta COLUBK		; Set the color of the background to white
					lda #$00
					sta COLUBK		; Set the color of the background to black

					jmp start

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
