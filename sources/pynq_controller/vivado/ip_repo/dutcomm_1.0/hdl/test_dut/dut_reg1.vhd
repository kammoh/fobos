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

--! 1-bit register designed for FOBOS_DUT

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dut_reg1 IS
	PORT(D : IN STD_LOGIC;
	     CLK  : IN STD_LOGIC;
         EN   : IN STD_LOGIC;
	     Q    : OUT STD_LOGIC:='0');
END dut_reg1;

ARCHITECTURE behavioral OF dut_reg1 IS
BEGIN
	PROCESS (CLK)
        BEGIN
            
            IF rising_edge(CLK) THEN
              if (EN = '1') then
                  Q <= D;
                
              end if;
	    end if;
        END PROCESS;
END behavioral;
