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
NFrame:   lda #2
          sta VBLANK
          sta VSYNC

          sta WSYNC

          lda #0
          sta VSYNC

          ldx #37       ; 37 scanlines

LVBlank:  sta WSYNC
          dex
          bne LVBlank

          lda #0
          sta VBLANK

          ldx #210      ; 210 scanlines (To fully cover the screen, overflows into overscan)
          ldy BGColor
LVScan:   sty COLUBK
          sta WSYNC
          iny
          dex
          bne LVScan

          lda #2
          sta LVBlank
          ldx #30
LVOver:   sta WSYNC
          dex
          bne LVOver

          dec BGColor
          jmp NFrame

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
