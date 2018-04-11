INT_R   EQU 1
INT_W   EQU 2
OFFS    EQU 'a' - 'A'
LEN     EQU 3

        .model small
        .stack
        .data
        
VAR1    DB 'a'
VAR2    DB 's'
VAR3    DB 'm'
        
        .code
        .startup
        
        MOV SI, 0       ;SETTING UP INITIAL REGS
        MOV AH, INT_W
      
CYCLE:  MOV AL, VAR1[SI];COMPUTING OFFSET
        SUB AL, OFFS
        
        MOV DL, AL      ;MOVING IN DL AND PRINT
        INT 21H
        
        INC SI          ;GOING FORWARD WITH CYCLE
        CMP SI, LEN 
        JNZ CYCLE             
        
        .exit
        END