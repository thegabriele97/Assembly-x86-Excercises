ROW     EQU 5
COL     EQU 4

        .model small
        .stack
        .data

SRC     DW ROW*COL DUP(?)
DEST    DW ROW*COL DUP(?)
ARRAY1  DW ROW DUP(?)
ARRAY2  DW COL DUP(?)     
        
        .code
        .startup

        MOV AX, 0
        MOV BX, 0
        MOV DI, 0
        
FILL:   MOV SRC[BX][DI], AX
        ADD AX, 1
        ADD DI, 2
        
        CMP DI, COL*2
        JNZ NO_RESE
        
        ;RESET
        ADD BX, DI
        MOV DI, 0

NO_RESE:CMP BX, ROW*COL*2
        JNZ FILL
        
        ;COPYING 2ND ROW IN ARRAY2
        MOV BX, 2*COL*2
        MOV SI, 0
        MOV DI, 2*(COL-1)
        
CP_ROW: MOV AX, SRC[BX][SI]
        MOV ARRAY2[DI], AX
        
        ADD SI, 2
        SUB DI, 2
        
        CMP SI, COL*2
        JNZ CP_ROW
       
        ;COPYING 3TH COL IN ARRAY1
        MOV SI, 3*(2)
        MOV BX, 0     
        MOV DI, 2*(ROW-1)
             
CP_COL: MOV AX, SRC[BX][SI]
        MOV ARRAY1[DI], AX
              
        ADD BX, 2*COL
        SUB DI, 2
        
        CMP BX, ROW*COL*2
        JB CP_COL
        

        
        .exit
        END