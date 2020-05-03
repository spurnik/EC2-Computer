
--------------------------------------------------------------------------------
-- Microprocessor
--------------------------------------------------------------------------------
-- 8 bit width.
-- load/store set instruction with 8 different 1-operand instructions.
-- 32x8b RAM internal memory with synchronous read/write operations.
-- Adder/Substractor arithmetic unit with Accumulator general purpose register.
-- Always available Output with HALT signal for halting execution.
-- FSM+D design, with RTL implementation.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity microprocessor is port(
  -- INPUT signals
  Enter, clock, reset : in std_logic;
  input : in std_logic_vector(7 downto 0);
  -- OUTPUT signals
  output : out std_logic_vector(7 downto 0);
  halt : out std_logic);
end microprocessor;

architecture rtl of microprocessor is

  -- DATAPATH
  component datapath is port(
      input : in std_logic_vector(7 downto 0);
      clock, reset : in std_logic;
      IRload : in std_logic;
      JMPmux : in std_logic;
      PCload : in std_logic;
      MEMinst : in std_logic;
      MEMwr : in std_logic;
      Asel : in std_logic_vector(1 downto 0);
      Aload : in std_logic;
      SUB : in std_logic;
      opcode : out std_logic_vector(2 downto 0);
      Aeq0 : out std_logic;
      Apos : out std_logic;
      output : out std_logic_vector(7 downto 0));
  end component;

  -- CONTROLLER
  component controller is port(
    -- external input
    clock, reset, Enter : in std_logic;
    -- control signals
    IRload : out std_logic;
    JMPmux : out std_logic;
    PCload : out std_logic;
    MEMinst : out std_logic;
    MEMwr : out std_logic;
    Asel : out std_logic_vector(1 downto 0);
    Aload : out std_logic;
    SUB : out std_logic;
    -- status signals
    opcode : in std_logic_vector(2 downto 0);
    Aeq0 : in std_logic;
    Apos : in std_logic;
    -- external output
    halt : out std_logic;
    -- for debug
    state_out : out std_logic_vector(3 downto 0));
  end component;

  -- control signals
  signal s_IRload, s_JMPmux, s_PCload, s_MEMinst, s_MEMwr, s_Aload, s_SUB : std_logic;
  signal s_Asel : std_logic_vector(1 downto 0);

  -- status signals
  signal s_Aeq0, s_Apos : std_logic;
  signal s_opcode : std_logic_vector(2 downto 0);

  -- debug signals
  signal state : std_logic_vector(3 downto 0);

begin

  -- RTL datapath
  the_process_unit : datapath port map( input => input,
                                        clock => clock, reset => reset,
                                        IRload => s_IRload,
                                        JMPmux => s_JMPmux,
                                        PCload => s_PCload,
                                        MEMinst => s_MEMinst,
                                        MEMwr => s_MEMwr,
                                        Asel => s_Asel,
                                        Aload => s_Aload,
                                        SUB => s_SUB,
                                        opcode => s_opcode,
                                        Aeq0 => s_Aeq0,
                                        Apos => s_Apos,
                                        output => output);

  -- BEHAVIORAL controller
  the_control_unit : controller port map( clock => clock,
                                          reset => reset,
                                          Enter => Enter,
                                          IRload => s_IRload,
                                          JMPmux => s_JMPmux,
                                          PCload => s_PCload,
                                          MEMinst => s_MEMinst,
                                          MEMwr => s_MEMwr,
                                          Asel => s_Asel,
                                          Aload => s_Aload,
                                          SUB => s_SUB,
                                          opcode => s_opcode,
                                          Aeq0 => s_Aeq0,
                                          Apos => s_Apos,
                                          halt => halt,
                                          state_out => state);

end rtl;
