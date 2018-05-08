
INT_RD  EQU 0x1

        .model small
        .stack
        .data
        
OPA     DW 2045
OPB     DW 0x5
RES     DW ?
SWITCH  DW SUM, SUBS, MULT, DIVIT
        
        .code
        .startup
        
        MOV AH, INT_RD
        INT 0x21            ;READ OPTION
        AND AL, 0x0F        ;CONVERTI ASCII->INT
        
        MOV DI, AX          ;SAVE IT IN DI
        AND DI, 0x00FF      ;CLEAR HIGH BYTE
        MOV AX, OPA         ;AX = OPA
        
        DEC DI              ;INDEX STARTS FROM 0!
        SHL DI, 1           ;DW ARRAY SO.. x2
        JMP SWITCH[DI]      ;SWITCH ON DI
        
;-------SWITCH ON DI---------------        
SUM:    ADD AX, OPB
        JMP BREAK        

SUBS:   SUB AX, OPB
        JMP BREAK
        
MULT:   MUL OPB    
        JO OF
        JMP BREAK
        
DIVIT:  XOR DX, DX
        DIV OPB
        JMP BREAK        
;-------END OF SWITCH--------------
        
BREAK:  MOV RES, AX
        JMP KILL

OF:     INT 0x0      

KILL:        
        .exit
        END
       