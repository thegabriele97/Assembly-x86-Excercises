LEN     EQU 7

        .model small
        .stack
        .data
        
ARRAY   DW 423, 3191, 23, 11, -412, 3, 9        
        
        .code
        .startup
        
        MOV SI, 0
        MOV DI, 2*(LEN-1)
        MOV CX, LEN/2

CYCLE:  MOV AX, ARRAY[SI]
        MOV BX, ARRAY[DI]
        
        MOV ARRAY[SI], BX
        MOV ARRAY[DI], AX
        
        ADD SI, 2
        SUB DI, 2
        DEC CX
        CMP CX, 0
        JNZ CYCLE  
        
        .exit
        END