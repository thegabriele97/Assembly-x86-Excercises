LEN     EQU 14H

        .model small
        .stack
        .data
        
FIB     DW 2 DUP(1), LEN-2 DUP(?)   
        
        .code
        .startup
        
        MOV BX, OFFSET FIB+4
        MOV AX, FIB+2
        MOV CX, LEN-2
                           ;AX CONTAINS LAST FIB, SO FIB[N-1]
NEXTFIB:ADD AX, -4[BX]     ;AX += FIB[N-2]
        MOV [BX], AX       ;FIB[N] = AX
        ADD BX, 2          
        LOOP NEXTFIB       ;GOING TO COMPUTE NEXT > FIB[++N]    
        
        .exit
        END