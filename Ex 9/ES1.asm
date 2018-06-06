
        #START=8259.EXE#
        
        ;GLOBAL ADDRESS CONSTS
        D_8255_PORTA EQU 0x80
        
        ;DERIVED ADRESS CONTS
        D_8255_PORTB EQU D_8255_PORTA+1
        D_8255_PORTC EQU D_8255_PORTA+2
        D_8255_PCONF EQU D_8255_PORTA+3
        
        ;DEVICES CONFIGS
        D_8255_MAIN  EQU 0x89   ;8255 PORTA&B&C MODE0, A-B OUT, C IN
        
        .model small
        .stack
        .data

LETTURA DB ?
        
        .code
        .startup
        
        CALL INIT_8255
        
        MOV AL, 'A'
        OUT D_8255_PORTA, AL
        MOV AL, 'K'
        OUT D_8255_PORTB, AL
        
        IN AL, D_8255_PORTC
        MOV LETTURA, AL        
        
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