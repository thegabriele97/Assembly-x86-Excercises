;NO SENSE PROGRAM

        .model small
        .stack
        .data
        
ARRAY1  DB 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x1E
ARRAY2  DB 0x1A, 0x1B, 0x1C, 0x2, 0x3, 0x4, 0x5, 0x6
LEN     EQU $-ARRAY2
         
ARRAY3  DB LEN DUP(?)        
        .code
        .startup
        
        MOV CX, LEN
        XOR SI, SI
        XOR BX, BX
        MOV DI, OFFSET ARRAY3
        
MAKE:   MOV AL, ARRAY1[SI]
        AND AL, ARRAY2[SI]          
        
        MOV [DI], AL
        JNP NO_PF
        INC BX
        
NO_PF:  INC SI
        INC DI
        LOOP MAKE
         
        .exit
        END