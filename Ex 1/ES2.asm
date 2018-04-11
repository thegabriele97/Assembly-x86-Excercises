        .model small
        .stack
        .data

N1      DB 10
N2      DB 10H
N3      DB 10B
RES     DB ?

        .code
        .startup
        
        MOV AL, N1
        ADD AL, N2
        SUB AL, N3
        MOV RES, AL
        
        .exit
        END