INT_W_STR EQU 9H

        .model small
        .stack
        .data
        
COE_A   DW 2
COE_B   DW 6
COE_C   DW 4

MSG_1   DB 'NO REAL SOLUTION', 024H
MSG_2   DB 'HAS ONE OR TWO REAL SOLUTION', 024H        
        
        .code
        .startup
        
        MOV AX, COE_B       ;COMPUTING 
        MOV BX, AX          ;SQUARE OF COE_B
        MUL BX
        MOV CX, AX          ;SAVING IT IN CX
        
        MOV AX, COE_A       ;COMPUTING 
        MOV BX, COE_C       ;COE_A*COE_B
        MUL BX
        
        SHL AX, 2           ;MUL IT BY 4
        SUB CX, AX          ;CX -= AX
        JS NO_SOL           ;IF IS <0 ->NO REAL SOLUTION
        
        MOV DX, OFFSET MSG_2
        JMP END_
        
NO_SOL: MOV DX, OFFSET MSG_1                        
        
END_:   MOV AH, INT_W_STR   ;PRINT MSG
        INT 21H
        
        .exit
        END