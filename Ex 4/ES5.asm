        .model small
        .stack
        .data
        
VAR     DW 1024
SQRT    DW ?        
        
        .code
        .startup
        
        MOV BX, 0       ;SQUARE ROOT
        MOV CX, 1       ;COUNT OF NOT EVEN NUMBERS
        MOV AX, VAR     ;NUMBER TO COMPUTE
        DEC AX
        
COMPUTE:INC BX          ;SQRT++
        ADD CX, 2       ;NOT_EVEN+=2
        SUB AX, CX      ;NUM-=NOT_EVEN
        JNC COMPUTE     ;THE ONLY WAY TO CHECK IF
                        ;A NUMBER IS < 0 WITHOUT A 
                        ;CA2 NUMBER IS LOOKING AT CARRY FLAG
        
        MOV SQRT, BX
        
        .exit
        END