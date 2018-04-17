;----------------------------------:
;THIS PROGRAM COMPUTE A PRODUCT    ;
;BETWEEN TWO ARRAYS OF SAME LENGTH ;
;AND COPY RESULT IN A NxN MATRIX   ;
;-----------------------------------

        .model small
        .stack
        .data

MSG_OF  DB "OVERFLOW!", 024H
                             ;---------------------;
X_A     DW 4, 5, 6           ;<- FIRST ARRAY       ;
Y_A     DW 2, 3, 4           ;<- SECOND ARRAY      ;
                             ;                     ;
LEN     EQU ($-Y_A)/2        ;THE TWO ARRAYS NEED  ;
                             ;TO BE OF SAME LENGTH ;
RES_TAB DW LEN*4 DUP(?)      ;---------------------;        
        
        .code
        .startup
        
        MOV SI, OFFSET Y_A
        MOV BX, OFFSET RES_TAB
        
        MOV CH, LEN       ;COUNTER FOR Y_A
        
FOR_I:  MOV CL, LEN       ;COUNTER FOR X_A
        MOV DI, OFFSET X_A 

FOR_J:  MOV AX, [DI]      ;AX = X_A[J]
        MUL WORD PTR [SI] ;AX*= Y_A[I]
        JO ERR_OF         ;CHECK FOR OF
        
        MOV [BX], AX      ;RES_TAB[I,J] = AX
        
        ADD BX, 2
        ADD DI, 2         ;LET'S GO FORWARD WITH X_A
        
        DEC CL
        JNZ FOR_J         ;CONTINUE WITH FOR_J
        
        ADD SI, 2         ;LET'S GO FORWARD WITH Y_A
        DEC CH
        JNZ FOR_I         ;CONTINUE WITH FOR_I
        
        JMP KILL          ;PROGRAM ENDED
        
ERR_OF: ;OVERFLOW
        MOV DX, OFFSET MSG_OF
        MOV AH, 9H
        INT 21H        
        JMP KILL
        
KILL:   ;KILL PROGRAM     
        .exit
        END