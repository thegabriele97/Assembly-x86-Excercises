CYC1    EQU 02H
CYC2    EQU 04H

        .model small
        .stack
        .data         ;VAR DECLARATIONS
        
VAR     DW ?
        
        .code
        .startup      ; CODE
        
        MOV CX, 0H    ; INIT REGISTERS
        MOV AX, 0H
        MOV BX, 1H
        
ITER:   ADD AX, 02H
        INC CX
        CMP CX, CYC1
        JNZ ITER
        
        CMP BX, CYC2
        JZ CONT
        
        MOV CX, 0H
        INC BX
        JNZ ITER

CONT:   MOV VAR, AX        
        
        .exit
        END
        