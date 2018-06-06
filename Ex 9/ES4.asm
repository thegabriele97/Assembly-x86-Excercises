
        #START=8259.EXE#
        
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
        
S:      IN AL, D_8255_PORTA
        MOV AH, AL
        IN AL, D_8255_PORTB
        
        XOR AL, AH
        NOT AL
        MOV AH, AL
        
        MOV BH, 0x80
        MOV CX, 0x08
                
CI:     MOV BL, AH
        AND BL, BH
        DEC CL
        SHR BL, CL
        
        MOV DL, CL
        SHL DL, 1
        OR DL, BL
        MOV AL, DL
        
        OUT D_8255_PCONF, AL
        
        SHR BH, 1
        INC CL
        LOOP CI
        
        MOV CX, 0x08
RESET:  MOV AL, CL
        SHL AL, 1
        OUT D_8255_PCONF, AL
        LOOP RESET        
        
        JMP S                

        .exit           
              
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