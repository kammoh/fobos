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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dout_ram is
	Generic( ADD_W : integer :=  11); --address width
    Port ( clk : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (3 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0);
           addr : in  STD_LOGIC_VECTOR (ADD_W -1 downto 0);
           we : in  STD_LOGIC;
			  debug_addr : in  STD_LOGIC_VECTOR (ADD_W -1 downto 0);
			  debug_dout_ram : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end dout_ram;

architecture Behav of dout_ram is

type ram_array is array(0 to 2**ADD_W - 1 ) of STD_LOGIC_VECTOR(3 downto 0);
signal my_ram : ram_array;
begin

process(clk)
begin
	if rising_edge(clk) then
		if we = '1' then
			my_ram(to_integer(unsigned(addr))) <= din;
		end if;
	end if;
end process;

dout <=   my_ram(to_integer(unsigned(addr))) & my_ram(to_integer(unsigned(addr + 1)));
debug_dout_ram <=   my_ram(to_integer(unsigned(debug_addr))) & my_ram(to_integer(unsigned(debug_addr + 1)));

	


end Behav;

