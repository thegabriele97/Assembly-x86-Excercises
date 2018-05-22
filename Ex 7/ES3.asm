        .model small
        .stack
        .data
        
ADDRESS DD 0x82C028D1, 
        DD 0x81C0276A
        
NUM     EQU ($-ADDRESS)/4
MASK    DD 0xFFFC0000        
        
        .code
        .startup
        
        push 0x82C0         ;parte alta di indirizzo di riferimento
        push 0xB685         ;parte bassa di indirizzo di riferimento
        lea AX, address
        push AX
        lea AX, mask
        push AX
        sub SP, 2           ;spazio riservato per risultato
        call FILTER
        pop AX              ;prelevamento risultato da stack
        add SP, 8
        
        JMP KILL

;-------PROCEDURES-------------------------
FILTER PROC
    
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH SI
        
        XOR CX, CX
        
        MOV BX, 6[BP]       ;MASK ADDRESS
        
        MOV AX, 10[BP]      ;SETTING UP LOW MASK WORD
        AND AX, [BX]        ;BITWISE AND WITH MASK TO LEAVE
        MOV 10[BP], AX      ;ONLY BITS THAT ARE '1' ON MASK
        
        MOV AX, 12[BP]      ;SETTING UP HIGH MASK WORD
        AND AX, 2[BX]
        MOV 12[BP], AX       
        
        MOV SI, 8[BP]       ;IP ADDRESS ARRAY

FOR_IP: MOV AX, [SI]        ;SETTING UP LOW IP WORD
        AND AX, [BX]        ;BITWISE AND WITH MASK
        CMP AX, 10[BP]      ;IF ARE NOT EQUAL, GO NEXT
        JNE GO_FOR
        
        MOV AX, 2[SI]       ;SETTING UP HIGH IP WORD
        AND AX, 2[BX]
        CMP AX, 12[BP]      ;IF ARE NOT EQUAL, GO NEXT
        JNE GO_FOR
        
        INC CX              ;COUNTER FOR RIGHT IP
                         
GO_FOR: ADD SI, 4
        CMP SI, NUM*4
        JB FOR_IP           ;GO FORWARD
        
        MOV 4[BP], CX       ;SAVING RESULT IN STACK
        
        POP SI
        POP CX
        POP BX
        POP AX
        POP BP
        RET        
    
FILTER ENDP    

;-------END OF PROCEDURES------------------

KILL:        
        .exit
        END