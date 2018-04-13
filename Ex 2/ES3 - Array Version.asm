          ;USEFUL CONSTS
INT_READ  EQU 1
INT_WRITE EQU 2
INT_W_STR EQU 9H
CR        EQU 0DH
NL        EQU 0AH, CR
ENDSTR    EQU 024H

          ;PROGRAM-PURPOSE CONSTS
LEN       EQU 0101B

        .model small
        .stack
        .data
        
ARRAY   DW LEN DUP(?)
MSG_OF  DB NL, "ASDRUBALE IS COMING WITH AN OVERFLOW.", ENDSTR        
        
        .code
        .startup
        
        MOV CX, 0AH
        MOV DI, 0
        
FILL:   ;STARTING TO FILL ARRAY
        MOV BX, 0         ;BX IS USED TO STORE THE
                          ;VALUE WHILE IT'S IN PROCESSING
        
READ:   MOV AH, INT_READ  
        INT 21H           ;READ NEW VALUE
        
        CMP AL, CR
        JE STOP           ;IF IS 'CR', GOTO STOP
        
        AND AL, 0FH       ;CONVERT FROM ASCII TO INT
        PUSH AX           ;PUSHING IT IN THE STACK
        
        MOV AX, BX        ;AX=BX
        MUL CX            ;AX*= CX
        JO ERR            ;CHECK FOR OVERFLOW
        
        POP BX            ;RESTORING READ VALUE
        MOV BH, 0         ;CLEAR HIGH BYTE BCS USELESS
        ADD BX, AX        ;BX+= AX
        JC ERR            ;CHECK FOR OVERFLOW
        
        JMP READ          ;GOTO READ NEXT VALUE

STOP:   ;VALUE READ CORRECTLY: 
        ;SAVING IT IN ARRAY
        ;AND GO TO READ NEXT NUMBER
        
        ;BUT FIRST, LET'S PRINT A NEW LINE!
        ;---------------------------------
        MOV AH, INT_WRITE       ;(')('); ;
        MOV DL, 0AH             ;;;;;;;; ;
        INT 21H                   ;;;;   ;
        ;---------------------------------
        
        MOV ARRAY[DI], BX
        ADD DI, 2
        
        CMP DI, LEN*2     ;CHECK IF ARRAY IS FULL
        JNE FILL          ;IF N :> GOTO READ NEXT VALUE
        JMP ENDED         ;IF Y :> GOTO END PROGRAM
                

ERR:    ;OVERFLOW
        MOV AH, INT_W_STR
        MOV DX, OFFSET MSG_OF
        INT 21H
        JMP KILL
        
ENDED:  ;PROGRAM ENDED CORRECTLY
        ;NOTHING TO DO: KILL IT
        JMP KILL

KILL:      
        .exit
        END