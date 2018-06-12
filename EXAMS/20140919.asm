        
        #start=8255.exe#
        
        .model small
        .stack
        .data
        .code
        .startup
        
        MOV AL, 0x80
        OUT 0x83, AL
        
        MOV AL, 'c'
        XOR AH, AH
        PUSH AX
        CALL SENDCODE
        ADD SP, 2
        
        .exit

SENDCODE PROC
         
         PUSH BP
         MOV BP, SP
         PUSH AX
         PUSH BX
         PUSH CX
         PUSH DX
         
         MOV AH, 4[BP]
         MOV CX, 0x8
         MOV BH, 0x80
         
         MOV AL, 0xF
         OUT 0x83, AL
         MOV AL, 0xD
         OUT 0x83, AL
         MOV AL, 0xC
         OUT 0x83, AL
         
CI:      MOV BL, AH
         
         DEC CX
         AND BL, BH
         SHR BL, CL
         MOV AL, 0x7
         SHL AL, 1
         OR AL, BL
         
         OUT 0x83, AL
         MOV AL, 0xD
         OUT 0x83, AL
         MOV AL, 0xC
         OUT 0x83, AL         
         
         SHR BH, 1
         
         INC CX
         LOOP CI
         
         ADD BH, 0x0
         NOT BH
         
         JP Y
         MOV AL, 0x0
         JMP O
    Y:   MOV AL, 0x1
    
         OUT 0x83, AL
         MOV AL, 0xD
         OUT 0x83, AL
         MOV AL, 0xC
         OUT 0x83, AL 
    
    O:   POP DX
         POP CX
         POP BX
         POP AX
         POP BP
         RET         
    
SENDCODE ENDP            
         
         END