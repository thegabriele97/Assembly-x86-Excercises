INT_W   EQU 2H

DIM     EQU 4        
        
        .model small
        .stack
        .data
        
MAT     DW  6, 1,  1, 3
        DW  1, 7,  2, 4
        DW  1, 2, 19, 5       
        DW  3, 4,  5, 2 
        .code
        .startup
        
        MOV AH, INT_W
        
        PUSH DIM
        PUSH OFFSET MAT
        CALL CHECK_DIAGONAL
        
        CMP AL, 0
        JE SYMM
        
        MOV DL, '2'
        JMP PRINT
         
SYMM:   PUSH DIM
        PUSH OFFSET MAT
        CALL CHECK_SYMMETRIC        
        
        MOV DL, AL
        OR DL, 30H
        JMP PRINT
        
PRINT:  INT 21H       
        JMP KILL

;-------PROCEDURES-------------------------
CHECK_SYMMETRIC PROC
    
        PUSH BP         ;-------------------
        MOV BP, SP      ;PARAMS DEFINITION
        PUSH BX         ;ADDRESS    :>[SP+4]
        PUSH CX         ;SQUARE_DIM :>[SP+6]
        PUSH SI         ;
                        ;RESULT{0,1}:>AL
        MOV BX, 4[BP]   ;-------------------
        MOV CX, 6[BP]
        MOV SI, CX      ;SI IS USED TO STORE ORIGINAL
        INC SI          ;LEN OF MATRIX +1.. IS EQUAL TO 
        SHL SI, 1       ;6[BP] BUT THERE'S TO COMPUTE
                        ;EACH TIME 6[BP]x2 SO.. IS BETTER TO STORE IT
X_DIAG: PUSH 6[BP]      
        PUSH CX
        PUSH BX
        
        CALL ROW_COL_EQ
        CMP AL, 0       ;IF AL IS 0, THIS MATRIX ISN'T SYMM!
        JZ END_P2
        
        ADD BX, SI      ;GOING FORWARD TO NEXT ITEM ON DIAG
        DEC CX
        CMP CX, 1
        JA X_DIAG       ;LOOP  

END_P2: POP SI          ;AL IS SETTED BY ROW_COL_EQ PROC
        POP CX
        POP BX
        POP BP
        
        RET 4
    
CHECK_SYMMETRIC ENDP

ROW_COL_EQ PROC
        
        PUSH BP        ;-------------------
        MOV BP, SP     ;PARAMS DEFINITION
        PUSH CX        ;CORNER     :>[SP+4]
        PUSH BX        ;LEN        :>[SP+6]
        PUSH SI        ;DIST_ROWCOL:>[SP+8]
        PUSH DI        ;
        PUSH AX        ;RESULT{0,1}:>AL
                       ;-------------------
        
        ;PROC BODY
        MOV BX, 4[BP]  ;BX IS THE CORNER OF ROW-COL
        MOV CX, 6[BP]  ;CX CONTAINS LEN OF ROW-COL
        MOV AX, 8[BP]  ;AX IS THE DISTANCE BETWEEN
                       ;Mth ITEM ON A ROW AND Mth ITEM
                       ;ON COL, HAVING BX AS CORNER
                       ;THIS IS EQUAL TO THE RIGHT
                       ;DIM OF THE SQUARE MATRIX 
        
        MOV SI, BX     ;SI WILL BE USED TO PARSE COLUMN
        ADD BX, 2      ;THIS ALGORYTHM STARTS FROM THE RIGHT
        SHL AX, 1      ;THE MATRIX IS A DWORD SO.. x2
        DEC CX
        
FOR_:   ADD SI, AX     ;ADDRESSING TO CURRENT ITEM ON COL
        MOV DI, [SI]   ;DI = RAM[SI]
        
        CMP [BX], DI   ;BX IS PARSING THE ROW
        JNE NOT_EQ
        
        ADD BX, 2      ;GOING TO NEXT ITEM ON ROW
        LOOP FOR_      ;LOOP
        
        JMP OK
        
NOT_EQ: POP AX         ;RESTORING ORIGINAL AH
        MOV AL, 0
        JMP END_P3

OK:     POP AX         ;RESTORING ORIGINAL AH
        MOV AL, 1
      
END_P3: POP DI
        POP SI
        POP BX
        POP CX
        POP BP
        
        RET 6        
        
ROW_COL_EQ ENDP

CHECK_DIAGONAL PROC    
                       ;-------------------
        PUSH BP        ;PARAMS DEFINITION
        MOV BP, SP     ;ADDRESS    :>[SP+4]
        PUSH BX        ;SQUARE_DIM :>[SP+6]
        PUSH CX        ;
        PUSH SI        ;RESULT{0,1}:>AL
                       ;-------------------
        ;PROC BODY     
        MOV BX, 4[BP]  ;CURRENT ITEM ON DIAGONAL
        MOV CH, 6[BP]  ;COUNT FOR MAIN ITERATIONS
        DEC CH         ;IF IS A NxN MATRIX, THERE'S
                       ;NEED FOR N-1 ITERATIONS
        
MAIN_:  MOV SI, 0          ;THE IDEA IS..
        MOV CL, 6[BP]      ;IF THE MATRIX IS LIKE THIS
        ADD BX, 2          ;1xx
                           ;x1y
CHECK_: CMP [BX][SI], 0    ;yy1
        JNZ NO_DIAG        ;FOR EACH ITEM ON DIAG, 
                           ;THE ITER STARTS FROM THE RIGHT
        ADD SI, 2          ;AND CHECK THAT EACH ITEM
        DEC CL             ;IS EQUAL TO 0.. N TIMES.
        JNZ CHECK_         ;EVERY x AND y NEEDS TO BE 0
        
        ADD BX, SI
        DEC CH
        JNZ MAIN_
        
        MOV AL, 1
        JMP END_P
                        
NO_DIAG:MOV AL, 0
        
        ;PROC ENDS
END_P:  POP SI
        POP CX
        POP BX
        POP BP
        
        RET 4 
  
CHECK_DIAGONAL ENDP        
;-------END OF PROCEDURES------------------
KILL:        
        .exit
        END