INT_READ  EQU 1H
INT_W_STR EQU 9H

CR        EQU 0DH
NL        EQU 0AH, CR    

        .model small
        .stack
        .data
        
VAR     DW ?
MSG_OF  DB NL, "KERNEL PANIC111!1!11! OVERFLOW.", 024H        
        
        .code
        .startup
        
        MOV CX, 0AH
        MOV BX, 0
        
        ;READING NUMBER
READ:   MOV AH, INT_READ
        INT 21H
        
        CMP AL, CR          ;CHECKING IF CR WAS PRESSED
        JE EXIT
        
        AND AL, 0FH         ;CONVERT FROM ASCII TO INT
        PUSH AX             ;PUSH READ VALUE
        MOV AX, BX          ;;MOV OLD VALUE(BX) IN AX
                            ;;AND MULTIPLY IT BY 10DEC 
        
        MUL CX
        JO ERR_N            ;CHECKING IF THERE IS OVERFLOW
        
        POP BX              ;RESTORING READ VALUE IN BX
        MOV BH, 0           ;RESETTING HIGH BYTE BCS USELESS
        ADD BX, AX          ;BX += AX (NEW VALUE = CURRENT)
        
        JMP READ            ;GOING TO READ NEXT DIGIT

ERR_N:  ;OVERFLOW
        MOV AH, INT_W_STR
        MOV DX, OFFSET MSG_OF
        INT 21H
        JMP KILL
        
EXIT:   MOV VAR, BX
        JMP KILL
        
KILL:
        .exit
        END
        