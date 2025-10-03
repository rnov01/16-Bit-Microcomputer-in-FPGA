// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// The algorithm is based on repetitive addition.

//// Replace this comment with your code.

@i
M=0

@0
D=M
@zero
D;JEQ

@1
D=M
@zero
D;JEQ


@2
M=0

(loop)

@i
M=D-1
@0
D=M
@2
D=D+M
M=D
@i
D=M
@loop
D;JGT
@end
0;JMP

(zero)
@2
M=0

(end)
@end
0;JMP

