; Tell DASM we are using 6502 instructions
					processor 6502

; Saving these libraries for later!
			;include "src/lib/vcs.asm"
			;include "src/lib/macro.asm"

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000
; "start" and "loop" are labels are they are on the left margin

start:		ldx #100		; Load 100 into X
loop:			dex					; Decrement X by one
					bne loop		; Jump to the "loop" label if X is not 0
					jmp start		; Jump to the "start" label.

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start
						.word start
