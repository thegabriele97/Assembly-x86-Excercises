;---------------;
;PITAGORIC TABLE;
;GENERATOR      ;
;---------------;

TABLE_N EQU 0AH                   ;<- DIMENSION

        .model small
        .stack
        .data
           
PIT_TAB DB TABLE_N*TABLE_N DUP(?) ;<- RESULT          
        
        .code
        .startup
        
        MOV DI, 0
        MOV CH, 1

FOR_I:  MOV CL, 1
        
FOR_J:  MOV AL, CH
        MUL CL
        
        MOV PIT_TAB[DI], AL
        INC DI
        
        INC CL
        CMP CL, TABLE_N
        JNA FOR_J
        
        INC CH
        CMP CH, TABLE_N
        JNA FOR_I
        
        .exit
        END