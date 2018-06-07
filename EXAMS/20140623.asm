        .model small
        .stack
        .data
        
str_orig db "% nella citta' dolente, % nell'eterno dolore, % tra la perduta gente"
str_sost db "per me si va"
str_new  0xFFF DUP(?)
lung_new dw ?
        
        .code
        .startup
        
        PUSH 68 ; lunghezza str_orig
        PUSH 12 ; lunghezza str_sost
        PUSH AX ; lunghezza stringa finale
        call sostituisci
        POP lung_new
        ADD SP, 4
                
        MOV DI, LUNG_NEW        
        MOV STR_NEW[DI], '$'
        MOV AH, 0x9
        MOV DX, OFFSET STR_NEW
        INT 0x21
        
        .exit
        
SOSTITUISCI PROC
    
        PUSH BP
        MOV BP, SP
        PUSH BX
        PUSH CX
        PUSH SI
        PUSH DI
        PUSH AX
        PUSH DX
        
        MOV BX, OFFSET STR_ORIG
        MOV DI, OFFSET STR_NEW
        MOV CX, 8[BP]
        XOR DX, DX
        
CI:     CMP [BX], '%'
        JNE NE
        
        PUSH CX
        MOV CX, 6[BP]
        ADD DX, CX
        XOR SI, SI
        DEC DX
        
    CI2:MOV AL, STR_SOST[SI]
        MOV [DI], AL
        
        INC SI
        INC DI
        LOOP CI2
        
        POP CX
        JMP OK
        
    NE: MOV AL, [BX]
        MOV [DI], AL
        INC DI                
          
    OK: INC BX
        INC DX
        LOOP CI
        
        MOV 4[BP], DX
        
        POP DX
        POP AX
        POP DI
        POP SI
        POP CX
        POP BX
        POP BP
        RET      
    
SOSTITUISCI ENDP            
               
        END