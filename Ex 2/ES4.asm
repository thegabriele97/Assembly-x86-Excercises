        ;GLOBAL CONSTS
VALUE_OF EQU 0FFFFH

        ;USEFUL CONSTS
MPH      EQU 3CH         ; := 60   DEC
MPD      EQU 18H*MPH     ; := 1440 DEC

        ;PROGRAM
        .model small
        .stack
        .data
        
DAYS    DB 40
HOURS   DB 17
MINS    DB 34
RESULT  DW ?        
        
        .code
        .startup
        
        MOV BL, MINS
        MOV BH, 0
        
        ;COMPUTING MINUTES PER 'DAY'
        MOV CX, MPD
        MOV AL, DAYS
        MOV AH, 0
        MUL CX
        JO ERR_OF
        
        ADD BX, AX
        JC ERR_OF
        
        ;COMPUTING MINUTES PER 'HOURS'
        MOV CX, MPH
        MOV AL, HOURS
        MOV AH, 0
        MUL CX
        JO ERR_OF
        
        ADD BX, AX
        JC ERR_OF
        
        MOV RESULT, BX 
        JMP KILL
        
ERR_OF: ;OVERFLOW
        MOV RESULT, VALUE_OF
        JMP KILL        

KILL:   ;END OF PROGRAM     
        .exit
        END