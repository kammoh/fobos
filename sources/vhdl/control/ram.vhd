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
use IEEE.NUMERIC_STD.ALL;
entity ram is
	Generic( W : integer := 8;
				ADD_W : integer := 11 --ADDRESS WIDTH
				);
    Port ( clk : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (W - 1 downto 0);
           dout : out  STD_LOGIC_VECTOR (W - 1 downto 0);
           addr : in  STD_LOGIC_VECTOR (ADD_W -1 downto 0);
           we : in  STD_LOGIC;
			  debug_ram : out STD_LOGIC_VECTOR (W - 1 downto 0);
			  debug_addr : in  STD_LOGIC_VECTOR (ADD_W -1 downto 0)
			 
			  );
end ram;

architecture Behav of ram is

type ram_array is array(0 to 2**ADD_W - 1 ) of STD_LOGIC_VECTOR(W - 1 downto 0);
signal my_ram : ram_array;
begin
--process (clk, regEppAdrOut, ctlEppDwrOut, din)
process(clk)
begin
	if rising_edge(clk) then
	   --if ctlEppDwrOut = '1' and regEppAdrOut = x"7A" then
		if we = '1' then
			my_ram(to_integer(unsigned(addr))) <= din;
		end if;
	end if;
end process;

dout <= my_ram(to_integer(unsigned(addr)));
debug_ram <= my_ram(to_integer(unsigned(debug_addr)));
	


end Behav;

