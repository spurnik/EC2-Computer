
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
  signal mem : memArray :=  -- Memory Program:
              ("100XXXXX",  -- 00. IN A
               "00101111",  -- 01. STORE A, MEM[15]
               "00110001",  -- 02. STORE A, MEM[17]
               "100XXXXX",  -- 03. IN A
               "00110000",  -- 04. STORE A, MEM[16]

               "00010000",  -- 05. LOAD A, MEM[16]
               "01110010",  -- 06. SUB A, MEM[18]
               "00110000",  -- 07. STORE A, MEM[16]
               "10101101",  -- 08. JZ 13
               "00010001",  -- 09. LOAD A, MEM[17]
               "01001111",  -- 10. ADD A, MEM[15]
               "00110001",  -- 11. STORE A, MEM[17]
               "11000101",  -- 12. JPOS 05

               "00010001",  -- 13. LOAD A, MEM[17]
               "111XXXXX",  -- 14. HALT

               "00000000",  -- 15. A
               "00000000",  -- 16. B
               "00000000",  -- 17. RESULT (A * B)
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
