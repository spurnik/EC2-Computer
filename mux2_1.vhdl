
--------------------------------------------------------------------------------
-- Generic multiplexor 2-1.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is generic ( n : integer);  -- input/output bit width
  port(
  S : in std_logic;                           -- select line
  D0, D1 : in std_logic_vector((n-1) downto 0);   -- data bus input
  Y : out std_logic_vector((n-1) downto 0));       -- data bus output
end mux2_1;

architecture behav of mux2_1 is
begin
  process(S, D1, D0)
  begin
    if (S = '0') then Y <= D0;
    elsif (S = '1') then Y <= D1;
    end if;
  end process;
end behav;
