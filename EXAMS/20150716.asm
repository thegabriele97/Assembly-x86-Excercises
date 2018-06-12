DIM     EQU 9

        .model small
        .stack
        .data
        
MATRICE DB 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 1, 1, 0, 0, 0
        DB 0, 0, 0, 0, 1, 1, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 1, 1, 1, 1, 0, 0, 0
        DB 0, 0, 1, 1, 1, 0, 0, 0, 0
        DB 0, 0, 1, 1, 1, 0, 0, 0, 0
        DB 0, 0, 0, 0, 1, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0
        
        .code
        .startup
        
        MOV AX, 8 ; indice dell'elemento corrente
        LEA BX, matrice
        inizioCiclo:
        CALL cercaQuadrato
        CMP DX, 1
        JE fineCiclo
        INC AX
        CMP AX, DIM * DIM
        JL inizioCiclo
        fineCiclo:
        
        .exit
        
CERCAQUADRATO PROC        
        
        PUSH CX
        PUSH SI
        
        MOV CX, BX
        ADD CX, DIM
        MOV SI, BX
        ADD SI, AX
        CMP SI, CX
        JB NO
        
        MOV CX, BX
        ADD CX, DIM*DIM
        SUB CX, (DIM+1)
        CMP SI, CX
        JA NO
        
        PUSH AX
        MOV CX, DIM
        XOR DX, DX
        DIV CX
        POP AX
        CMP DX, 0x0
        JE NO
        CMP DX, (DIM-1)
        JE NO
        
        MOV SI, BX
        ADD SI, AX
        SUB SI, DIM
        CMP [SI], 0x0
        JZ NO
        DEC SI
        CMP [SI], 0x0
        JZ NO
        ADD SI, 2
        CMP  [SI], 0x0
        JZ NO
        
        MOV SI, BX
        ADD SI, AX
        DEC SI
        CMP [SI], 0x0
        JZ NO
        ADD SI, 2
        CMP [SI], 0x0
        JZ NO
        DEC SI
        ADD SI, DIM
        DEC SI
        MOV CX, 0x3
CI:     CMP [SI], 0x0
        JZ NO
        INC SI
        LOOP CI
        
        MOV DX, 0x1
        JMP FI
NO:     XOR DX, DX

FI:     POP SI
        POP CX
        RET                
        
CERCAQUADRATO ENDP

        END