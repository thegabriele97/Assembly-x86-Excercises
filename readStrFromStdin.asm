I_R     EQU 1H
I_W     EQU 2H
I_W_STR EQU 9H
I_R_STR EQU 0AH

CR      EQU 0AH, 0DH
END_STR EQU '$'
NEWL    EQU CR, END_STR

BUFFSIZ EQU 0FFH 

        .model small
        .stack
        .data

BUFSET1 DB BUFFSIZ
BUFSET2 DB ?      
BUFFERS DB (BUFFSIZ+3) DUP(?)
NL_MEM  DB NEWL          
        
        .code
        .startup
        
        ;READ STRING FROM STDIN
        MOV DX, OFFSET BUFSET1
        MOV AH, I_R_STR
        INT 21H
        
        ;PUT AT THE END OF STRING, '$' CHAR
        MOV BX, OFFSET BUFFERS
        ADD BL, BUFSET2
        MOV [BX], NEWL
        
        ;PUT A CR IN STDOUT
        MOV AH, I_W_STR
        MOV DX, OFFSET NL_MEM
        INT 21H
        
        ;PRINT READ STRING IN STDOUT
        MOV DX, OFFSET BUFFERS
        INT 21H
        
        .exit
        END