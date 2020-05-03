
--------------------------------------------------------------------------------
-- Generic register of n bits
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg is generic( n : integer); -- size of the register
  port(
  clock, clear, load : std_logic;
  D : in std_logic_vector((n-1) downto 0);
  Q : out std_logic_vector((n-1) downto 0));
end reg;

architecture behav of reg is
begin
  process(clear, clock)
  begin
    if (clear = '1') then
      Q <= (others => '0'); --asynchronous clear
    elsif (clock'event and clock = '1') then
      if (load = '1') then Q <= D;  --synchronous load
      end if;
    end if;
  end process;
end behav;
