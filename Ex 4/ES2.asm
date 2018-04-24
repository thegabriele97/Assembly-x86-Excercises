        .model small
        .stack
        .data

EUR     DW ?
CENTS   DW ?
VALUES  DW 1, 2, 5, 10, 20, 50, 100, 200
COINS   DB 100, 23, 17, 0, 79, 48, 170, 211
LEN     EQU $-COINS        
        
        .code
        .startup
        
        MOV BX, 0
        MOV SI, 0
        MOV DI, 0
        
LOOP_:  MOV AX, VALUES[SI]  ;COMPUTING TOTAL SUM
        MUL COINS[DI]       ;SUM += COINS[I]*VALUES[I]
        ADD BX, AX
                
        ADD SI, 2
        INC DI
        
        CMP DI, LEN
        JNE LOOP_           ;CONTINUE WITH LOOP_
        
        MOV DX, 0
        MOV AX, BX          ;DIV RESULT BY 100DEC
        MOV BX, 064H        
        DIV BX
        
        MOV EUR, AX         ;SAVING RESULT
        MOV CENTS, DX
        
        .exit
        END