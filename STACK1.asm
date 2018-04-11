INT_R    EQU 1H
INT_W    EQU 2H 
INT_STR  EQU 9H
NL       EQU 0AH, 0DH
EOF      EQU 24H
NLEOF    EQU NL, EOF

        .model small
        .stack
        .data
        
MSG1    DB 'WELCOME', NLEOF
MSG2    DB '# ', EOF
MSG3    DB ' -> PUSHING..', NLEOF
MSG4    DB 'YOU INSERTED ', EOF
MSG4_   DB ' CHARACTERS', NLEOF        
        
        .code
        .startup
        
        MOV AH, INT_STR
        MOV BH, 0
        MOV CX, 0
        
        MOV DX, OFFSET MSG1
        INT 21H
        
READ:   MOV DX, OFFSET MSG2
        INT 21H
        
        MOV AH, INT_R
        INT 21H
        MOV BL, AL
        
        MOV AH, INT_STR
        MOV DX, OFFSET MSG3
        INT 21H
        
        CMP BL, '.'
        JZ DONE
        
        PUSH BX
        INC CX
        JMP READ
        
DONE:   MOV DX, OFFSET MSG4
        INT 21H
        
        MOV AH, INT_W
        MOV DL, CL
        ADD DL, '0'
        INT 21H
        MOV AH, INT_STR
        MOV DX, OFFSET MSG4_
        INT 21H     
        
        MOV AH, INT_W
                
PRINT:  POP DX
        INT 21H
        
        DEC CX
        CMP CX, 0
        JNZ PRINT
                
        .exit
        END
       