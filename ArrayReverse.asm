DIM     EQU 5

        .model small
        .stack
        .data
        .code
        
ARRAY   DB ?, ?, ?, ?, ?
CP_A    DB ?, ?, ?, ?, ? 
        
        .startup
        
        MOV AX, 'a'
        MOV DI, 0
        MOV CX, DIM
        
FILL:   MOV ARRAY[DI], AL
        ADD AL, 1
        INC DI
        DEC CL
        CMP CL, 0
        JNZ FILL
        
        MOV SI, 0
        MOV DI, DIM-1
        
CP_IS:  MOV AL, ARRAY[DI]
        MOV CP_A[SI], AL
        INC SI
        DEC DI
        CMP DI, 0
        JNZ CP_IS        
        
        .exit
        END