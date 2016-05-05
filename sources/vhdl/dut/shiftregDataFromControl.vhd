--##################################################################################
--#                                                                                #
--# Copyright 2016 Cryptographic Engineering Research Group (CERG)                 #
--# George Mason University                                                        #    
--#   http://cryptography.gmu.edu/fobos                                            #                            
--#                                                                                #                                
--# Licensed under the Apache License, Version 2.0 (the "License");                #
--# you may not use this file except in compliance with the License.               #
--# You may obtain a copy of the License at                                        #
--#                                                                                #
--#     http://www.apache.org/licenses/LICENSE-2.0                                 #
--#                                                                                #
--# Unless required by applicable law or agreed to in writing, software            #
--# distributed under the License is distributed on an "AS IS" BASIS,              #
--# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.       #
--# See the License for the specific language governing permissions and            #
--# limitations under the License.                                                 #
--#                                                                                #
--##################################################################################


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftregDataFromControl IS
generic( interfaceSize : integer := 4;
        dataSize: integer:= 128);
    port
    (
        clock    : in std_logic;
        reset    : in std_logic;
        sr_e     : in std_logic;
        sr_input : in std_logic_vector (interfaceSize-1 downto 0);
        sr_output: out std_logic_vector (dataSize-1 downto 0)

    ) ;
end shiftregDataFromControl;

ARCHITECTURE beh OF shiftregDataFromControl IS                                                                                                              
signal temp:std_logic_vector (dataSize-1 downto 0):=(others=>'0');

begin

process(clock,reset)
begin                                 
    if(rising_edge(clock))then
        if(reset='1') then
            temp<=(others=>'0');
        elsif (sr_e = '1') then
            temp(dataSize-1 downto interfaceSize) <= temp(dataSize-interfaceSize-1 downto 0) ;
            temp(interfaceSize-1 downto 0) <= sr_input;
        end if;
    end if;
end process; 
sr_output <= temp; 

end beh;
