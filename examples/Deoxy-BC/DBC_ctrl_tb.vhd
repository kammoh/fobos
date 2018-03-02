--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:43:03 08/03/2016
-- Design Name:   
-- Module Name:   C:/Users/aabdulgadir/Documents/Fall2105/projects/deoxys3/DBC_ctrl_tb.vhd
-- Project Name:  deoxys3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DBC_ctrl
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
 
ENTITY DBC_ctrl_tb IS
END DBC_ctrl_tb;
 
ARCHITECTURE behavior OF DBC_ctrl_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DBC_ctrl
    PORT(
         done : OUT  std_logic;
         start : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         ready : OUT  std_logic;
         sel_in : OUT  std_logic;
         en_kt : OUT  std_logic;
         iii : OUT  std_logic_vector(3 downto 0);
         en_state : OUT  std_logic;
         init : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal ready : std_logic;
   signal sel_in : std_logic;
   signal en_kt : std_logic;
   signal i : std_logic_vector(3 downto 0);
   signal en_state : std_logic;
   signal init : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DBC_ctrl PORT MAP (
          done => done,
          start => start,
          clk => clk,
          reset => reset,
          ready => ready,
          sel_in => sel_in,
          en_kt => en_kt,
          iii => i,
          en_state => en_state,
          init => init
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
		reset <= '1';
		wait for clk_period;
		reset <= '0';
      wait for 20 ns;	

      wait for clk_period*2;
		start <= '1';
		wait for clk_period;
		start <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
