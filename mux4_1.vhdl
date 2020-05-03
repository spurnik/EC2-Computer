
--------------------------------------------------------------------------------
-- Generic multiplexor 4-1.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux4_1 is generic ( n : integer);     -- input/output bit width
  port(
  S : in std_logic_vector(1 downto 0);                    -- select line
  D0, D1, D2, D3 : in std_logic_vector((n-1) downto 0);   -- data bus input
  Y : out std_logic_vector((n-1) downto 0));              -- data bus output
end mux4_1;

architecture behav of mux4_1 is
begin
  process(S, D0, D1, D2, D3)
  begin
    if (S = "00") then Y <= D0;
    elsif (S = "01") then Y <= D1;
    elsif (S = "10") then Y <= D2;
    elsif (S = "11") then Y <= D3;
    end if;
  end process;
end behav;
