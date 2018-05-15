        .model small
        .stack
        .data
        
MAT     DW  2,  1, -3
        DW  0,  1,  1
        DW  4,  3,  5      

        .code
        .startup
        
        XOR CX, CX
        XOR BX, BX
        
DET:    PUSH OFFSET MAT[6]
        PUSH CX
        SUB SP, 2             ;USED TO STORE RESULT
        
        CALL DET_2        
        
        POP AX
        MOV SI, CX
        SHL SI, 1
        IMUL MAT[SI]
        
        CMP CX, 0x1           ;IF WE ARE IN MID COL
        JNE NOT_MIN           ;THERE IS NEED TO MULTIPLY
                              ;2x2 DET BY -1 AS LAPLACE
        PUSH BX               ;ASLGORYTHM SAYS
        MOV BX, 0xFFFF
        IMUL BX
        POP BX
        
NOT_MIN:ADD BX, AX
        INC CX
        ADD SP, 0x4
        
        CMP CX, 0x3
        JNE DET
        
        JMP KILL          
        
;-------PROCEDURES------------------------
DET_2 PROC
     
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH SI
        
        MOV BX, 8[BP]
        SHL 6[BP], 1
        
        XOR SI, SI
        XOR CX, CX
        
FILL:   CMP SI, 6[BP]       ;THIS LOOP WILL PUSH
        JNE CONT            ;ON THE STACK THE MATRIX ITEMS
                            ;USED TO COMPUTE A 2X2 DET
        ADD SI, 2           ;
        JMP FILL            ;IS PROGRAMMED TO SKIP ELEMENTS
                            ;ON SAME COL, USING LAPLACE ALGORYTHM
CONT:   PUSH [BX][SI]
        ADD SI, 2
        
        CMP SI, 6
        JNE CONT2
        
        ADD BX, SI
        XOR SI, SI
        
CONT2:  INC CX
        CMP CX, 0x4
        JNE FILL
        
        PUSH BP
        MOV BP, SP
        
        MOV AX, 8[BP]       ;COMPUTE A*D
        IMUL WORD PTR 2[BP]
        MOV BX, AX
        
        MOV AX, 4[BP]       ;COMPUTE B*C
        IMUL WORD PTR 6[BP]
        
        XCHG AX, BX
        SUB AX, BX          ;SUB
        
        POP BP
        MOV 4[BP], AX
        
        ADD SP, 0x8         ;RESTORING STACK
        POP SI
        POP CX
        POP BX
        POP AX
        POP BP
        RET        
        
DET_2 ENDP
;-------END OF PROCEDURES-----------------        
                        
KILL:        
        .exit
        END