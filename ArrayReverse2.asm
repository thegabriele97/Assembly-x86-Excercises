INT_R   EQU 1
INT_W   EQU 2
SIZE    EQU 5

        .model small
        .stack
        .data
       
ARRAY   DB 1, 2, 3, 4, 5, 0        
        
        .code
        .startup
           
        MOV DI, 0
        MOV SI, SIZE
        DEC SI
        
LOO:    MOV AH, ARRAY[SI]
        MOV AL, ARRAY[DI]
        
        MOV ARRAY[SI], AL
        MOV ARRAY[DI], AH
        
        DEC SI
        INC DI
        CMP DI, SI
        JNAE LOO            ;CONTINUE UNLESS DI<=SI
              
        .exit
        END