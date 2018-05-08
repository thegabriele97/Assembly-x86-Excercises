INT_RD  EQU 0x1
INT_W_S EQU 0x9

        .model small
        .stack
        .data

NL      DB 0xA, 0xD, 0x24
        
OPA     DB ?
OPB     DB ?
OPC     DB ?        
        
        .code
        .startup
        
        MOV DI, OFFSET OPA
        
READ_OP:MOV CX, 0x8          ;N OF BIT TO READ
        MOV AH, INT_RD
        XOR BL, BL           ;CLEAR BL

READ:   INT 0x21
        AND AL, 0x0F         ;CONVERT ASCII TO INT
        
        SHL BX, 1            ;SHIFT BL TO LEFT
        OR BL, AL            ;THIS OR WORKS ONLY ON FIRST BIT
                             ;BCS USER CAN ENTER ONLY 1 OR 0, IT'S A BIT
        LOOP READ            ;CONTINUE TO READ
        
        MOV AH, INT_W_S
        MOV DX, OFFSET NL
        INT 0x21             ;PRINT NL
        
        MOV [DI], BL         ;STORE BL
        
        INC DI
        CMP DI, OFFSET OPB
        JNA READ_OP          ;READ NEXT OP
        
        MOV AL, OPB          ;FUNCTION IS:
        NOT AL               ;OPC = NOT(A & (NOT B)) OR (A XOR B)
        AND AL, OPA
        NOT AL
        
        MOV AH, OPA
        XOR AH, OPB
        
        OR AH, AL
        MOV OPC, AH          ;STORE RESULT
        
        .exit
        END