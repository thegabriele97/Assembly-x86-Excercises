        .model small
        .stack
        .data
        
N_P     DB 4
K_P     DB 2
C       DW ?
        
        .code
        .startup
        
        CALL COMBINA
        JMP KILL        
        
;-------PROCEDURES-------------------------
COMBINA PROC     
        
        PUSH AX
        
        XOR BH, BH
        MOV BL, N_P
        CALL FACTORIAL
        PUSH BX             ;N! COMPUTED
        
        XOR BH, BH
        MOV BL, K_P
        CALL FACTORIAL
        PUSH BX             ;K! COMPUTED
        
        XOR BH, BH
        MOV BL, N_P
        SUB BL, K_P
        CALL FACTORIAL      ;(N-K)! COMPUTED
        
        MOV AX, BX
        POP BX
        MUL BX              ;AX: K!*(N-K)! COMPUTED
        
        MOV BX, AX
        POP AX
        DIV BX              ;AX: N!/(K!*(N-K)!) COMPUTED
        
        MOV C, AX           ;RESULT SAVED
        
        POP AX
        RET
        
COMBINA ENDP

FACTORIAL PROC
        
        CMP BX, 0x1         ;BX IS THE ONLY PARAM 
        JBE RETURN          ;NEEDED TO CALL THIS
                            ;RECURSIVE PROCEDURE
        PUSH AX
        
        MOV AX, BX          ;CURRENT N
        
        DEC BX              ;N = N-1
        CALL FACTORIAL      ;PROCEDURE ON N-1
        MUL BX              ;N = N*(N-1)
        
        MOV BX, AX
        POP AX
        
RETURN: RET        
        
FACTORIAL ENDP

;-------END OF PROCEDURES------------------

KILL:        
        .exit
        END