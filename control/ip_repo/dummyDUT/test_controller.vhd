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

--! Auxiliary controller for fobos_dut_tb

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity test_controller is
	PORT(clk, rst    : in  std_logic;
	     do_valid    : in  std_logic;
	     writestrobe : out std_logic
	    );
end test_controller;

architecture behavioral of test_controller is
	type state is (ST1, ST2);
	signal current_state : state;
	signal next_state    : state;
begin

	sync_process : process(clk)
	begin
		IF (rising_edge(clk)) THEN
			if (rst = '1') then
				current_state <= ST1;
			else
				current_state <= next_state;
			END if;

		END IF;

	end process;

	test_process : process(current_state, do_valid)
	begin
		-- defaults

		writestrobe <= '0';

		case current_state is

			when ST1 =>
				if (do_valid = '1') then
					next_state <= ST2;
				end if;

			when ST2 =>
				if (do_valid = '0') then
					writestrobe <= '1';
					next_state  <= ST1;
				end if;

			WHEN OTHERS =>

				next_state <= ST1;

		end case;

	END process;

END behavioral;
