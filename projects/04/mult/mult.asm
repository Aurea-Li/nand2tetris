// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@i
M=0         // i = 0

@product
M=0         // product = 0

@R0
D=M
@n
M=D         // n = RAM[0]

@R1
D=M
@b
M=D         // b = RAM[1]

(LOOP)
@product
D=M         // D = product
@R2
M=D         // RAM[2] = product
@n
D=M         // D = n
@i
D=M-D       // D = i - n
@END
D;JGE       // if (i-n) >= 0 goto END
@b
D=M         // D = b
@product
M=M+D       // product = product + b
@i
M=M+1       // i++
@LOOP
0;JMP       // goto LOOP

(END)
@END
0;JMP       // Infinite loop





