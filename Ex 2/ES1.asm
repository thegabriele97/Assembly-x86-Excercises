        .model small
        .stack
        .data
        
ARRAY   DB 250, 250, 250, 250, 22, 255, 255        
LEN     EQU $-ARRAY
RESULT  DW ?, ?
        
        .code
        .startup
        
        MOV BH, 0
        MOV AX, 0
        MOV CX, LEN
        MOV SI, OFFSET ARRAY
        
SUM:    MOV BL, [SI]
        ADD AX, BX
        INC SI
        LOOP SUM
        
        MOV DX, 0
        MOV CX, LEN
        DIV CX
        
        MOV RESULT, AX
        MOV RESULT+2, DX        
        
        .exit
        END