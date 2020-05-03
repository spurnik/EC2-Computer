
--------------------------------------------------------------------------------
-- Process Unit
--------------------------------------------------------------------------------
-- 9 components (IR, PC, PCmux, PCincrementer, MEMmux, MEM, A, Amux, aritmetic_unit).
-- 3 distingished parts: instruction cycle, memory, data operation
-- External 8b data input/output always available.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity datapath is port(
    -- input
    input : in std_logic_vector(7 downto 0);
    clock, reset : in std_logic;
    -- control signals
    IRload : in std_logic;
    JMPmux : in std_logic;
    PCload : in std_logic;
    MEMinst : in std_logic;
    MEMwr : in std_logic;
    Asel : in std_logic_vector(1 downto 0);
    Aload : in std_logic;
    SUB : in std_logic;
    -- status signals
    opcode : out std_logic_vector(2 downto 0);
    Aeq0 : out std_logic;
    Apos : out std_logic;
    -- output
    output : out std_logic_vector(7 downto 0));
end datapath;

architecture rtl of datapath is

  component reg is generic( n : integer);     -- datapath's registers
    port(
    clock, clear, load : std_logic;
    D : in std_logic_vector((n-1) downto 0);
    Q : out std_logic_vector((n-1) downto 0));
  end component;

  component mux2_1 is generic ( n : integer);     -- datapath's multiplexors 2-1
    port(
    S : in std_logic;
    D0, D1 : in std_logic_vector((n-1) downto 0);
    Y : out std_logic_vector((n-1) downto 0));
  end component;

  component mux4_1 is generic ( n : integer);     -- datapath's multiplexors 4-1
    port(
    S : in std_logic_vector(1 downto 0);
    D0, D1, D2, D3 : in std_logic_vector((n-1) downto 0);
    Y : out std_logic_vector((n-1) downto 0));
  end component;

  component incrementer is generic( n : integer);     -- 5b PC incrementer
    port(
    input : in std_logic_vector((n-1) downto 0);
    output : out std_logic_vector((n-1) downto 0));
  end component;

  component add_sub is generic( n : integer);     -- 8b adder/substractor
    port(
    sub : in std_logic;
    A, B : in std_logic_vector((n-1) downto 0);
    output : out std_logic_vector((n-1) downto 0));
  end component;

  component memory is port(     -- 32 x 8b internal RAM memory.
    WE, clock : in std_logic;
    address : in std_logic_vector(4 downto 0);
    D : in std_logic_vector(7 downto 0);
    Q : out std_logic_vector(7 downto 0));
  end component;

  -- Instruction cycle signals
  signal IR_out : std_logic_vector(7 downto 0);
  signal PCmux_out, incrementer_out, PC_out, address_out : std_logic_vector(4 downto 0);

  -- Memory signals
  signal mem_out : std_logic_vector(7 downto 0);

  -- Operational signals
  signal Amux_out, A_out, add_sub_out : std_logic_vector(7 downto 0);

begin
  -- DATAPATH'S COMPONENTS
  ------------------------------------------------------------------------------
  -- Instruction register 8b
  IR : reg generic map (8) port map (clock => clock, clear => reset, load => IRload,
                                      D => mem_out, Q => IR_out);

  -- Program counter 5b
  PC : reg generic map (5) port map (clock => clock, clear => reset, load => PCload,
                                      D => PCmux_out, Q => PC_out);

  -- Program counter multiplexor (next(0)/jump(1)) 5b
  PCmux : mux2_1 generic map(5) port map (S => JMPmux, D0 => incrementer_out,
                                        D1 => IR_out(4 downto 0), Y => PCmux_out);

  -- Program counter incrementer 5b
  PCincrementer : incrementer generic map(5)
                                port map (input => PC_out, output => incrementer_out);

  -- Memory adress multiplexor (instruction(0)/data(1)) 5b
  MEMmux : mux2_1 generic map(5) port map(S => MEMinst, D0 => PC_out,
                                        D1 => IR_out(4 downto 0), Y => address_out);

  -- Internal memory 32 x 8b
  MEM : memory port map (WE => MEMwr, clock => clock, address => address_out,
                          D => A_out, Q => mem_out);

  -- Accumulator 8b
  A : reg generic map(8) port map (clock => clock, clear => reset, load => Aload,
                                      D => Amux_out, Q => A_out);

  -- Accumulator multiplexor 8b
  Amux : mux4_1 generic map(8) port map(S => Asel, D0 => add_sub_out, D1 => input,
                                        D2 => mem_out, D3 => "00000000", Y => Amux_out);

  -- Adder-substractor 8b
  aritmetic_unit : add_sub generic map(8) port map (sub => SUB, A => A_out,
                                              B => mem_out, output => add_sub_out);

  -- STATUS SIGNALS:
  ------------------------------------------------------------------------------
  -- opcode, 3b
  opcode <= IR_out(7 downto 5);

  -- A equal 0, 1b
  Aeq0 <= '1' when A_out = "00000000" else '0';

  -- A positive, 1b
  Apos <= not A_out(7);

  -- Output
  output <= A_out;

end rtl;
