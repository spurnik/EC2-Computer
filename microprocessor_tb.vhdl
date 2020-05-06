
--------------------------------------------------------------------------------
-- Microprocessor simple testbench
--------------------------------------------------------------------------------
-- Generates external input/output signals for the microprocessor.
-- Program loaded directly into microprocessor's memory entity.
-- No asserting test
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity microprocessor_tb is
end microprocessor_tb;

architecture test of microprocessor_tb is

  component microprocessor is port(
    Enter, clock, reset : in std_logic;
    input : in std_logic_vector(7 downto 0);
    output : out std_logic_vector(7 downto 0);
    halt : out std_logic);
  end component;

  signal s_Enter, s_clock, s_reset, s_halt : std_logic;
  signal s_input, s_output : std_logic_vector(7 downto 0);

begin

  EC2 : microprocessor port map(Enter => s_Enter, clock => s_clock, reset => s_reset,
                                  input => s_input, output => s_output, halt => s_halt);

  clock_generator : process
                      constant clk_period: time := 10 ns;
                    begin
                      s_clock <= '0';
                      wait for clk_period/2;
                      s_clock <= '1';
                      wait for clk_period/2;
                    end process;

  test_process :  process
                  begin
                    s_reset <= '1';
                    s_Enter <= '1';
                    s_input <= "00000111"; -- 7
                    wait for 10 ns;
                    s_reset <= '0';
                    wait for 100 ns;
                    s_input <= "00001101"; -- 13
                    wait;
                  end process;

end test;
