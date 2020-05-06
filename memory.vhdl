
--------------------------------------------------------------------------------
-- RAM memory 32x8b
--------------------------------------------------------------------------------
-- Program initiallization
-- 5 bit adresses
-- Synchronous read/write.
-- One control signal WE (1 for write, 0 for read)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is port(
  WE, clock : in std_logic;                     -- Write enable
  address : in std_logic_vector(4 downto 0);    -- Adress 5b
  D : in std_logic_vector(7 downto 0);          -- Input
  Q : out std_logic_vector(7 downto 0));        -- Output
end memory;

architecture behav of memory is
  type memArray is array(0 to 31) of std_logic_vector(7 downto 0);
  signal mem : memArray := -- Memory Program:
             ("100XXXXX",  -- 00. IN A
              "00101111",  -- 01. STORE A, X
              "00110001",  -- 02. STORE A, X*Y
              "100XXXXX",  -- 03. IN A
              "00110000",  -- 04. STORE A, Y
              "00010000",  -- 05. LOAD A, Y
              "01110010",  -- 06. SUB A, #1
              "00110000",  -- 07. STORE A, Y
              "10101101",  -- 08. JZ 13
              "00010001",  -- 09. LOAD A, X*Y
              "01001111",  -- 10. ADD A, X
              "00110001",  -- 11. STORE A, X*Y
              "11000101",  -- 12. JPOS 05
              "00010001",  -- 13. LOAD A, X*Y
              "111XXXXX",  -- 14. HALT
              "00000000",  -- 15. X
              "00000000",  -- 16. Y
              "00000000",  -- 17. X*Y
              "00000001",  -- 18. #1
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000",
              "00000000");

begin
  operation : process(clock, WE)
              begin
                if (clock'event and clock = '1') then
                  if (WE = '1') then                         -- write operation
                    mem(to_integer(unsigned(address))) <= D;
                  else                                       -- read operation
                    Q <= mem(to_integer(unsigned(address)));
                  end if;
                end if;
              end process;
end behav;
