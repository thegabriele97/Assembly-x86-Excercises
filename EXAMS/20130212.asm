DIM     EQU 7

        .model small
        .stack
        .data

VET     DW 3, 5, 6, 0, 9, 8, 3
RES     DD ?

        .code
        .startup
        
        LEA SI, vet
        PUSH SI
        SUB SP, 4
        CALL calcola
        POP res
        POP res[2]
        ADD SP, 2
        
        .exit

CALCOLA PROC        
        
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        
        XOR BX, BX
        MOV SI, 8[BP]
        MOV DI, SI
        ADD SI, 2
        MOV CX, (DIM-1)
        MOV WORD PTR 4[BP], 0
        MOV WORD PTR 6[BP], 0
        
    CI: MOV AX, [SI]
        ADD AX, [DI]
        
        PUSH BX
        XOR DX, DX
        MOV BX, 2
        DIV BX
        POP BX
        
        ADD WORD PTR 4[BP], AX
        ADC WORD PTR 6[BP], 0
        ADD BX, DX
        
        ADD SI, 2
        ADD DI, 2
        LOOP CI
        
        SHR BX, 1
        ADD WORD PTR 4[BP], BX
        ADC WORD PTR 6[BP], 0
        
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        POP BP
        RET            
        
CALCOLA ENDP
        
        END