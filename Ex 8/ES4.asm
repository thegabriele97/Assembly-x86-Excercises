        .model small
        .stack
        .data
        
RISULT  DD ?        
        
        .code
        .startup
        
        PUSH 4 ; base
        PUSH 12 ; esponente
        SUB SP, 4
        CALL potenza
        POP AX
        POP DX
        ADD SP, 4
        mov risult, AX
        mov risult+2, DX
        
        JMP KILL
        
;-------PROCEDURES------------------------
POTENZA PROC                                          
        
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        XOR DX, DX
        MOV AX, 0x1
        MOV CX, 8[BP]
        
CI:     MOV BX, DX
        MUL WORD PTR 10[BP]
        PUSH DX
        PUSH AX
        
        MOV AX, BX
        MUL WORD PTR 10[BP]
        JO OF
        
        MOV DX, AX
        XOR AX, AX
        
        POP AX
        POP BX
        ADD DX, BX
      
        LOOP CI
        JMP RETURN
        
OF:     MOV AX, 0xFFFF
        MOV DX, 0xFFFF

RETURN: MOV 4[BP], AX
        MOV 6[BP], DX
       
        POP DX
        POP CX
        POP BX
        POP AX
        POP BP        
        RET
                                                  
POTENZA ENDP                                          
;-------END OF PROCEDURES-----------------
KILL:        
        .exit
        END 