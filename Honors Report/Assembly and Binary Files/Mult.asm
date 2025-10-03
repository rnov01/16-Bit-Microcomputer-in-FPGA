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

