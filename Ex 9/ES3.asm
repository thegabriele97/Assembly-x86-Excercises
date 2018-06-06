
        #START=8259.EXE#
        
        ;GLOBAL ADDRESS CONSTS
        D_8255_PORTA EQU 0x80
        
        ;DERIVED ADRESS CONTS
        D_8255_PORTB EQU D_8255_PORTA+1
        D_8255_PORTC EQU D_8255_PORTA+2
        D_8255_PCONF EQU D_8255_PORTA+3
        
        ;DEVICES CONFIGS
        D_8255_MAIN  EQU 0x91   
        
        .model small
        .stack
        .data

LETTURA DB ?
        
        .code
        .startup
        
        CALL INIT_8255
        
CI:     IN AL, D_8255_PORTC
        CMP AL, 1
        JNE CI
        
        IN AL, D_8255_PORTA
        CALL CONV
        OUT D_8255_PORTB, AL
        JMP CI               
        
        .exit     
              
CONV PROC
        
        CMP AL, 'a'
        JB NIENTE
        CMP AL, 'z'
        JA NIENTE
        
        ADD AL, 'A' - 'a'
        
NIENTE: RET        
    
CONV ENDP              
              
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