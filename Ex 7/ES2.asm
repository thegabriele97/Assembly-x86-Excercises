CR      EQU 0xD

        .model small
        .stack
        .data
        
INS_MSG DB "INSERT: "
LEN1    EQU $-INS_MSG

ERR_MSG DB 0xA, CR, "ERROR: UNABLE TO READ."
LEN2    EQU $-ERR_MSG

EVEN_   DB 0xA, CR, "EVEN"
LEN3    EQU $-EVEN_    
   
NOT_EVE DB 0xA, CR, "NOT EVEN"
LEN4    EQU $-NOT_EVE        
        
        .code
        .startup
        
        MOV AX, OFFSET INS_MSG
        MOV BX, LEN1
        CALL PRINTF
        
        CALL SCANF
        
        TEST AX, 0x1
        JZ EV
        
        MOV AX, OFFSET NOT_EVE
        MOV BX, LEN4
        JMP PRINT
        
EV:     MOV AX, OFFSET EVEN_
        MOV BX, LEN3
        
PRINT:  CALL PRINTF        
        
        JMP KILL

;-------PROCEDURES--------------------
SCANF   PROC
        
        PUSH BX
        PUSH CX
        
        MOV AH, 0x1
        MOV CX, 0xA
        XOR BX, BX
        
CI:     INT 0x21        
        
        CMP AL, 0x30
        JB RETURN
        CMP AL, 0x39
        JA RETURN
        
        AND AL, 0x0F
        
        XCHG AX, BX
        MUL CX
        
        ADD AL, BL
        ADC AH, 0
        XCHG AX, BX
        JMP CI      
        
RETURN: CMP AL, CR
        JE OK
        
        MOV AX, OFFSET ERR_MSG
        MOV BX, LEN2
        CALL PRINTF
        JMP KILL

OK:     MOV AX, BX

        POP CX
        POP BX
        RET
        
SCANF   ENDP
        
PRINTF  PROC
    
        PUSH AX
        PUSH BX
        PUSH CX
        
        MOV CX, BX
        MOV BX, AX
        
        MOV AH, 0x2
        
FOR:    MOV DL, [BX]
        INT 0x21
        
        INC BX
        LOOP FOR
        
        POP CX
        POP BX
        POP AX
        RET        

PRINTF  ENDP         
;-------END OF PROCEDURES--------------

KILL:        
        .exit
        END