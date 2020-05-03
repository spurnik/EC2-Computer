# EC2-Computer

Implementation of "Enoch" Computer version 2, designed by Enoch O. Hwang, in his book 'Digital Logic and Microprocessor Design with VHDL', 2005.

The computer follows the Von Neumann approach, based on an 8b microprocessor with internal data+instruction RAM memory, including input/output ports.

## Instruction set

The instruction set is composed on eight different instructions:

    Instruction       | Encoding       | Operation        | Comment                                                      |
    ----------------------------------------------------------------------------------------------------------------------
    LOAD A, address   |    000aaaaa    |    A <= Mem[aaaaa]   |  Load to A the memory data specified by address.         |
    ----------------------------------------------------------------------------------------------------------------------
    STORE A, address  |    001aaaaa    |    Mem[aaaaa] <= A   |  Store A content to memory location specified by address |
    ----------------------------------------------------------------------------------------------------------------------
    ADD A, address    |    010aaaaa    |  A <= A + Mem[aaaaa] |  Add A content with memory data and stores in A          |
    ----------------------------------------------------------------------------------------------------------------------
    SUB A, address    |    011aaaaa    |  A <= A - Mem[aaaaa] |  Substract A content with memory data and stores in A    |
    ----------------------------------------------------------------------------------------------------------------------
    IN A              |    100-----    |      A <= input      |  Store the input data into A                             |
    ----------------------------------------------------------------------------------------------------------------------
    JZ address        |    101aaaaa    | if (A=0) PC <= aaaaa |  Jump to memory location if A content is zero            |
    ----------------------------------------------------------------------------------------------------------------------
    JPOS address      |    110aaaaa    | if (A>0) PC <= aaaaa |  Jump to memory location if A content is positive        |
    ----------------------------------------------------------------------------------------------------------------------
    HALT              |    111-----    |         HALT         | Halts the execution of the program.                      |
   -----------------------------------------------------------------------------------------------------------------------
 
 where A : accumulator 8b register and Mem : internal 32x8b RAM memory.
 
