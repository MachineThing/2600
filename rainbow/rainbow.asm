; Program name: Rainbows
; Author: Mason Fisher
; Created: January 22nd, 2020
; Modified: January 22nd, 2020

          processor 6502					; Tell DASM we are using 6502 instructions

          include "lib/vcs.asm"		; Atari 2600 library
          include "lib/macro.asm"	; 2600 macross

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000

BGColor   equ $81       ; A equate that holds a background color we will use later

start:    CLEAN_START   ; A macro that clears memory and TIA (Television Interface Adaptor)

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
