; Program name: Rainbows
; Author: Mason Fisher
; Created: January 22nd, 2020
; Modified: January 22nd, 2020

          processor 6502					; Tell DASM we are using 6502 instructions

          include "lib/vcs.asm"		; Atari 2600 library
          include "lib/macro.asm"	; 2600 macross

; 4 kilobyte Atari 2600 cartridges start at f000
					org $f000

BGColor   equ $81       ; Store this value into RAM. We will use this value later, the name gives out a hint

start:    CLEAN_START   ; A macro that clears memory and TIA (Television Interface Adaptor)
NFrame:   lda #2
          sta VBLANK    ; Turn on Vertical Blank
          sta VSYNC     ; Turn on Vertical Sync

          sta WSYNC     ; Turn on Wait for SYNC

          lda #0
          sta VSYNC     ; Turn off Vertical Sync

          ldx #37       ; 37 scanlines

LVBlank:  sta WSYNC
          dex
          bne LVBlank

          lda #0
          sta VBLANK    ; Turn off Vertical Blank

          ldx #210      ; 210 scanlines (To fully cover the screen, overflows into overscan)
          ldy BGColor   ; Store $81 into the Y register
LVScan:   sty COLUBK    ; Make the background the color of the Y register
          sta WSYNC     ; Turn off Wait for SYNC
          iny           ; Increment Y
          dex           ; Decrement X
          bne LVScan    ; Jump to LVScan if X is not equal to 0

          dec BGColor   ; Decrement the Background Color Value
          jmp NFrame    ; Jump to new frame

; Skip to address FFFC in the ROM, which is the end of a 4K cartridge
					org $fffc
						.word start	; Set reset vector to $fffc
						.word start	; interrupt vector at $fffe (Unused on the 2600)
