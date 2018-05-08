DIM    EQU 0x6

        .model small
        .stack
        .data
        
ARRAY   DW 2, 3, 4, 5, 6, 7
RESULT  DB DIM DUP (0)        
        
        .code
        .startup
        
        MOV CX, DIM        
        MOV SI, OFFSET ARRAY
        MOV DI, OFFSET RESULT        
        
CHECK:  MOV BX, 0x2
        
        MOV AX, [SI]
        SHR AX, 1
        PUSH AX
        MOV BP, SP
        
CH_PRIM:MOV AX, [SI]        ;for (i = 2; i < number/2; i++)
        XOR DX, DX          ;if (number %% i == 0) return false;
        DIV BX              ;PSEUDO CODE FOR THIS ALGORYTHM
        
        CMP DX, 0
        JZ NO_PRIM
        
        CMP BX, [BP]
        
        INC BX
        JNA CH_PRIM                
        
        MOV [DI], 1         ;IS PRIME
        JMP CONT
        
NO_PRIM:CMP [SI], 2
        JNZ N
        
        MOV [DI], 1         ;IS EQUAL TO 2, SO IT'S PRIME
        JMP CONT
        
N:      MOV [DI], 0         ;ISN'T PRIME

CONT:   INC DI
        ADD SI, 2
        SUB SP, 2
        LOOP CHECK
                
        .exit
        END