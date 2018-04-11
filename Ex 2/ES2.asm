        .model small
        .stack
        .data
        
VALUE   DW 12345        
        
        .code
        .startup
        
        MOV CX, 0AH
        MOV AX, VALUE
        MOV BX, SP    ;SAVING CURRENT SP
        
        ;COMPUTING DIGITS AND
        ;PUSHING THEM IN THE STACK
DIV_IT: MOV DX, 0
        DIV CX
        
        PUSH DX
        
        CMP AX, 0
        JA DIV_IT
        
        
        ;PRINT NUMBER
        MOV CX, BX    ;USING SP DIFF TO COMPUTE
        SUB CX, SP    ;NUMBER OF DIGITS PUSHED:
        SHR CX, 1     ;I DIVIDE IT BY 2 BCS SP IS 
                      ;INCREASED BY 2 FOR EACH PUSH
        
PRINT:  POP AX
        MOV DL, AL
        OR DL, 30H                      
        
        MOV AH, 2
        INT 21H
        
        LOOP PRINT                      
        
        .exit
        END