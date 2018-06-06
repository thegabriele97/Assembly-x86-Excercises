
        #START=8259.EXE#
        
        ;GLOBAL ADDRESS CONSTS
        D_8255_PORTA EQU 0x80
        D_8259_0     EQU 0x40
        
        ;DERIVED ADRESS CONTS
        D_8255_PORTB EQU D_8255_PORTA+1
        D_8255_PORTC EQU D_8255_PORTA+2
        D_8255_PCONF EQU D_8255_PORTA+3
        D_8259_1     EQU D_8259_0+1
        
        ;DEVICES CONFIGS
        D_8255_MAIN  EQU 0xBC   ;8255 PORTA&B MODE1, A-IN, B-OUT
        D_8255_INTEA EQU 0x09   ;8255 INTERRUPT ENABLE PORT_A
        D_8255_INTEB EQU 0x05   ;8255 INTERRUPT ENABLE PORT_B 
        
        D_8259_ICW1  EQU 0x13   ;LTIM=0, SNGL=1, ICW4=1 
        D_8259_ICW2  EQU 0x20   ;BASE ADDRESS FOR INTR: 0xF8
        D_8259_ICW4  EQU 0x03   ;AEOI=1, MPC=I8086
        D_8259_MASK  EQU 0x6F   ;8259 ENABLED FOR CH7 AND CH4
        
        ;SYSTEM CONFIGS
        IVT_B_ADDR   EQU D_8259_ICW2
        
        .model small
        .stack
        .data
        
COUNT   DB ?        
        
        .code
        .startup
        
        CALL INIT_8255
        CALL INIT_8259
        CALL IVT_SETUP
        
CI:     JMP CI        
        
        .exit
        
;-------INTERRUPT SERVICE ROUTINES--------
D_8259_PA_IN PROC
    
        PUSH AX
        
        IN AL, D_8255_PORTA
        AND AL, 0x0F 
         
        CMP AL, 1
        JB NO
        CMP AL, 9
        JA NO
        
        OUT D_8255_PORTB, AL
        DEC AL
        MOV COUNT, AL 
        
NO:     POP AX
        IRET
    
D_8259_PA_IN ENDP

D_8259_PB_OUT PROC
        
        PUSH AX
        
        CMP COUNT, 0
        JE FINE   
        
        MOV AL, COUNT
        OUT D_8255_PORTB, AL
        DEC COUNT

FINE:   POP AX      
        IRET
    
D_8259_PB_OUT ENDP
;-------INTERRUPT SERVICE ROUTINES--------        
        
;-------INIT SYSTEM-----------------------
INIT_8255 PROC
    
        PUSH AX
        
        ;8255 PORTA MODE1: INPUT
        ;8255 PORTB MODE1: OUTPUT
        MOV AL, D_8255_MAIN
        OUT D_8255_PCONF, AL
        
        ;SET INTERRUPT REQUEST PORTA
        MOV AL, D_8255_INTEA
        OUT D_8255_PCONF, AL
        
        ;SET INTERRUPT REQUEST PORTB
        MOV AL, D_8255_INTEB
        OUT D_8255_PCONF, AL
        
        POP AX
        RET
    
INIT_8255 ENDP

INIT_8259 PROC
    
        PUSH AX
        
        ;ICW1
        MOV AL, D_8259_ICW1
        OUT D_8259_0, AL
        
        ;ICW2
        MOV AL, D_8259_ICW2
        OUT D_8259_1, AL
        
        ;ICW4
        MOV AL, D_8259_ICW4
        OUT D_8259_1, AL
        
        ;OCW1
        MOV AL, D_8259_MASK
        OUT D_8259_1, AL 
        
        POP AX
        RET
    
INIT_8259 ENDP

IVT_SETUP PROC
        
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DS
        
        XOR AX, AX
        MOV DS, AX
        
        MOV BX, 00100111b ; channel 4 (36)
        MOV CL, 2
        SHL BX, CL
        MOV AX, offset D_8259_PA_IN
        MOV DS:[BX], AX
        MOV AX, seg D_8259_PA_IN
        MOV DS:[BX+2], AX
        
        MOV BX, 00100100b ; channel 4 (36)
        MOV CL, 2
        SHL BX, CL
        MOV AX, offset D_8259_PB_OUT
        MOV DS:[BX], AX
        MOV AX, seg D_8259_PB_OUT
        MOV DS:[BX+2], AX
        
        POP DS
        POP CX
        POP BX
        POP AX
        RET

IVT_SETUP ENDP
;-------INIT SYSTEM-----------------------        

        END