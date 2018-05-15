        .model small
        .stack
        .data

ARRAY1  DW 0x1, 0x2, 0x3, 0x4, 0x5
ARRAY2  DW 0x6, 0x7, 0x8, 0x9, 0xA        
LEN     EQU ($-ARRAY2)/2

ARRAY3  DW LEN DUP(?)
        
        .code
        .startup

        CALL AVG
        JMP KILL

;-------PROCEDURES-----------------------
AVG PROC
    
        PUSH AX
        PUSH CX
        PUSH DI
        PUSH SI
        
        MOV DI, OFFSET ARRAY3
        MOV CX, LEN                  
                  
        XOR SI, SI
        XOR AX, AX
        
SUM:    MOV AX, ARRAY1[SI]
        ADD AX, ARRAY2[SI]
        
        SHR AX, 1
        MOV [DI], AX
        
        ADD SI, 2
        ADD DI, 2
        LOOP SUM
        
        POP SI
        POP DI
        POP CX
        POP AX
        RET        
        
AVG ENDP
;-------END OF PROCEDURES----------------        
                
KILL:        
        .exit
        END