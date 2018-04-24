DIM     EQU 8

        .model small
        .stack
        .data
     
MATRIX  DB 0,  4,  0, 0,  0,  0,  0, 60
        DB 0,  5,  0, 0, 11,  0,  0,  0
        DB 0,  5,  7, 0,  0, 10,  0,  0          
        DB 0,  0,  0, 9,  0,  0, 49,  0
        DB 0,  0, 10, 0,  0,  0,  0,  0
        DB 0, 10,  3, 9,  0,  0, 12,  0
        DB 0,  0, 58, 0,  0, 17,  0,  0
        DB 0,  1,  0, 0,  3,  0,  0,  0

MSG_END DB 'X=', ?
ONE_P   EQU $-MSG_END-1
        DB ' Y=', ?, 024H
TWO_P   EQU $-MSG_END-2
        
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
        
        ;PRINTING FINAL RESULT
        OR DX, 3030H
        
        MOV AH, 9H
        MOV MSG_END[ONE_P], DL
        MOV MSG_END[TWO_P], DH
        MOV DX, OFFSET MSG_END
        INT 21H
        
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
        ;NORTH             ;----------------------------
NORTH:  PUSH 12[BP]
        PUSH 10[BP]
        PUSH 8[BP]
        PUSH 6[BP]
        PUSH 4[BP]         
        CALL CALC_ADDRESS  ;COMPUTING ADDRESS
        
        XCHG BX, AX        ;AX=0(OLD BX=0); BX=ACTUAL ADDRESS
        SUB BX, CX         ;ADDRESSING TO PREV ITEM ON COL
        
        JC SOUTH           ;CHECKING FOR OVERFLOW
        CMP BX, 4[BP]      ;CHECKING LOWER BOUND OF THE MATRIX
        JB SOUTH           ;IF IS OUT OF BOUNDS, GOTO SOUTH
        
        ADD AL, [BX]       ;ADDING TO TOTAL SUM
        ADC AH, 0          ;ADD CARRY IF NEEDED TO HIGH BYTE
        
        ;SOUTH    
SOUTH:  ADD BX, CX         ;RESTORE ACTUAL ADDRESS
        ADD BX, CX         ;ADDRESSING TO NEXT ITEM ON COL
        JC EAST            ;CHECKING FOR OVERFLOW
        CMP BX, 14[BP]     ;CHECKING UPPER BOUND OF THE MATRIX
        JA EAST            ;IF IS OUT OF BOUNDS, GOTO EAST
                
        ADD AL, [BX]       ;USUAL ADDING
        ADC AH, 0
        
        ;EAST
EAST:   SUB BX, CX         ;RESTORE ACTUAL ADDRESS
        
        DEC BX             ;ADDRESSING TO THE LEFT ITEM
        JC WEST            ;CHECKING FOR OVERFLOW
        
        MOV CX, AX         ;SAVING ACTUAL SUM(AX) IN CX
        MOV AX, BX         ;STARTING FROM CURRENT ADDRESS
        SUB AX, 12[BP]     ;COMPUTING ADDRESS OF FIRST COL OF THIS ROW
        
        CMP BX, AX         ;CHECKING FOR BOUNDS ON CURR ROW
        XCHG AX, CX        ;RESTORING ACTUAL SUM FROM CX AND SAVING AX FOR LATER
        JB WEST            ;IF IS OUT OF BOUNDS, GOTO WEST
        
        ADD AL, [BX]       ;USUAL ADDING
        ADC AH, 0
        
        ;WEST
WEST:   INC BX             ;RESTORING ACTUAL ADDRESS
        
        ADD BX, 1          ;ADDRESSING TO THE RIGHT ITEM
        JC END_P           ;CHECKING FOR OVERFLOW
        
        XCHG CX, AX        ;SAVING ACTUAL SUM; RESTORING ADDRESS OF FIRST ITEM OF THIS ROW
        ADD AX, 8[BP]      ;COMPUTING ADDRESS OF FIRST ITEM OF NEXT ROW
        CMP BX, AX         ;CHECKING FOR BOUNDS
        MOV AX, CX
        JAE END_P          ;IF IS OUT OF BOUNDS, GOTO END_P
                           
        ADD AL, [BX]       ;USUAL ADDING
        ADC AH, 0 

END_P:  POP BX             ;RESTORING REGS
        POP CX
        POP BP
        RET 0CH            ;RESTORING STACK                     
                           
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