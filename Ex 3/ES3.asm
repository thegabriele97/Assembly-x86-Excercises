COL     EQU 5
ROW     EQU 3        
        
        .model small
        .stack
        .data
        
        ;  [A]  [B]   [C]  [D]  [E][F] \ 
TAB     DW 154, 123,  109, 86,   4, ?; 0
        DW 412, -23, -231,  9,  50, ?; 1
        DW 123, -24,   12, 55, -45, ?; 2
RES_ROW DW   ?,   ?,    ?,  ?,   ?, ?; 3        

TAB_SZ  EQU $-TAB        
        .code
        .startup
        
        MOV CX, COL
        MOV DI, OFFSET RES_ROW
        
RESET:  MOV [DI], 0           ;SET 0 TO LAST ROW  
        ADD DI, 2
        LOOP RESET        
        
        MOV CX, ROW+1         ;COUNTER FOR ON_ROW LOOP
        MOV BX, 0             ;CURRENT ROW
        
ON_ROW: PUSH BX               ;PUSHING PARAMS
        PUSH OFFSET RES_ROW   ;PROC CALLS
        PUSH COL
        CALL SUM_ROW          ;COMPUTE SUM OF CURR ROW
                             
        ADD BX, COL*2+2       ;STEP FORWARD TO NEXT ROW 
        LOOP ON_ROW           ;CONTINUE TO ON_ROW
        
        JMP KILL              ;KILL PROGRAM
        
;-------PROCEDURES-----------------------------
SUM_ROW PROC
        
        ;PRELIMINARY PROC SETUP
        PUSH BP             ;------------------
        MOV BP, SP          ;PARAMS DEFINITION;
        PUSH CX             ;LEN     :>[SP+4];;
        PUSH DI             ;ADDRESS :>[SP+8];;
        PUSH SI             ;LAST_ROW:>[SP+6];;
        PUSH BX             ;.-.-.-.-.-.-.-.-.-
        PUSH AX             ;------------------
                            
        ;PROCEDURE BODY       
        MOV CX, 4[BP]
        MOV SI, 8[BP]
        MOV DI, 6[BP]
        MOV AX, 0
        
SUM:    MOV BX, [SI]
        ADD AX, BX
        ADD [DI], BX
        
        ADD DI, 2
        ADD SI, 2
        LOOP SUM
        
        MOV [SI], AX        ;MOV SUM IN CURRENT_ROW->[F]
        ADD [DI], AX        ;ADD SUM IN ROW_#3->[F]
        
        ;END OF PROC
        POP AX              ;RESTORING REGS
        POP BX              
        POP SI
        POP DI
        POP CX
        ADD SP, 2           ;RESTORING STACK
        
        RET 6       
                            
SUM_ROW ENDP
;-------END OF PROCEDURES----------------------

KILL:   ;KILL PROGRAM
             
        .exit
        END