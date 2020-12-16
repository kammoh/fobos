--##############################################################################
--#                                                                            #
--#	Copyright 2018 Cryptographic Engineering Research Group (CERG)           #
--#	George Mason University							                         #	
--#   http://cryptography.gmu.edu/fobos                                        #                            
--#									                                         #
--#	Licensed under the Apache License, Version 2.0 (the "License");        	 #
--#	you may not use this file except in compliance with the License.       	 #
--#	You may obtain a copy of the License at                                	 #
--#	                                                                       	 #
--#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
--#	                                                                       	 #
--#	Unless required by applicable law or agreed to in writing, software    	 #
--#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
--#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
--#	See the License for the specific language governing permissions and      #
--#	limitations under the License.                                           #
--#                                                                          	 #
--##############################################################################
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
 
ENTITY dutInterface_4bit_tb IS
END dutInterface_4bit_tb;
 
ARCHITECTURE behavior OF dutInterface_4bit_tb IS 
    FILE inFile: TEXT OPEN READ_MODE is "/nhome/aabdulga/project/fobos_ctrl_4/fobos_dut_4_0_export/dinFile3_new.txt";

    -- Component Declaration for the Unit Under Test (UUT)

	 

    

   --Inputs
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';
   signal rst : std_logic := '0';
   signal sys_clk, dut_clk : std_logic := '0';
   signal snd_to_dut : std_logic := '0';
   signal di_ready : std_logic := '0';
   signal do_valid : std_logic := '0';
   signal dout : std_logic_vector(3 downto 0) := (others => '0');
   signal data_to_dut : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal di_valid : std_logic;
	signal done,trigger,pc_read_done : std_logic;
   signal do_ready : std_logic;
   signal din : std_logic_vector(3 downto 0);
   signal data_from_dut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant sclk_period : time := 10 ns;
	constant dclk_period : time := 35 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.dutInterface_4bit(struct) PORT MAP (
         wr => wr,
           rd => rd,
           rst => rst,
			  sys_clk => sys_clk,
           dut_clk => dut_clk,
			  snd_to_dut => snd_to_dut,
			  done => done,
           di_valid => di_valid,
           di_ready => di_ready,
           do_valid => do_valid,
           do_ready => do_ready,
			  trigger => trigger,
           din => din,
           dout => dout,
           data_to_dut => data_to_dut,
           data_from_dut => data_from_dut,
			 debug_addr => (others => '0'),
			 EppDstb => '0'
			  );
		  
		  
    DUT : entity work.FOBOS_DUT(structural)
	 generic map(
		W => 32, SW => 32)
	 port map( 
	  clk => dut_clk, 
	  rst => rst,
	  di_valid => di_valid,
	  do_ready => do_ready,
	  din => din, 
	  di_ready => di_ready,
	  do_valid => do_valid,
	  dout => dout
	 );

   -- Clock process definitions
	reset_process :process
   begin
		rst <= '1';
		wait for 4 * sclk_period;
		rst <= '0';
		wait;
   end process;
	
   sys_clk_process :process
   begin
		sys_clk <= '0';
		wait for sclk_period/2;
		sys_clk <= '1';
		wait for sclk_period/2;
   end process;
	 
	dut_clk_process: process
	begin
		dut_clk <= '0';
		wait for dclk_period/2;
		dut_clk <= '1';
		wait for dclk_period/2;
	end process;

   readVec: PROCESS

   VARIABLE VectorLine: LINE;
   VARIABLE VectorValid: BOOLEAN;
   VARIABLE x:    STD_LOGIC_VECTOR(15 DOWNTO 0);
   VARIABLE space: CHARACTER;

	BEGIN
   wr <= '0';
	rd <= '0';
   wait for sclk_period * 6;
      
        if (not endfile(inFile)) then
            readline(inFile, VectorLine);
            hread(VectorLine, x, good => VectorValid);
				--send 16 bits
				--lsb
				data_to_dut <= x(15 downto 8);
				wr <= '1';
				wait for sclk_period;
				wr <= '0';
				wait for sclk_period * 2;
				--lsb
				data_to_dut <= x(7 downto 0);
				wr <= '1';
				wait for sclk_period;
				wr <= '0';
				wait for sclk_period * 2;
			else
				--file ended , send start_snd
				snd_to_dut <= '1';
				wait for sclk_period * 4;
			   
				
				----get data back
				wait until done = '1';
				
				--Now, read result from ctrl
				for i in 0 to 8 loop
					rd <= '1';
					wait for sclk_period;
					rd <= '0';
					wait for sclk_period *2; --pc dealy to read next byte
				end loop;
								
				wait;

				
				
			end if;
	
	ASSERT VectorValid
	Report "Vector Not Valid"
	SEVERITY ERROR;
	wait for sclk_period*4;

	end process;   

END;