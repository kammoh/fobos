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

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.fobos_package.all;


entity dutComm is
port(
		--To Ctrl_top_level
		clock : in std_logic; --dutclk
		reset : in std_logic;
		snd_to_dut: in std_logic; --command from pc set to 1 to start sending data to dut. Pc will set this back to zero ONLY after
											--it reads all the result (e.g. ciphertext from the controller. controler will then go back to RESRT state 
		done : out std_logic; -- signals to pc that result is ready 
		trigger : out std_logic;
		long_trigger : out std_logic;
		--To dut
		di_ready : in std_logic;
	   di_valid : out std_logic;
		do_ready : out std_logic;
	   do_valid : in std_logic;
		---Internal--din ctrl
		en_din_w_cnt : out std_logic; --enable ram read counter
		en_din_r_cnt : out std_logic;
		clr_din_w_cnt : out std_logic;
		clr_din_r_cnt : out std_logic;
		sel_din_addr : out std_logic;
		---Internal --dout ctrl
		en_dout_w_cnt : out std_logic; --enable dout ram write counter
		en_dout_r_cnt: out std_logic; --enable dout ram read counter
		clr_dout_w_cnt : out std_logic;
		clr_dout_r_cnt : out std_logic;
		sel_dout_addr : out std_logic;
		wr_dout_ram : out std_logic;
		---Debug
		state_debug : out std_logic_vector(7 downto 0)
		--rd_dout_fifo : out std_logic
);
end dutComm;
		
architecture behav of dutComm is 

type STATE is (S_RESET, S_WAIT_PC_DATA, S_START_READING, S_SEND_DATA, 
						S_WAIT_FOR_DOUT, S_GET_DATA, S_WAIT_FOR_PC_READ); 
signal current_state,next_state:state;


begin
state_reg:	process (clock)
begin
	if(rising_edge(clock)) then
		if (reset='1') then
			current_state <= S_RESET;
		else
			current_state<=next_state;
		end if;
	end if;
end process;

process(current_state,di_ready, do_valid, snd_to_dut)
begin
--default outputs
di_valid <= '0';
do_ready <= '0';
trigger <= '0';
long_trigger <= '0';
--internal din ctrl
en_din_w_cnt  <= '0';
en_din_r_cnt <= '0';
clr_din_w_cnt <= '0';
clr_din_r_cnt <= '0';
sel_din_addr <= '0';
state_debug <= x"00";
--internal dout ctrl
en_dout_w_cnt <= '0';
en_dout_r_cnt <= '0';
clr_dout_w_cnt <= '0';
clr_dout_r_cnt <= '0';
sel_dout_addr <= '0';
wr_dout_ram <= '0';
--
done <= '0';		
		
case current_state is
   when S_RESET =>
		next_state <= S_WAIT_PC_DATA;
		state_debug <= x"01";
		clr_din_r_cnt <= '1';
		clr_din_w_cnt<= '1';
		clr_dout_r_cnt <= '1';
		clr_dout_w_cnt<= '1';
		
	when S_WAIT_PC_DATA =>
		state_debug <= x"02";

		if (snd_to_dut = '1') then
			next_state <= S_SEND_DATA;
		else
			next_state <= S_WAIT_PC_DATA;
		end if;	

	when S_SEND_DATA =>
		state_debug <= x"04";
		sel_din_addr <= '1';
		if (di_ready = '1') then --
			en_din_r_cnt <= '1';
			di_valid <= '1';
			next_state <= S_SEND_DATA;
		else
			trigger <= '1';
			long_trigger <= '1';
			next_state <= S_WAIT_FOR_DOUT;
		end if;
		
   when S_WAIT_FOR_DOUT =>
	   state_debug <= x"05";
	   do_ready <= '1';
		if(do_valid = '1') then
			wr_dout_ram <= '1';
			next_state <= S_GET_DATA;
		else
		   long_trigger <= '1';
			next_state <= S_WAIT_FOR_DOUT;
		end if;
		
	when S_GET_DATA =>
	   state_debug <= x"06";
	   do_ready <= '1';
		if (do_valid = '1') then
			wr_dout_ram <= '1';
			next_state <= S_GET_DATA;
		else
			next_state <= S_WAIT_FOR_PC_READ;
		end if;

	when S_WAIT_FOR_PC_READ => -- stay here until pc says
	   state_debug <= x"07";
		done <= '1'; --tell pc that data is ready toread
		sel_dout_addr <= '1';
		if (snd_to_dut = '1') then --pc will set this flag to zero after reading all data
			next_state <= S_WAIT_FOR_PC_READ;
		else
			next_state <= S_RESET;
		end if;
	
	when others =>
	   state_debug <= x"08";
		next_state <= S_RESET;

end case;
end process;
end behav;
