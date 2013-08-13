--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:46:01 08/04/2013
-- Design Name:   
-- Module Name:   C:/Users/Jeremy/Documents/GitHub/memory_buffer_latest/TB_test_module.vhd
-- Project Name:  FINAL_ADCOUT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_test_module IS
END TB_test_module;
 
ARCHITECTURE behavior OF TB_test_module IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT test_module
    PORT(
         Input : IN  std_logic_vector(15 downto 0);
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         Output : OUT  std_logic_vector(15 downto 0);
         FIFO_WR_EN : IN  std_logic;
         FIFO_RD_EN : IN  std_logic;
         FIFO_FULL : OUT  std_logic;
         FIFO_EMPTY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Input : std_logic_vector(15 downto 0) := (others => '0');
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal FIFO_WR_EN : std_logic := '0';
   signal FIFO_RD_EN : std_logic := '0';

 	--Outputs
   signal Output : std_logic_vector(15 downto 0);
   signal FIFO_FULL : std_logic;
   signal FIFO_EMPTY : std_logic;

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: test_module PORT MAP (
          Input => Input,
          CLOCK => CLOCK,
          RESET => RESET,
          Output => Output,
          FIFO_WR_EN => FIFO_WR_EN,
          FIFO_RD_EN => FIFO_RD_EN,
          FIFO_FULL => FIFO_FULL,
          FIFO_EMPTY => FIFO_EMPTY
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_period*10;
		Input <= "0000000000000000";
		fifo_WR_EN <= '1';
		wait for clock_period;
		Input <= "0000000000000001";
		wait for clock_period;
		Input <= "0000000000000010";
		wait for clock_period;
		fifo_wr_en <= '0';
		fifo_rd_en <= '1';
		Input <= "1111111111111111";
		
      -- insert stimulus here 

      wait;
   end process;

END;
