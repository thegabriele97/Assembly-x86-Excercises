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
        
        MOV DI, OFFSET VALUES
        MOV SI, OFFSET COINS
        MOV CX, LEN
        XOR BX, BX            ;CLEAR BX
        
        
COUNT:  PUSH BX               ;SAVING TOTAL SUM
        XOR BH, BH            ;CLEARING BH
        
        MOV AX, [DI]          ;AX = CURRENT VALUE
        MOV BL, [SI]          ;BL = CURRENT COIN
        
        MUL BX                ;AX = AX*BX
        JO OF_ERR             ;CHECK FOR OVERFLOW
        
        POP BX                ;RESTORING OLD TOT SUM
        ADD BX, AX            ;ADDING NEW VALUE
        
        ADD DI, 2
        INC SI
        LOOP COUNT            ;GOING FORWARD
        
        XOR DX, DX            ;CLEARING DX
        MOV AX, BX            ;AX = FINAL SUM
        MOV BX, 0x64          ;BX = 100
        DIV BX                ;AX = AX / 100; DX = AX % 100
        
        MOV EUR, AX
        MOV CENTS, DX
        
        JMP KILL              ;DONE

OF_ERR: INT 0H
        JMP KILL
        
KILL:           
        .exit
        END