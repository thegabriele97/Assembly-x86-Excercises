        .model small
        .stack
        .data
        
OPA     DB 0x33        
        
        .code
        .startup
        
        XOR BL, BL        ;BL IS USED TO STORE COUNT
        MOV CX, 0x8       ;NUMBER OF BITS TO CHECK
        MOV AL, OPA       ;NUMBER TO CHECK
        
        XOR AH, AH        ;AH WORKS AS A MASK WITH VALUES LIKE
        OR AH, 0x1        ;00000001, 00000010, 00000100, ...
        
CHECK:  TEST AL, AH       ;AND BIT A BIT, RESULT IN ZF
        
        JZ NOT_ONE        ;CHECK ZF
        INC BL            ;IF IS 0, BL++
        
NOT_ONE:SHL AH, 1         ;UPDATE MASK
        LOOP CHECK                
        
        .exit
        END