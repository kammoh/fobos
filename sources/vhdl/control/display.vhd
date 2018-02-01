
--##################################################################################
--#                                                                                #
--#	Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
--#	George Mason University							                                   #	
--#   http://cryptography.gmu.edu/fobos                                            #                            
--#                                                   							        #                             	 
--#	Licensed under the Apache License, Version 2.0 (the "License");        	     #
--#	you may not use this file except in compliance with the License.       	     #
--#	You may obtain a copy of the License at                                	     #
--#	                                                                       	     #
--#	    http://www.apache.org/licenses/LICENSE-2.0                         	     #
--#	                                                                       	     #
--#	Unless required by applicable law or agreed to in writing, software    	     #
--#	distributed under the License is distributed on an "AS IS" BASIS,      	     #
--#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     #
--#	See the License for the specific language governing permissions and          #
--#	limitations under the License.                                               #
--#                                                                           	  #
--##################################################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is 
generic (N : integer := 13);
port (
    clk : in std_logic;
    d0, d1, d2, d3  : std_logic_vector(3 downto 0);
    seven_seg : out std_logic_vector(11 downto 0)
);
end display;

architecture Behav of display is 
------------------------------------------------------------------------
-- Constant and Signal Declarations
------------------------------------------------------------------------
signal ancntr : std_logic_vector(1 downto 0);
signal hbcntr : std_logic_vector(N-1 downto 0);
signal cerg_display_temp : std_logic_vector(7 downto 0);
constant logic0 : std_logic := '0';
constant logic1 : std_logic := '1';
signal hb : std_logic := '0';
signal anode_mux : std_logic_vector(3 downto 0);
signal rom_output : std_logic_vector(7 downto 0);
signal addr : std_logic_vector(3 downto 0);
begin
display_rom1 : entity work.display_rom(dataflow)
port map (
	addr => addr,
	dout => rom_output
);
 
------------------------------------------------------------------------
-- Heart-beat Counter for fancy LED blinking
------------------------------------------------------------------------
process (clk)
	begin
	if clk = '1' and clk'Event then
		hbcntr <= hbcntr + 1;
	end if;
	end process;
	
	hb <= hbcntr(N-1);
	
process (hb)
	begin
	if hb = '1' and hb'Event then
		ancntr <= ancntr + 1;
	end if;
	end process;

anode_mux <= "1110" when ancntr = x"0" else
				 "1101" when ancntr = x"1" else
				 "1011" when ancntr = x"2" else
				 "0111" when ancntr = x"3" else
				 "1111";
addr      <= d3 when anode_mux = "0111" else
	          d2 when anode_mux = "1011" else
	          d1 when anode_mux = "1101" else
	          d0 when anode_mux = "1110" else
	          x"F";
							
seven_seg <= anode_mux & rom_output;

end Behav;
