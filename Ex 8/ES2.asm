LUNG    EQU 6

        .model small
        .stack
        .data
        
anni    dw 1945, 2008, 1800, 2006, 1748, 1600
ris     db LUNG DUP (?)        
        
        .code
        .startup
        
        MOV SI, OFFSET ANNI
        MOV DI, OFFSET RIS
        MOV BX, LUNG
        CALL BISESTILE 
        
        JMP KILL
        
;-------PROCEDURES-------------------------------
BISESTILE PROC
    
        PUSH AX
        PUSH DX
        PUSH CX
        PUSH BX
        
        MOV [DI], 0
        MOV CX, BX
        
CI:     MOV AX, [SI]
        MOV BX, 0x64
        
        XOR DX, DX
        DIV BX
        CMP DX, 0x0
        JNZ NO_SEC
        
        XOR DX, DX
        MOV BX, 0x190
        MOV AX, [SI]
        DIV BX
        CMP DX, 0x0
        JNZ NO_SEC
        
        MOV [DI], 1
        JMP NEXT
        
NO_SEC: XOR DX, DX
        MOV AX, [SI]
        MOV BX, 0x4
        DIV BX
        CMP DX, 0x0
        JNZ NEXT
        
        MOV [DI], 1
        JMP NEXT

NEXT:   ADD SI, 2
        ADD DI, 1
        LOOP CI
        
        POP BX
        POP CX
        POP DX
        POP AX
        RET     
                
    
BISESTILE ENDP
;-------END OF PROCEDURES------------------------

KILL:  
        .exit
        END