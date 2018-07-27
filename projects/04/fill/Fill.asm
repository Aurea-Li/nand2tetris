// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

@SCREEN
D=A
@addr
M=D         // addr = 16384
            // (screen's base address)
@i
M=0         
@n
M=8192      // n = 256 * 32

(LOOP)
@n
D=M         // D = n
@i
D=M-D       // D = i - n
@END
D;JGE       // if (i-n) >= 0 goto END

@addr
A=M
M=-1        // RAM[addr] = 111...111
@i
M=M+1       // i++
@addr
M=M+1       // addr++

@LOOP
0;JMP

(END)
@END
0;JMP

