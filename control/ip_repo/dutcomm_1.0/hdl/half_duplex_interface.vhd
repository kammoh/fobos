--#############################################################################
--#                                                                           #
--#   Copyright 2019 CERG                                                     #
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_duplex_interface is
	generic(
		MASTER : boolean
	);
	Port(
		--external bus
		shared_handshake_out : out   std_logic;
		shared_handshake_in  : in    std_logic;
		dio_I                : in    std_logic_vector(3 downto 0);
		dio_O                : out   std_logic_vector(3 downto 0);
		dio_T                : out   std_logic;
		direction_out        : out   std_logic;
		--user connection
		---out/in from the view point of the interface user
		handshake0_out       : in    STD_LOGIC;
		handshake1_out       : in    STD_LOGIC;
		handshake0_in        : out   STD_LOGIC;
		handshake1_in        : out   STD_LOGIC;
		--data
		dout                 : in    std_logic_vector(3 downto 0); -- from the user point of view
		din                  : out   std_logic_vector(3 downto 0); -- from the user point of view
		---control
		direction_in         : in    STD_LOGIC -- 0 --for phase0 (ctrl -> dut)-- drived by master

	);
end half_duplex_interface;

architecture behav of half_duplex_interface is

	signal snd : std_logic;             --1 send 0 receive. Master will send in phase0 

begin
	--
	direction_out        <= direction_in;
	---Handshake 
	--mux phase0 and phase1 outgoing handshake signals
	shared_handshake_out <= handshake0_out when direction_in = '0' else handshake1_out;
	---d-mux
	handshake0_in        <= shared_handshake_in when direction_in = '0' else '0';
	handshake1_in        <= shared_handshake_in when direction_in = '1' else '0';
	---data bus

	snd_signal : if MASTER generate
		snd <= not direction_in;        --in phase 0 master is a sender
	end generate;
	snd_signal_slave : if not MASTER generate
		snd <= direction_in;            -- in phase 0 slave is a receiver 
	end generate;

-- add to wrapper
--  signal dio_I: std_logic_vector(3 downto 0);
--  signal dio_O: std_logic_vector(3 downto 0);
--  signal dio_T: std_logic;
--  
--  fc_dio <= dio_O  when dio_T = '1' else (others => 'Z');
--  dio_I  <= fc_dio when dio_T = '0' else (others => '0');

    dio_O <= dout;
    din   <= dio_I;
    dio_T <= snd;

end behav;
