
--------------------------------------------------------------------------------
-- Control unit
--------------------------------------------------------------------------------
-- 11 states (START, FETCH, DECODE, LOAD, STORE, ADD, SUB, IN, JZ, JPOS, HALT).
-- Unconditional cycle START => FETCH => DECODE => [EXECUTION_STATE].
-- External input: clock, reset, Enter.
-- External output: Halt.
-- 9 control signals for controlling datapath's operations.
-- 2 status signals and opcode.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity controller is port(
  -- external input
  clock, reset, Enter : in std_logic;
  -- control signals
  IRload : out std_logic;  -- load control for IR register
  JMPmux : out std_logic;  -- selection control for PC mux
  PCload : out std_logic;  -- load control for PC register
  MEMinst : out std_logic;  -- selection control for Memory address mux
  MEMwr : out std_logic;  -- memory write enable
  Asel : out std_logic_vector(1 downto 0);  -- selection control for Accumulator mux
  Aload : out std_logic;  -- load control for Accumulator register
  SUB : out std_logic;  -- arithmetic operation control for Adder/Substractor
  -- status signals
  opcode : in std_logic_vector(2 downto 0);  -- operand code of the IR register
  Aeq0 : in std_logic;  -- zero signal of Accumulator content
  Apos : in std_logic;  -- positive signal of Accumulator content
  -- external output
  halt : out std_logic;  -- halting signal
  -- for debug
  state_out : out std_logic_vector(3 downto 0));  -- state debug signal
end controller;

architecture behav of controller is
  type stateType is (s_start, s_fetch, s_decode, s_load, s_store, s_add, s_sub,
                      s_in, s_jz, s_jpos, s_halt);
  signal state : stateType;
begin

  next_state_logic : process(clock, reset)
                     begin
                       if (reset = '1') then  -- asynchronous reset
                        state <= s_start;
                       elsif (clock'event and clock = '1') then

                         case state is
                           -- From START to unconditional FETCH.
                           when s_start => state <= s_fetch;

                           -- From FETCH to unconditional DECODE.
                           when s_fetch => state <= s_decode;

                           -- From DECODE, to conditional (by opcode) EXECUTION state.
                           when s_decode =>
                            case opcode is
                              when "000" => state <= s_load;    -- LOAD state
                              when "001" => state <= s_store;   -- STORE state
                              when "010" => state <= s_add;     -- ADD state
                              when "011" => state <= s_sub;     -- SUB state
                              when "100" => state <= s_in;      -- IN state
                              when "101" => state <= s_jz;      -- JZ state
                              when "110" => state <= s_jpos;    -- JPOS state
                              when others => state <= s_halt;   -- HALT state
                            end case;

                           -- From EXECUTION state (except IN, HALT) to unconditional START.
                           when s_load|s_store|s_add|s_sub|s_jz|s_jpos =>
                             state <= s_start;

                           -- From IN, to conditional (by Enter key) START.
                           when s_in => if (Enter = '1') then state <= s_start; end if;

                           -- From HALT or anything unexpected to uncoditional HALT.
                           when others => state <= s_halt;

                         end case;
                       end if;
                     end process;

  output_logic :  process(state)
                  begin
                    case state is
                      -- FETCH : load instruction from memory to IR and increase PC by 1
                      when s_fetch =>
                        IRload <= '1'; JMPmux <= '0'; PCload <= '1'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                      -- DECODE : transition state depending on opcode. Also reads
                      --          the memory content given by instruction operand address.
                      when s_decode =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '1';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                      -- LOAD : stores the memory available content from DECODE state
                      --        to the Accumulator.
                      when s_load =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "10"; Aload <= '1'; SUB <= '0'; halt <= '0';

                      -- STORE : stores the accumulator's content on the memory location given by
                      --         the operand address.
                      when s_store =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '1';
                        MEMwr <= '1'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                      -- ADD : sums the memory available content with the Accumulator
                      --       content, and stores the result into Accumulator.
                      when s_add =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '1'; SUB <= '0'; halt <= '0';

                      -- SUB : substract the memory available content with the Accumulator
                      --       content, and stores the result into Accumulator.
                      when s_sub =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '1'; SUB <= '1'; halt <= '0';

                      -- IN : Loads 8b external data input on the Accumulator.
                      when s_in =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "01"; Aload <= '1'; SUB <= '0'; halt <= '0';

                      -- JZ : if Accumulator's content is zero, loads the operand
                      --      address to the PC. If not, does nothing.
                      when s_jz =>
                        IRload <= '0'; JMPmux <= '1'; PCload <= Aeq0; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                      -- JPOS : if Accumulator's content is positive, loads the operand
                      --        address to the PC. If not, does nothing.
                      when s_jpos =>
                        IRload <= '0'; JMPmux <= '1'; PCload <= Apos; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                      -- HALT : Halts the execution, by only asserting the halt signal.
                      when s_halt =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '1';

                      -- START (or anything unexpected) : Just a temporal state,
                      --       acts as a stall.
                      when others =>
                        IRload <= '0'; JMPmux <= '0'; PCload <= '0'; MEMinst <= '0';
                        MEMwr <= '0'; Asel <= "00"; Aload <= '0'; SUB <= '0'; halt <= '0';

                    end case;
                  end process;

  -- For debugging the actual state.
  debug_process : process(state)
                  begin
                    case state is
                      when s_start => state_out <= "0000";
                      when s_fetch => state_out <= "0001";
                      when s_decode => state_out <= "0010";
                      when s_load => state_out <= "1000";
                      when s_store => state_out <= "1001";
                      when s_add => state_out <= "1010";
                      when s_sub => state_out <= "1011";
                      when s_in => state_out <= "1100";
                      when s_jz => state_out <= "1101";
                      when s_jpos => state_out <= "1110";
                      when s_halt => state_out <= "1111";
                      when others => state_out <= (others => 'Z');
                    end case;
                  end process;
end behav;
