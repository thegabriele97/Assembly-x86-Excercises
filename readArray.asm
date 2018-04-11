INT_W   EQU 2
INT_R   EQU 1
MSG_S_S EQU 6
MSG_I_S EQU 7
MAX     EQU 9
Z_ASCI  EQU 030H
NL_ASCI EQU 0AH
SP_ASCI EQU 020H
CG_ASCI EQU 0DH

        .model small
        .stack
        
        .data

MSG_INS DB 'INSERT:'
MSG_SIZ DB 'SIZE: '     
ARRAY   DB MAX DUP(?)
SIZE    DB ?
NEXT_IS DW ?
TMP     DB ?
        
        .code
        .startup
        
        ;READ SIZE FROM I/0 AND FILL ARRAY
        ;PRNT MSG_SIZ
        MOV SI, 0
        MOV AH, INT_W 

W_S:    MOV DL, MSG_SIZ[SI]
        INT 21H
        INC SI
        CMP SI, MSG_S_S
        JNZ W_S
        
        ;READ SIZE VALUE
        MOV AH, INT_R
        INT 21H
        SUB AL, Z_ASCI
        MOV SIZE, AL
        
        ;CHECK IF SIZE >= MAX :> ERROR
        CMP AL, MAX
        JNS  _END
        
        ;PRINT NL
        MOV NEXT_IS, _P2
        JMP PRINTNL
        
        ;PRINT MSG_INS
_P2:    MOV SI, 0
        MOV AH, INT_W        

W_I:    MOV DL, MSG_INS[SI]
        INT 21H
        INC SI
        CMP SI, MSG_I_S
        JNZ W_I
        
        ;PRINT NL
        MOV NEXT_IS, _P3
        JMP PRINTNL       
        
        ;PREPARE REG FOR NEXT LOOP
_P3:    MOV DI, 0
        MOV CH, 0
        MOV CL, SIZE
        
        ;LOOP FOR READ VALUES
LOOP_R: MOV AH, INT_W   ;SET AH FOR WRITE
        
        MOV BX, DI      ;CP DI IN BX (16 BIT)
        ADD BL, Z_ASCI  ;ADD Z_ASCII IN BL
        MOV DL, BL      ;CP FROM BL IN DL (8 BIT)
        INT 21H         ;PRINT DL VALUE
        
        MOV DL, ')'     ;CODE FOR PRINT ") "
        INT 21H
        MOV DL, SP_ASCI
        INT 21H

        MOV AH, INT_R   ;SET AH FOR READ
        
        INT 21H         ;READ & SAVE IN ARRAY
        SUB AL, Z_ASCI
        MOV ARRAY[DI], AL
        
        MOV NEXT_IS, _P1
        JMP PRINTNL
     
_P1:    INC DI
        CMP DI, CX
        JNZ LOOP_R
        
        JMP _END        ;PROGRAM ENDED
        
        ;PRINTNL DIRECTIVE
PRINTNL:MOV TMP, AH
        MOV AH, INT_W
        MOV DL, NL_ASCI
        INT 21H
        MOV DL, CG_ASCI
        INT 21H
        MOV AH, TMP
        JMP [NEXT_IS]                

_END:  
        .exit
        END