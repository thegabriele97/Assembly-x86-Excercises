DIM     EQU 5

        .model small
        .stack
        .data   
        
prezzi    DW 39, 1880, 2394, 1000, 1590
scontati  DW DIM DUP (?)
sconto    DW 30
totsconto DW ?        
        
        .code
        .startup
        
        CALL CALCOLA_SCONTO
        JMP KILL
        
;-------PROCEDURES-----------------------
calcola_sconto PROC
        
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        
        
        MOV BX, 0x64
        SUB BX, SCONTO          ;CUTTED PRICE
        
        MOV CX, DIM             ;COUNTER
        MOV SI, OFFSET PREZZI
        MOV DI, OFFSET SCONTATI
        MOV TOTSCONTO, 0x0      ;ACCUMULATOR CLEAR
        
CI:     MOV AX, [SI]
        MUL BX                  ;MUL BY DISCOUNT
        
        PUSH BX                 ;SAVING DISCOUNT
        MOV BX, 0x64            ;BX=100 (0x64)
        DIV BX                  ;DIV BY 100 RESULT
        POP BX                  ;RESTORING ORIGINAL DISCOUNT
        
        CMP DX, 0x32            ;CHECK FOR APPROX: 0.5
        JB NO_ROX
        
        INC AX
        
NO_ROX: ADD TOTSCONTO, AX       ;ADD TO ACCUMULATOR
        MOV [DI], AX            ;SAVING IN SCONTATI
        
        ADD SI, 2
        ADD DI, 2       
        LOOP CI
        
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        RET        
        
calcola_sconto ENDP
;-------END OF PROCEDURES----------------   
KILL:        
        .exit
        END