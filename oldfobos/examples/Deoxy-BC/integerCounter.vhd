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
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_arith.all;
use work.fobos_package.all;

entity integerCounter is  
	 port(
		 clock : in STD_LOGIC;
		 reset : in STD_LOGIC;	
		 load : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 q : out integer range 0 to (maxBlockSize/interfaceWidth)	     );
end integerCounter;


architecture count_arch of integerCounter is
signal qtemp : integer  range 0 to (maxBlockSize/interfaceWidth);

begin
	process(clock)
	begin
	if (clock'event and clock='1') then
		if reset = '1' then
			qtemp <= 0; 
		elsif enable = '1' then
			qtemp <= qtemp + 1;
		end if;
	end if;
end process;
q <= qtemp;

end count_arch;
