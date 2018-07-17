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
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY display_rom IS
PORT (
Addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END display_rom;
ARCHITECTURE dataflow OF display_rom IS
SIGNAL temp: INTEGER RANGE 0 TO 15;
TYPE vector_array IS ARRAY (0 to 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT memory : vector_array :=
(  "11000000",
	"11001111",
	"10100100",
	"10110000",
	"10011001",
	"10010010",
	"10000010",
	"11111000",
	"10000000",
	"10010000",
	"10001000",
	"10000011",
	"11000110",
	"10100001",
   "10110000",
	"10001110"
	);
BEGIN
temp <= to_integer(unsigned(Addr));
Dout <= memory(temp);
END dataflow;
