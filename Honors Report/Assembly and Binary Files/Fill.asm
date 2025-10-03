//keyboard loop
(key)
@KBD
D=M
@black
D;JGT
@white
0;JMP

//sets reg 0 to -1 (black) or 0 (white)
(black)
@0
M=-1
@fill
0;JMP

(white)
@0
M=0
@fill
0;JMP
//initialized count down in reg 1 corresponding to # of reg used by screen
(fill)
@8192   
D=A
@1
M=D

@SCREEN
D=A
@reg
M=D

//loop reads screen color from R0 and writes it to current address in @reg
//@reg incremented by one each loop cycle
//R1 (counter register) decremented by 1 each cycle
//Jump condition - when value of count in R1 > 0, loop continues
//Once count reaches zero (all screen memory addresses have been written either black or white) entire program loops again
(loop)
@0
D=M
@reg
A=M
M=D
@reg
M=M+1
@1
DM=M-1

@loop
D;JGT

@key
0;JMP

