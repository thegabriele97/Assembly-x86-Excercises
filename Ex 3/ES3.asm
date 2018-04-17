COL     EQU 5
ROW     EQU 3        
        
        .model small
        .stack
        .data
        
        ;  [A]  [B]   [C]  [D]  [E][F] \ 
TAB     DW 154, 123,  109, 86,   4, ?; 0
        DW 412, -23, -231,  9,  50, ?; 1
        DW 123, -24,   12, 55, -45, ?; 2
RES_ROW DW   ?,   ?,    ?,  ?,   ?, ?; 3

REAL_SZ EQU $-TAB              
        
        .code
        .startup
        
        MOV BX, 0

        ;RESETTING RES_ROW TO 0
        MOV CX, COL
        MOV DI, 0
        
RESET:  MOV RES_ROW[DI], 0
        ADD DI, 2
        LOOP RESET     
                
        ;COMPUTING SUM
FOR_I:  MOV AX, 0
        MOV SI, 0           
        
FOR_J:  ADD AX, TAB[BX][SI]      ;ACCUMULATOR FOR CURR ROW
        
        MOV CX, RES_ROW[SI]      ;USING CX FOR COMPUTE
        ADD CX, TAB[BX][SI]      ;THE SUM FOR EACH COL
        MOV RES_ROW[SI], CX        
        
        ADD SI, 2                
        CMP SI, 2*COL 
        JNE FOR_J                ;LET'S GO TO NEXT COL
        
        ;COPY SUM OF CURRENT
        ;ROW IN TAB[BX][SI]
        MOV TAB[BX][SI], AX      ;MOV ACCUMULATOR AT END OF 
                                 ;CURRENT ROW
        ADD BX, SI               
        ADD BX, 2
        CMP BX, REAL_SZ-((COL+1)*2) ;DON'T LOOK AT THIS     
        JNE FOR_I                ;MOVING TO NEXT ROW
       
        .exit
        END