# EC2-Computer

Implementation of "Enoch" Computer version 2, designed by Enoch O. Hwang, in his book _Digital Logic and Microprocessor Design with VHDL_, 2005.

The computer follows the Von Neumann approach, based on an 8b microprocessor with internal data+instruction RAM memory, including input/output ports.

## Instruction set

The instruction set is composed on eight different instructions:

|   Instruction    |    Encoding    |      Operation       |                       Comment                            |
|------------------|----------------|----------------------|----------------------------------------------------------|
| LOAD A, address  |    000aaaaa    |    A <= Mem[aaaaa]   |  Load to A the memory data specified by address.         |
| STORE A, address |    001aaaaa    |    Mem[aaaaa] <= A   |  Store A content to memory location specified by address |
|  ADD A, address  |    010aaaaa    |  A <= A + Mem[aaaaa] |  Add A content with memory data and stores in A          |
|  SUB A, address  |    011aaaaa    |  A <= A - Mem[aaaaa] |  Substract A content with memory data and stores in A    |
|       IN A       |    100-----    |      A <= input      |  Store the input data into A                             |
|   JZ address     |    101aaaaa    | if (A=0) PC <= aaaaa |  Jump to memory location if A content is zero            |
|  JPOS address    |    110aaaaa    | if (A>0) PC <= aaaaa |  Jump to memory location if A content is positive        |
|       HALT       |    111-----    |         HALT         |  Halts the execution of the program.                     |

 where 
 + A : 8b accumulator register.
 + Mem : internal 32x8b RAM memory.
 + aaaaa : 5 bit address to point one of the memory slots.
 + ----- : not defined nor used bits
 
 ## Datapath
 
The datapath or process unit is designed based on the instruction set, because it has to perform all the functional and arithmetic operations, which are specified by the instructions. First, let's decide the components. 

We already know the presence of an accumulator register, which will retain the output of the processor, and the RAM memory, with 32 8b words and synchronous read/write. Of course we need an 8b instruction register to get the instruction from memory, 
and the program counter register. To point the 32 locations, the PC has to be of 5b. A 5b incrementer is needed to increment the PC address. The arithmetic operations are two: addition and substraction. Both can be performed by an 8b adder/substractor (is not necessary to use an ALU just for them). 

Then, the instructions will help us on deciding the component's connections. 

The STORE (LOAD) instruction is done by connecting the accumulator input(output) with memory output(input). To extract the memory address, we have to plug the 5 less relevant bits of the IR output into memory address port. So we need a 2_1 multiplexor, for deciding which signal goes with memory address: PC's ouput to point the next instruction, or the operand address. To perform the arithmetic instructions, we'll connect the accumulator output into the adder/substractor as the first operand, and the memory ouput connected as the second operand. The result is charged back into accumulator, with priority over processor input (IN instruction) and memory output (LOAD instruction). So we'll use an 8b 4_1 multiplexor with just three inputs, and the output is directly connected to accumulator. 

Finally, the jump instructions reveal the use of a 5b 2_1 multiplexor, as PC's mux. This is to decide whether to charge the next memory address given by incrementer's signal or the jumping new address, given by IR signal (both of 5b). Depending on the accumulator output, the control unit will enable the mux selection signal. So we need two status signals, Aeq0 and Apos. The first one tells to CU if accumulator's output is zero or not, and the second one if it's positive. We can generate Aeq0  with an 8b NOR gate and Apos as the 7th bit of accumulator output, negated.
 
 ## Control Unit
 
 
 
 ## Implementation
 
 
 
 ## Execution and testbench
 
