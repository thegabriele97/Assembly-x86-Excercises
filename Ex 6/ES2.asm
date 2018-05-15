        .model small
        .stack
        .data
        
STR     DB "HELLO, HOW THE HELL ARE YOU?"
LEN     EQU $-STR
        
        .code
        .startup
        
        MOV AX, OFFSET STR
        MOV BX, LEN
        
        CALL PRINTF
        JMP KILL
        
;-------PROCEDURES-----------------------------
PRINTF  PROC
    
        PUSH AX
        PUSH BX
        PUSH CX
        
        MOV CX, BX
        MOV BX, AX
        
        MOV AH, 0x2
        
FOR:    MOV DL, [SI]
        INT 0x21
        
        INC SI
        LOOP FOR
        
        POP CX
        POP BX
        POP AX
        RET        

PRINTF  ENDP     
;-------END OF PROCEDURES----------------------
        
KILL:        
        .exit
        END