--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:56:04 06/12/2017
-- Design Name:   
-- Module Name:   /nhome/aabdulga/project/fobos_ctrl_new/tb_pulse_gen.vhd
-- Project Name:  fobos_ctrl_new
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pulse_gen
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
 
ENTITY tb_pulse_gen IS
END tb_pulse_gen;
 
ARCHITECTURE behavior OF tb_pulse_gen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pulse_gen
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         pulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
   signal pulse : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pulse_gen PORT MAP (
          clock => clock,
          reset => reset,
          start => start,
          pulse => pulse
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 
		start <= '1';
		wait for clock_period * 10;
		start <= '0';
		
		
		wait for clock_period * 10;
		start <= '1';
		wait for clock_period * 10;
		start <= '0';
		
		

      wait;
   end process;

END;
