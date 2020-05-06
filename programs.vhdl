
--------------------------------------------------------------------------------
-- VHDL PROGRAMS: 4 programs. Includes all 32 bit words of memory.
--------------------------------------------------------------------------------

-- GCD : Program to calculate the GCD of two unsigned 8b numbers.
--------------------------------------------------------------------------------
"10000000", -- 00. IN A
"00111110", -- 01. STORE A, X
"10000000", -- 02. IN A
"00111111", -- 03. STORE A, Y
"00011110", -- 04. LOAD A, X
"01111111", -- 05. SUB A, Y
"10110000", -- 06. JZ 16
"11001100", -- 07. JPOS 12
"00011111", -- 08. LOAD A, Y
"01111110", -- 09. SUB A, X
"00111111", -- 10. STORE A, Y
"11000100", -- 11. JPOS 4
"00011110", -- 12. LOAD A, X
"01111111", -- 13. SUB A, Y
"00111110", -- 14. STORE A, X
"11000100", -- 15. JPOS 4
"00011110", -- 16. LOAD A, X
"11111111", -- 17. HALT
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
"00000000", -- 30. X
"00000000"  -- 31. Y


-- SUMMATION N DOWNTO 1: Sums positive input N downto 1, and outputs the result.
--                       Has unsigned overflow.
--------------------------------------------------------------------------------
"00011101", -- 00. LOAD A, #1
"01111101", -- 01. SUB A, #1
"00111110", -- 02. STORE A, SUM
"10000000", -- 03. IN  A
"00111111", -- 04. STORE A, N
"00011111", -- 05. LOAD A, N
"01011110", -- 06. ADD A, SUM
"00111110", -- 07. STORE A, SUM
"00011111", -- 08. LOAD A, N
"01111101", -- 09. SUB A, #1
"00111111", -- 10. STORE A, N
"10101101", -- 11. JZ 13
"11000101", -- 12. JPOS 05
"00011110", -- 13. LOAD A, SUM
"11111111", -- 14. HALT
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
"00000000",
"00000000",
"00000001", -- 29. #1
"00000000", -- 30. SUM
"00000000"  -- 31. N


-- COUNTDOWN : counts from postive input N downto 0.
--------------------------------------------------------------------------------
"10000000", -- 00. IN A
"01111111", -- 01. SUB A, #1
"10100100", -- 02. JZ 4
"11000001", -- 03. JPOS 1
"11111111", -- 04. HALT
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
"00000000",
"00000000",
"00000001"  -- 31. #1


-- INPUT PRODUCT: takes two 8b positive input numbers and performs multiplication.
--                Has signed overflow (error if the result excedes 2^7 - 1).
--------------------------------------------------------------------------------
"100XXXXX",  -- 00. IN A
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
"00000000"
