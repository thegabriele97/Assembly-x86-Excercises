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
            
READ:   MOV CX, 0x9C4                 
     R: DEC CX          ;LOOP USED TO MAKE A CHECK EVERY 5ms
        JNZ R           ;SPECS: CPU 10Mhz
                        ;     : SINGLE INSTRUCTION 10 CLOCK
        
        CALL OPERATE
        JMP READ         
            
        .exit
        
OPERATE PROC
            
        PUSH AX
        PUSH BX
        PUSH CX
       
        IN AL, D_8255_PORTA
        MOV AH, AL
        AND AH, 0x0F
        
        IN AL, D_8255_PORTB
        AND AL, 0x0F
        ADD AH, AL
        
        JNO NO_OF
        MOV AH, 0xFF
        
NO_OF:  MOV BH, 0x80
        MOV CX, 0x8
        
CI:     MOV BL, AH
        AND BL, BH
        
        DEC CL
        SHR BL, CL
        
        MOV AL, CL
        SHL AL, 1
        OR AL, BL
        
        SHR BH, 1
        INC CL
        
        OUT D_8255_PCONF, AL
        LOOP CI            
        
        POP CX
        POP BX
        POP AX
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