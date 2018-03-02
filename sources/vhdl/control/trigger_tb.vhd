--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:05:39 02/01/2018
-- Design Name:   
-- Module Name:   /nhome/aabdulga/fobos/sources/vhdl/control/trigger_tb.vhd
-- Project Name:  fobos_hw
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: trigger_module
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
use work.fobos_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY trigger_tb IS
END trigger_tb;
 
ARCHITECTURE behavior OF trigger_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT trigger_module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         dut_working : IN  std_logic;
         trigger_length : IN  std_logic_vector(31 downto 0);
         trigger_wait : IN  std_logic_vector(31 downto 0);
			trigger_mode : IN  std_logic_vector(7 downto 0);
         trigger_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal dut_working : std_logic := '0';
   signal trigger_length : std_logic_vector(31 downto 0) := (others => '0');
   signal trigger_wait : std_logic_vector(31 downto 0) := (others => '0');
   signal trigger_mode : std_logic_vector(7 downto 0);


 	--Outputs
   signal trigger_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: trigger_module PORT MAP (
          clk => clk,
          rst => rst,
          dut_working => dut_working,
          trigger_length => trigger_length,
          trigger_wait => trigger_wait,
			 trigger_mode => trigger_mode,
          trigger_out => trigger_out
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
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
      rst <= '0';
      wait for clk_period*10;

      -- insert stimulus here 
      trigger_length <= x"00000004";
		trigger_wait <=   x"00000002";
		trigger_mode <= TRG_NORM;
		
		dut_working <= '1';
		wait for clk_period*15;
		dut_working <= '0';
      wait;
   end process;

END;
