        .model small
        .stack
        .data
        
STRINGA               DB "NOTTE ROSSA"
LEN                   EQU $-STRINGA
DIMENSIONE            DW LEN
DIMENSIONE_AGGIORNATA DW ?
        
        .code
        .startup  
        
        lea ax, stringa
        push ax
        mov ax, DIMENSIONE
        push ax
        sub sp, 2
        call converti
        pop ax
        mov DIMENSIONE_AGGIORNATA, ax
        add sp, 4
        
        JMP KILL

;-------PROCEDURES-----------------------------
CONVERTI PROC
        
        PUSH BP
        MOV BP, SP 
        PUSH CX
        PUSH SI
        PUSH DI
        PUSH BX
        PUSH AX
        
        MOV CX, 6[BP]
        DEC CX
        
        MOV SI, 8[BP]
        INC SI
        MOV DI, SI
        DEC DI
        
        XOR AX, AX
        XOR BH, BH
        
CI:     MOV BL, [DI]
        CMP [SI], BL
        JE NEXT
        
        PUSH BX
        INC AX
        JMP NEXT
        
NEXT:   INC SI
        INC DI
        LOOP CI
        
        MOV 4[BP], AX
         
        XOR BH, BH
        MOV BL, [DI]
        PUSH BX
        MOV CX, AX
        INC CX
        
        MOV DI, 8[BP]
        MOV BP, SP
        SHL AX, 1
        ADD BP, AX
        ADD SP, AX
        ADD SP, 2
        
CI2:    MOV AL, [BP]
        MOV [DI], AL
        INC DI
        SUB BP, 2
        LOOP CI2
        
        POP AX
        POP BX
        POP DI
        POP SI
        POP CX
        POP BP
        RET                 
        
CONVERTI ENDP
;-------END OF PROCEDURES----------------------

KILL:        
        .exit
        END