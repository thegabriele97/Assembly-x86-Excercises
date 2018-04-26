INT_W_STR EQU 0x9

        .model small
        .stack
        .data
        
COE_A   DW 35
COE_B   DW -6
COE_C   DW -42

MSG_1   DB 'NO REAL SOLUTION', 024H
MSG_2   DB 'HAS ONE OR TWO REAL SOLUTION', 024H        
        
        .code
        .startup
        
        MOV AX, COE_A
        IMUL AX             ;COE_A*COE_A
        JO OF_ERR
        
        MOV BX, AX          ;STORING COE_A*COE_A
        
        MOV AX, COE_B
        IMUL COE_C          ;COE_B*COE_C
        JO OF_ERR
        
        SAL AX, 1           ;MUL BY 2
        JO OF_ERR           ;CHECK FOR OF
        SAL AX, 1           ;MUL BY 2
        JO OF_ERR           ;CHECK FOR OF
        
        SUB BX, AX
        JS NO_SOL
         
        MOV DX, OFFSET MSG_2
        JMP PRINT
        
NO_SOL: MOV DX, OFFSET MSG_1        
        
PRINT:  MOV AH, INT_W_STR
        INT 0x21
        JMP KILL      
        
OF_ERR: INT 0H

KILL:        
        .exit
        END