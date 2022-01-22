 --#############################################################################
--#                                                                           #
--#   Copyright 2021 CERG                                                     #
--#                                                                           #
--#   Licensed under the Apache License, Version 2.0 (the "License");         #
--#   you may not use this file except in compliance with the License.        #
--#   You may obtain a copy of the License at                                 #
--#                                                                           #
--#       http://www.apache.org/licenses/LICENSE-2.0                          #
--#                                                                           #
--#   Unless required by applicable law or agreed to in writing, software     #
--#   distributed under the License is distributed on an "AS IS" BASIS,       #
--#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
--#   See the License for the specific language governing permissions and     #
--#   limitations under the License.                                          #
--#                                                                           #
--#############################################################################
-- DUT select module
-- modifies signal assigment on target connector based on dut
-- this is unfortunately necessary as we want to maintain compatibility with the
-- chip whisperer target connector and add functionality

library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity targetswitch is
    port (
        serial_en       : in  std_logic;
        serial_tx       : in  std_logic;
        serial_rx       : out std_logic;
        dio_I           : in  std_logic_vector(3 downto 0);
	    dio_O           : out std_logic_vector(3 downto 0);
	    dio_T           : out std_logic_vector(3 downto 0);
	    dio_out         : in  std_logic_vector(3 downto 0);
	    dio_dir         : in  std_logic_vector(3 downto 0);
        dut_working     : out std_logic;
        dut_busy        : in  std_logic
    );
end targetswitch;
