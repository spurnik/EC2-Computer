
--------------------------------------------------------------------------------
-- Generic incrementer n bits
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementer is generic( n : integer); -- input bit with
  port(
  input : in std_logic_vector((n-1) downto 0);
  output : out std_logic_vector((n-1) downto 0));
end incrementer;

architecture behav of incrementer is
begin
  process(input)
  begin
    output <= std_logic_vector(unsigned(input) + 1);
  end process;
end behav;
