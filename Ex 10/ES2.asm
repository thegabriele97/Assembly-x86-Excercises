        #START=8255.EXE#
        
        ;GLOBAL ADDRESS CONSTS
        D_8255_PORTA EQU 0x80
        
        ;DERIVED ADRESS CONTS
        D_8255_PORTB EQU D_8255_PORTA+1
        D_8255_PORTC EQU D_8255_PORTA+2
        D_8255_PCONF EQU D_8255_PORTA+3
        
        ;DEVICES CONFIGS
        D_8255_MAIN  EQU 0x92   
        
        .model small
        .stack
        .data
        
        .code
        .startup
        
        CALL INIT_8255
        MOV AX, 0xFFFF
        
DO:     CALL OPERATE
        JMP DO 
            
        .exit
        
OPERATE PROC
            
        PUSH BX
        PUSH CX
        
CI:     IN AL, D_8255_PORTA
        
        CMP AL, 0x37
        JA IT
        CMP AL, 0x30
        JB IT
        
        AND AL, 0x0F
        
        CMP AL, AH
        JE CI
        
        MOV AH, AL
        MOV CL, AH
        
        IN AL, D_8255_PORTC
        NOT AL
        MOV BH, 0x1
        
        XOR CH, CH
        SHL BH, CL
        
        AND AL, BH
        SHR AL, CL
        
        MOV BH, AH
        SHL BH, 1
        OR AL, BH
        
        OUT D_8255_PCONF, AL
        
IT:     POP CX
        POP BX
        RET    
            
OPERATE ENDP

;-------INIT SYSTEM-----------------------
INIT_8255 PROC
    
        PUSH AX
        
        ;8255 PORTA MODE1: INPUT
        ;8255 PORTB MODE1: OUTPUT                                                                                          
    
        MOV AL, D_8255_MAIN
        OUT D_8255_PCONF, AL
        
        POP AX
        RET
    
INIT_8255 ENDP
;-------INIT SYSTEM-----------------------  
        END