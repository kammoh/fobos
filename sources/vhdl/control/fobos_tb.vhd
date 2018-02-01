--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:41:05 03/28/2017
-- Design Name:   
-- Module Name:   /nhome/aabdulga/Desktop/fobos-ctrl-masked/fobos_tb.vhd
-- Project Name:  fobos-ctrl-masked
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fobosControlTop
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
 
ENTITY fobos_tb IS
END fobos_tb;
 
ARCHITECTURE behavior OF fobos_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
 
    

   --Inputs
   signal clk : std_logic := '0';
   signal EppAstb : std_logic := '0';
   --signal EppDstb : std_logic := '0';
   signal EppWrite : std_logic := '0';
   signal EXTClock : std_logic := '0';
   signal dutClockSelector : std_logic := '0';
   signal src_read : std_logic := '0';
   signal dst_write : std_logic := '0';
   signal dataout : std_logic_vector(15 downto 0) := (others => '0');
   signal regEppAdrOut, hosttofpga_data :   std_logic_vector(7 downto 0);
   signal EppDstb,ctlEppDwrOut :  std_logic;
	--BiDirs
   signal EppDB : std_logic_vector(7 downto 0);

 	--Outputs
   signal EppWait : std_logic;
   signal cergbanner : std_logic_vector(11 downto 0);
   signal clkseltest : std_logic;
   signal trigger : std_logic;
   signal DUTClock : std_logic;
   signal reset : std_logic;
   signal src_ready : std_logic;
   signal dst_ready : std_logic;
   signal datain : std_logic_vector(15 downto 0);
	signal stateMachineLedsTarget : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant EXTClock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   ctrl: entity work.fobosControlTop PORT MAP (
          clk => clk,
			 ---
          regEppAdrOut => regEppAdrOut,
			 hosttofpga_data => hosttofpga_data,
			 EppDstb => EppDstb,
			 ctlEppDwrOut => ctlEppDwrOut,
			 ---
          cergbanner => cergbanner,
          EXTClock => EXTClock,
          dutClockSelector => dutClockSelector,
          clkseltest => clkseltest,
          trigger => trigger,
          DUTClock => DUTClock,
          reset => reset,
          src_ready => src_ready,
          dst_ready => dst_ready,
          datain => datain,
          src_read => src_read,
          dst_write => dst_write,
          dataout => dataout
        );
		  
	-- dut
	DUT : entity work.dutTopLevel(structure) port map( 
	  clock => DUTClock, 
	  reset => reset,
	  src_ready => src_ready,
	  dst_ready => dst_ready,
	  datain => datain, 
	  src_read => src_read,
	  dst_write => dst_write,
	  dataout => dataout
	);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   EXTClock_process :process
   begin
		EXTClock <= '0';
		wait for EXTClock_period/2;
		EXTClock <= '1';
		wait for EXTClock_period/2;
   end process;
 

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait for clk_period*10;
      -- insert stimulus here 
		--send key
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"08";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"09";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"55";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		
		---send data block
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"04";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"06";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"dd";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		
		
		--send mask1
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0a";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0b";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"11";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		
		--send mask2
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0c";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0d";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"22";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';
		
		--send mask3
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0e";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"0f";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"33";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';
		
		--send mask1
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"10";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
		regEppAdrOut <= x"30";hosttofpga_data <= x"11";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      for i in 0 to 16 loop
		
		  regEppAdrOut <= x"7A";hosttofpga_data <= x"44";ctlEppDwrOut <= '1';EppDstb<= '1';wait for clk_period;ctlEppDwrOut<='0'; EppDstb<= '0'; wait for clk_period;
		end loop;
		regEppAdrOut <= x"30";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';
		
		--start enc
      regEppAdrOut <= x"01";hosttofpga_data <= x"00";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;
      regEppAdrOut <= x"01";hosttofpga_data <= x"FF";ctlEppDwrOut <= '1';wait for clk_period;ctlEppDwrOut<='0';wait for clk_period;


      wait;
		
   end process;

END;
