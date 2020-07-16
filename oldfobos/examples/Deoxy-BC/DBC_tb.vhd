--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:39:15 07/19/2016
-- Design Name:   
-- Module Name:   C:/Users/aabdulgadir/Documents/Fall2105/projects/deoxys3/DBC_tb.vhd
-- Project Name:  deoxys3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DBC
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
 
ENTITY DBC_tb IS
END DBC_tb;
 
ARCHITECTURE behavior OF DBC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DBC
    PORT(
         key : IN  std_logic_vector(127 downto 0);
         --tweak : IN  std_logic_vector(127 downto 0);
         din : IN  std_logic_vector(127 downto 0);
         dout : OUT  std_logic_vector(127 downto 0);
         --ready : OUT  std_logic;
         start : IN  std_logic;
         clk : IN  std_logic;
         --reset : IN  std_logic;
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal key : std_logic_vector(127 downto 0);
   signal tweak : std_logic_vector(127 downto 0);

   signal din : std_logic_vector(127 downto 0);
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(127 downto 0);
   signal ready : std_logic;
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
   uut: DBC PORT MAP (
          key => key,
          --tweak => tweak,
          din => din,
          dout => dout,
---          ready => ready,
          start => start,
          clk => clk,
          --reset => reset,
          done => done
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
		
		--key <= x"0F0E0D0C0B0A09080706050403020100";
		--key <= x"51DBADFC187EDB926F6E202E7288153A";
		key <=   x"55555555555555555555555555555555";
		--tweak <= x"0F0E0D0C0B0A09080706050403020100";
		tweak <= x"000000000000001fe000000000000001";
		 
		--din<= x"0F0E0D0C0B0A09080706050403020100";
		din<= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 20 ns;	
		reset <= '0';
      wait for clk_period;

      -- insert stimulus here 
		
		start <= '1';
		wait for clk_period;
		start <= '0';
		
		
		wait for clk_period * 17;
		
		--second block
		tweak <= x"000000000000001fe000000000000002";
		start <= '1';
		wait for clk_period;
		start <= '0';
		
		
		
      wait;
   end process;

END;
