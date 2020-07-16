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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ram_tb IS
END ram_tb;
 
ARCHITECTURE behavior OF ram_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ram
    PORT(
         clk : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0);
         addr : IN  std_logic_vector(11 downto 0);
         we : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal addr : std_logic_vector(11 downto 0) := (others => '0');
   signal we : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ram PORT MAP (
          clk => clk,
          din => din,
          dout => dout,
          addr => addr,
          we => we
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		din <= x"11";
		we <= '1';
		addr <= x"000";
		wait for clk_period;
		din <= x"22"; 
		we <= '1';
		addr <= x"001";
		wait for clk_period;
		we <= '0';
		wait for clk_period *3;
		addr <= x"000";
		wait for clk_period;
		addr <= x"001";
		
      wait;
   end process;

END;
