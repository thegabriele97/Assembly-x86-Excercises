INT_R   EQU 1
INT_W   EQU 2
SIZE    EQU 6

        .model small
        .stack
        
        .data
ARRAY   DB 87, 8, 7, 1, 3, 5
        
        .code
        .startup
        
        MOV SI, 1H 
        MOV AL, ARRAY

CYCLE:  CMP ARRAY[SI], AL
        JNB CONT            ;if not smallest, jmp to next
        
        MOV AL, ARRAY[SI]   ;copying new smallest value
        JMP CONT          

CONT:   INC SI              ;preparing for next iteration
        CMP SI, SIZE
        JNZ CYCLE
        
        MOV AH, INT_W       ;setting up registers
        MOV DL, AL          ;to display smallest value
        ADD DL, '0'
        INT 21H
                
        .exit
        END