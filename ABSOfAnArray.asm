SIZE    EQU 7 

        .model small
        .stack
        .data
       
ARRAY   DW 1111111111111011B
        DW 1111111110110011B
        DW 0000000000000010B
        DW 1111111110111111B
        DW 0000000000011110B
        DW 1111111111111101B
        DW 0000000000110011B
               
ABS_ARR DW SIZE DUP(?)        
       
        .code
        .startup
        
        MOV CX, SIZE
        MOV SI, OFFSET ARRAY
        MOV DI, OFFSET ABS_ARR
        
LOOP_:  MOV AX, [SI]
        CMP AX, 0
        JNL NO_ABS
       
        NEG AX
        
NO_ABS: MOV [DI], AX
        
        ADD SI, 2
        ADD DI, 2
        DEC CX
        JNZ LOOP_
        
        
        .exit
        END
        