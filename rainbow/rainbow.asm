; Program name: Rainbows
; Author: Mason Fisher
; Created: January 22nd, 2020
; Modified: January 22nd, 2020

; Tell DASM we are using 6502 instructions
					processor 6502

					include "lib/vcs.asm"
					include "lib/macro.asm"

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000



; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
