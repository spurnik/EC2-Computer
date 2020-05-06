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
 
The datapath or process unit is designed based on the instruction set, because it has to perform all the functional and arithmetic operations, which are specified by the instructions. The **components** will be:

1. **A** (8b) : Accumulator register. Stores the result of arithmetic operation.
2. **RAM memory** (32x8b) : internal memory with synchronous read and write operations. 
3. **IR** (8b) : Instruction Register, stores the current instruction fetched from memory.
4. **PC** (5b) : Program Counter. Contains the next instruction address.
5. **Incrementer** (5b) : Used to increment PC's content.
6. **Adder/Substractor** (8b) : performs addition and substraction.
7. **PCmux** (5b) : 2-1 multiplexor which selects the next PC address.
8. **MEMmux** (5b) : 2-1 multiplexor to select the next memory address.
9. **Amux** (8b) : 4-1 multiplexor to select the next accumulator content.

The datapath has to perform the following **operations**, classified on their purpose:

1. _Instruction cycle_: 
 + Loads the instruction from memory to IR. Increments PC's content by one and load it back to PC. 
 + Distinguish between memory fecthing address (to fecth the next instruction) and memory operand address (to point some memory data).

2. _Memory cycle_: 
 + Reads the memory data/instruction specified by memory address and loads it to A/IR.
 + Writes A's content to the memory location specified by memory address.
 
3. _Execution cycle_:
 + Adds or substracts to A's content the memory output data, and loads the result back to A.
 + Loads the external data input to A.
 + Loads the operand address specified by jump instruction on PC.
 
The datapath also has to provide the next **status signals** to CU:

+ **Aeq0** (1b) : Tells to CU whether A content is zero. Implemented on A output with an 8b NOR gate.
+ **Apos** (1b) : Tells to CU whether A content is positive. Implemented by negating the most significant bit of A output.
+ **Opcode** (3b) : The three most significant bits of IR output, tells to CU which instruction to execute.
 
From the components and functionallity, we will need up to 8 **control signals** from CU, which are:

1. **IRload** (1b) : IR load enable signal.
2. **JMPmux** (1b) : PCMux selection signal.
3. **PCload** (1b) : PC load enable signal.
4. **MEMinst** (1b) : MemMux selection signal.
5. **MEMwr** (1b) : memory write enable signal.
6. **Asel** (2b) : Amux selection signals.
7. **Aload** (1b) : A load enable signal.
8. **Sub** (1b) : Substraction enable signal.

So here's the Datapath design, which best describes the conections between it's components:

![](images/DATAPATH.png)

 ## Control Unit
 
We have already all the necessary control signals to control datapath's operations. The control unit is just a **FSM (Finite State Machine)**, whose output are the control signals values, grouped as a 'control word'. Each possible control word is performed at one clock cycle. 

So first we have to define the **FSM states** to perform all the operations of the datapath:

1. **START** (0000) : The 'no operation' state. Acts as a stall, in order to load all the previous result values. Also reads from memory the next instruction pointed by PC.

2. **FETCH** (0001) : Fetches the available next instruction, by loading directly to IR, and increases PC by one.

3. **DECODE** (0010) : Transition state depending on opcode. Reads the memory content given by instruction operand address.

 3.1. **LOAD** (1000) : Loads the memory available content from DECODE state to A.

 3.2. **STORE** (1001) : Stores A content on the memory location given by instruction operand address.

 3.3. **ADD** (1010) : Sums A content with memory available content from DECODE state, and loads the result back into A.

 3.4. **SUB** (1011) : Substract A content with memory available content from DECODE state, and loads the result back into A.

 3.5. **IN** (1100) : Loads 8b external data input into A.

 3.6. **JZ** (1101) : If A content is zero (Aeq0 = 1), loads the instruction operand address into PC. If not, does nothing.

 3.7. **JPOS** (1110) : If A content is positive (Apos = 1), loads the instruction operand address into PC. If not, does nothing.

 3.8. **HALT** (1111) : Halts the execution, by only asserting the halt signal.

 Now that all the states are defined, we can derive the **state diagram** as follows:
 
 ![](images/StateDiagram.png)

Output table

| CURRENT STATE | IRLOAD |  JMPMUX | PCLOAD | MEMINSTR | MEMWR | ASEL | ALOAD | SUB | HALT |
|---------------|--------|---------|--------|----------|-------|------|-------|-----|------|
| 0000 (start)  |   0    |    0    |    0   |    0     |   0   |  00  |   0   |  0  |  0   |
| 0001 (fetch)  |   1    |    0    |    1   |    0     |   0   |  00  |   0   |  0  |  0   |
| 0010 (decode) |   0    |    0    |    0   |    1     |   0   |  00  |   0   |  0  |  0   |
| 1000 (load)   |   0    |    0    |    0   |    0     |   0   |  10  |   1   |  0  |  0   |
| 1001 (store)  |   0    |    0    |    0   |    1     |   1   |  00  |   0   |  0  |  0   |
| 1010 (add)    |   0    |    0    |    0   |    0     |   0   |  00  |   1   |  0  |  0   |
| 1011 (sub)    |   0    |    0    |    0   |    0     |   0   |  00  |   1   |  1  |  0   |
| 1100 (in)     |   0    |    0    |    0   |    0     |   0   |  01  |   1   |  0  |  0   |
| 1101 (jz)     |   0    |    1    |  Aeq0  |    0     |   0   |  00  |   0   |  0  |  0   |
| 1110 (jpos)   |   0    |    1    |  Apos0 |    0     |   0   |  00  |   0   |  0  |  0   |
| 1111 (halt)   |   0    |    0    |    0   |    0     |   0   |  00  |   0   |  0  |  1   |

 ## Implementation
 
 Complete circuit:
 
 ![](images/CompleteCircuit.png)
 
 ## Execution and testbench
 
