        .model small
        .stack
        .data
        
STR     DB "sasso rosso"
LEN     EQU $-STR        

NL      DB 0xA, 0xD, 'ASD$'        
        
        .code
        .startup
        
        MOV CX, 'z'             ;CREATING AN ARRAY
                                
MALLOC: PUSH 0x0
        LOOP MALLOC
        
        MOV BP, SP              ;START OF NEW ARRAY                
        

        XOR AH, AH
        MOV CX, LEN
        MOV SI, OFFSET STR
        
CI:     MOV AL, [SI]
        MOV DI, AX
        
        SHL DI, 1
        INC WORD PTR [BP][DI]
        INC SI
        LOOP CI
        
        
        XOR DI, DI
        MOV CX, 'z'
        MOV AH, 2
        
PRINT:  MOV DX, [BP][DI]
        
        CMP DL, 0x0
        JZ NO_PR
        
        MOV DX, DI
        SHR DX, 1
        INT 0x21
        
        PUSH CX
        MOV DL, '*'
        MOV CX, [BP][DI]

ASTER:  INT 0x21
        LOOP ASTER
        
        POP CX
        
        MOV DL, 0xA
        INT 0x21
        MOV DL, 0xD
        INT 0x21       
        
NO_PR:  ADD DI, 2                         
        DEC CX
        CMP CX, 0
        JNZ PRINT
        
        ADD SP, 'z'
        
        .exit
        END