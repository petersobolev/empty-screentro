
; Empty ScreenTro by Frog - some light and music beyond the physical screen space
;
; http://frog.enlight.ru
; frog@enlight.ru
;
;

                include "vectrex.i"

;***************************************************************************
                org     0

                db      "g GCE 2015", $80 	; 'g' is copyright sign
                dw      $F600            	; music from the rom (no music)
                db      $FC, $30, 33, -$36	; height, width, rel y, rel x
	        db      "EMPTYSCREENTRO", $80	; app title, ending with $80
                db      0                 	; end of header

                lda  	#0

                inc     Vec_Music_Flag

loop:
                jsr     DP_to_C8
                ldu     #$fdd3

                jsr     Init_Music_chk          ; Initialize the music

                jsr     Wait_Recal        	; recalibrate CRT, reset beam to 0,0

                jsr     Do_Sound

		tst     Vec_Music_Flag          ; Loop if music is still playing
                beq     stopplaying

                jsr     DP_to_D0

		jsr	Intensity_7F

		ldx	#0

repeat:

; left line
                ldy     #(63*256+(-71))         ; Y,X
                jsr     drawline
;right line

                ldy     #(63*256+(81))          ; Y,X
                jsr     drawline


		leax	1,x			; inc x

		cmpx	#30			; how many times draw the same (kinda brightness) (15+1)
		bne	repeat


                bra     loop

stopplaying:
		clra
		jsr	Intensity_a		; disable beam

		bra     stopplaying

; D
drawline:

                lda     #$ff                    ; scale (max possible)
                sta     <VIA_t1_cnt_lo
                tfr     y,d
;              ldd     #(63*256+(-71))         ; Y,X
;              ldd     #(63*256+(81))          ; Y,X
                jsr     Moveto_d

                lda     [Vec_Music_Ptr]
                lsla
                lsla
                lsla
                sta     <VIA_t1_cnt_lo          ; change scale

                ldd     #(-127*256+(0))         ; Y,X
                jsr     Draw_Line_d

                jsr     Reset0Ref               ; recalibrate crt (x,y = 0)
                lda     #$CE                    ; /Blank low, /ZERO high
                sta     <VIA_cntl               ; enable beam, disable zeroing

                rts

