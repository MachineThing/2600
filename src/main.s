
; Assembler should use basic 6502 instructions
	processor 6502

; 4 kilobyte Atari 2600 cartridges start at f000
  org $f000
  lda $17
