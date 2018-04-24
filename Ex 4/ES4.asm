DIM     EQU 8

        .model small
        .stack
        .data
         
MATRIX  DB 0,  4,  0, 0,  0,  0,  0, 60
        DB 0,  5,  0, 0, 11,  0,  0, 0
        DB 0,  5,  7, 0,  0, 10,  0, 0          
        DB 0,  0,  0, 9,  0,  0, 49, 0
        DB 0,  0, 10, 0,  0,  0,  0, 0
        DB 0, 10,  3, 9,  0,  0, 12, 0
        DB 0,  0, 58, 0,  0, 17,  0, 0
        DB 0,  1,  0, 0,  3,  0,  0, 0
        
        .code
        .startup
        
        PUSH DIM-1
        PUSH DIM-1
        PUSH DIM
        PUSH DIM
        PUSH OFFSET MATRIX
        CALL CALC_ADDRESS
        MOV DI, AX          ;FIRST PARAM OF SUM_MAX_ITEM PROC
        
        MOV BX, 0
        MOV CH, DIM
        
COUNT_I:MOV CL, DIM

COUNT_J:PUSH DI             ;1ST PARAM
        MOV AH, 0
        MOV AL, CL
        DEC AL
        PUSH AX             ;2ND PARAM 
        MOV AL, CH
        DEC AL
        PUSH AX             ;3TH PARAM 
        PUSH DIM            ;4TH PARAM
        PUSH DIM            ;5TH PARAM
        PUSH OFFSET MATRIX  ;6TH PARAM       
        CALL SUM_MAX_ITEM
        
        CMP AX, BX
        JNA CONT
        
        MOV DX, CX
        MOV BX, AX
        
CONT:   DEC CL
        JNZ COUNT_J
        
        DEC CH
        JNZ COUNT_I        
        
        JMP KILL
        
;-------PROCEDURES--------------------------------------
SUM_MAX_ITEM PROC
        
        PUSH BP            ;----------------------------
        MOV BP, SP         ;PARAMS DEFINITION
        PUSH CX            ;START_ADDRESS   :> [SP+4]
        PUSH BX            ;N_ROW           :> [SP+6]        
                           ;N_COL           :> [SP+8]
        ;PROC BODY         ;CURR_ROW        :> [SP+10]
        MOV CX, 8[BP]      ;CURR_COL        :> [SP+12]
        MOV BX, 0          ;END_OF_MATRIX   :> [SP+14]
                           ;
                           ;RET {TOTAL_SUM} :> DX
        ;NORD              ;----------------------------
NORD:   PUSH 12[BP]
        PUSH 10[BP]
        PUSH 8[BP]
        PUSH 6[BP]
        PUSH 4[BP]
        CALL CALC_ADDRESS
        
        XCHG BX, AX
        SUB BX, CX
        
        JC SOUTH
        CMP BX, 4[BP]
        JB SOUTH
        
        ADD AL, [BX]
        ADC AH, 0
        
        ;SOUTH    
SOUTH:  ADD BX, CX
        ADD BX, CX
        JC EAST  
        CMP BX, 14[BP]
        JA EAST
                
        ADD AL, [BX]
        ADC AH, 0
        
        ;EAST
EAST:   SUB BX, CX
        
        DEC BX
        JC WEST
        
        MOV CX, AX
        PUSH 0
        PUSH 10[BP]
        PUSH 8[BP]
        PUSH 6[BP]
        PUSH 4[BP]
        CALL CALC_ADDRESS
        
        CMP BX, AX
        MOV AX, CX
        JB WEST
        
        ADD AL, [BX]
        ADC AH, 0
        
        ;WEST
WEST:   INC BX
        
        ADD BX, 1        
        JC END_P
        
        MOV CX, AX
        MOV AX, 8[BP]
        DEC AX
        PUSH AX
        PUSH 10[BP]
        PUSH 8[BP]
        PUSH 6[BP]
        PUSH 4[BP]
        CALL CALC_ADDRESS
        
        CMP BX, AX
        MOV AX, CX
        JA END_P
        
        ADD AL, [BX]
        ADC AH, 0 

END_P:  POP BX
        POP CX
        POP BP
        RET 0CH                                 
                           
SUM_MAX_ITEM ENDP

CALC_ADDRESS PROC
                
        PUSH BP            ;----------------------------
        MOV BP, SP         ;PARAMS DEFINITION
                           ;START_ADDRESS   :> [SP+4]
        ;PROC BODY         ;N_ROW           :> [SP+6]        
        MOV AX, 10[BP]     ;N_COL           :> [SP+8]
        MUL 8[BP]          ;CURR_ROW        :> [SP+10]
        ADD AX, 12[BP]     ;CURR_COL        :> [SP+12]
        ADD AX, 4[BP]      ;
                           ;RET {ADDRESS}   :> AX
                           ;----------------------------
        POP BP
        RET 0AH        
                
CALC_ADDRESS ENDP
;-------END OF PROCEDURES-------------------------------        

KILL:        
        .exit       
        END