
--------------------------------------------------------------------------------
-- Microprocessor simple testbench configuration
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

configuration test_conf of microprocessor_tb is

  for test

    for CPU : microprocessor use entity work.microprocessor(rtl);
      for rtl

        for the_process_unit : datapath use entity work.datapath(rtl);
          for rtl
            for IR : reg use entity work.reg(behav); end for;
            for PC : reg use entity work.reg(behav); end for;
            for PCmux : mux2_1 use entity work.mux2_1(behav); end for;
            for PCincrementer : incrementer use entity work.incrementer(behav); end for;
            for MEMmux : mux2_1 use entity work.mux2_1(behav); end for;
            for MEM : memory use entity work.memory(behav); end for;
            for A : reg use entity work.reg(behav); end for;
            for Amux : mux4_1 use entity work.mux4_1(behav); end for;
            for aritmetic_unit : add_sub use entity work.add_sub(behav); end for;
          end for; -- RTL datapath
        end for; -- the_process_unit

        for the_control_unit : controller use entity work.controller(behav);
        end for;

      end for; -- RTL microprocessor;
    end for; -- EC2
  end for; -- test

end test_conf;
