--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:06:04 10/19/2013
-- Design Name:   
-- Module Name:   E:/FOBOS/dac_test/dac_test/injection_top_tb.vhd
-- Project Name:  dac_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: INJECTION
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
 
ENTITY injection_top_tb IS
END injection_top_tb;
 
ARCHITECTURE behavior OF injection_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT INJECTION
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         inj_fault : IN  std_logic;
         injecting : OUT  std_logic;
         dout : OUT  std_logic_vector(7 downto 0);
			dac_clk : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal inj_fault : std_logic := '0';

 	--Outputs
   signal injecting : std_logic;
   signal dout : std_logic_vector(7 downto 0);
	signal dac_clk : std_logic;
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: INJECTION PORT MAP (
          rst => rst,
          clk => clk,
          inj_fault => inj_fault,
          injecting => injecting,
          dout => dout,
			 dac_clk => dac_clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		rst <= '1';
		inj_fault <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;

      -- insert stimulus here 
		inj_fault <= '1';
		--wait for 100 ns;
		--inj_fault <= '0';
      wait;
   end process;

END;
