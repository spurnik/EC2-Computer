
--------------------------------------------------------------------------------
-- Generic Adder/Substractor of n bits
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is generic( n : integer); -- input bit with
  port(
  sub : in std_logic; -- selection signal
  A, B : in std_logic_vector((n-1) downto 0);
  output : out std_logic_vector((n-1) downto 0));
end add_sub;

architecture behav of add_sub is
begin
  process(A, B, sub)
  begin
    if (sub = '0') then
      output <= std_logic_vector(unsigned(A) + unsigned(B));
    else
      output <= std_logic_vector(unsigned(A) - unsigned(B));
    end if;
  end process;
end behav;
