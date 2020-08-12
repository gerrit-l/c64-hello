; C64 Hello World program
; author Gerrit Ludwig
;
; build with Clifford Carnmo's C64-DevKit
; https://github.com/cliffordcarnmo/c64-devkit
; (compiles with the ACME cross assembler)
; many thanks go to Joern Kierstein
; https://www.retro-programming.de @RetroProgram


;*** Variables
CHAROUT = $ffd2         ;KERNAL routine for printing ctrl chars
CLRSCR  = $93           ;Clear Screen CHR$(147)
SCREENMID = $05ed       ;somewhere in the middle of the screen
COLORMID  = $d9ed       ;corresponding screen color address

;*** Startaddress for BASIC
*=$0801
        !byte $0c,$08,$e2,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00

;*** Start of assembly program
        lda #$17          ;switch to
        sta $d018         ;2nd Charset
        lda #CLRSCR
        jsr CHAROUT

;*** printing Hello World!
        ldy #$00
        ldx #$00
loop
        lda helloWorld,x  ;getting the chars
        sta SCREENMID,x
        inx
        cpx #$0c          ;counter
        bne loop

;*** paint it black
        ldx #$00
        lda #$00          ;black
colorLoop
        sta COLORMID,x
        inx
        cpx #$0c
        bne colorLoop

;*** turn it to yello        
        ldx #$00
        lda #$07          ;yello
yelloLoop
        sta COLORMID,x

;*** delay the coloring
        ldy #$00
        sty $a2           ;timer address, increases 1 with every clock cycle
wait    ldy $a2
        cpy #$10          ;about .25s  (50Hz)
        bne wait
      
        inx
        cpx #$0c
        bne yelloLoop        

        rts

helloWorld    ;in C64 char ROM
        !byte $48,$05,$0c,$0c,$0f,$20,$57,$0f,$12,$0c,$04,$21
