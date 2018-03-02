--------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
--
-- Create Date:   09:24:01 07/31/2017
-- Design Name:   
-- Module Name:   C:/Users/aabdulgadir/Documents/Spring2017/fobos_new/fobos_ctrl_new/dutInterfaceTb.vhd
-- Project Name:  fobos_ctrl_new
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dutInterface
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE ieee.std_logic_textio.all;

LIBRARY std;
USE std.textio.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY dutInterfaceTb IS
END dutInterfaceTb;
 
ARCHITECTURE behavior OF dutInterfaceTb IS 
    FILE inFile: TEXT OPEN READ_MODE is "C:\Users\bakry\Documents\project\fobos_ctrl_v1\fobos_dut_4_0_export\dinFile3.txt";

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dutInterface
    PORT(
         wr : IN  std_logic;
         rd : IN  std_logic;
         rst : IN  std_logic;
         dut_clk : IN  std_logic;
         start_snd : IN  std_logic;
         di_valid : OUT  std_logic;
         di_ready : IN  std_logic;
         do_valid : IN  std_logic;
         do_ready : OUT  std_logic;
         din : OUT  std_logic_vector(15 downto 0);
         dout : IN  std_logic_vector(15 downto 0);
         data_to_dut : IN  std_logic_vector(15 downto 0);
         data_from_dut : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	 

    

   --Inputs
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal start_snd : std_logic := '0';
   signal di_ready : std_logic := '0';
   signal do_valid : std_logic := '0';
   signal dout : std_logic_vector(15 downto 0) := (others => '0');
   signal data_to_dut : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal di_valid : std_logic;
   signal do_ready : std_logic;
   signal din : std_logic_vector(15 downto 0);
   signal data_from_dut : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: dutInterface PORT MAP (
          wr => wr,
          rd => rd,
          rst => rst,
          dut_clk => clk,
          start_snd => start_snd,
          di_valid => di_valid,
          di_ready => di_ready,
          do_valid => do_valid,
          do_ready => do_ready,
          din => din,
          dout => dout,
          data_to_dut => data_to_dut,
          data_from_dut => data_from_dut
        );
		  
    DUT : entity work.FOBOS_DUT(structural)
	 generic map(
		N => 16, W => 16, SW => 16)
	 port map( 
	  clk => clk, 
	  rst => rst,
	  di_valid => di_valid,
	  do_ready => do_ready,
	  din => din, 
	  di_ready => di_ready,
	  do_valid => do_valid,
	  dout => dout
	 );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	 

   readVec: PROCESS

   VARIABLE VectorLine: LINE;
   VARIABLE VectorValid: BOOLEAN;
   VARIABLE x:    STD_LOGIC_VECTOR(15 DOWNTO 0);
   VARIABLE space: CHARACTER;

	BEGIN
   wr <= '0';
	rd <= '0';
   wait for clk_period * 4;
      
        if (not endfile(inFile)) then
            readline(inFile, VectorLine);
            hread(VectorLine, x, good => VectorValid);
				--send 16 bits
				data_to_dut <= x;
				wr <= '1';
				wait for clk_period * 4;
				wr <= '0';
				wait for clk_period * 4;
			else
				--file ended , send start_snd
				start_snd <= '1';
				wait for clk_period * 4;
				start_snd <= '0';
				
				----get data back
				wait for clk_period * 80;
				rd <='1';
				wait for clk_period * 4;
				rd <='0';
				--------
				wait for clk_period * 4;
				rd <='1';
				wait for clk_period * 4;
				rd <='0';
				--------
				wait for clk_period * 4;
				rd <='1';
				wait for clk_period * 4;
				rd <='0';
				--------
				wait for clk_period * 4;
				rd <='1';
				wait for clk_period * 4;
				rd <='0';
								
				

				
				
			end if;
	
	ASSERT VectorValid
	Report "Vector Not Valid"
	SEVERITY ERROR;
	wait for clk_period*4;

	end process;   

END;