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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dutInterface_4bit is
    Port ( wr : in  STD_LOGIC; --write enable to dut_interface
           rd : in  STD_LOGIC; --read one entry from dut_interface
           rst : in  STD_LOGIC;
			  sys_clk : in  STD_LOGIC;
           dut_clk : in  STD_LOGIC;
			  snd_to_dut : in STD_LOGIC; --signal to start sending data to dut
			  done : out STD_LOGIC; ---- signal indicating operation done and data ready to be read by pc
           di_valid : out  STD_LOGIC;
           di_ready : in  STD_LOGIC;
           do_valid : in  STD_LOGIC;
           do_ready : out  STD_LOGIC;
			  trigger : out  STD_LOGIC;
			  long_trigger : out  STD_LOGIC;
           din : out  STD_LOGIC_VECTOR (3 downto 0); --from dut prespective
           dout : in  STD_LOGIC_VECTOR (3 downto 0); --from dut prespective
           data_to_dut : in  STD_LOGIC_VECTOR (7 downto 0); --from pc
           data_from_dut : out  STD_LOGIC_VECTOR (7 downto 0); --to pc
			  --debug
			  state_debug : out STD_LOGIC_VECTOR(7 downto 0);
			  debug_ram , debug_dout_ram : out 	STD_LOGIC_VECTOR(7 downto 0) ;
			  debug_addr : in 	STD_LOGIC_VECTOR(7 downto 0) ;
			  EppDstb : in  STD_LOGIC;
			  clr_dout_r_cnt : in std_logic
			  );
end dutInterface_4bit;

architecture struct of dutInterface_4bit is

--DIN
constant DIN_ADD_W : integer := 11; --ram address width
constant DIN_W : integer := 8; --ram data bus width width
---
signal din_ram_dout : std_logic_vector(DIN_W - 1 downto 0);
signal din_ram_addr : std_logic_vector(DIN_ADD_W - 1 downto 0);
---
signal din_w_cnt_out : std_logic_vector(DIN_ADD_W -1 downto 0);
signal  din_r_cnt_out : std_logic_vector(DIN_ADD_W downto 0);
signal clr_din_w_cnt, clr_din_r_cnt, en_din_w_cnt, en_din_r_cnt : std_logic;

signal sel_din_addr : std_logic;

--DOUT
constant DOUT_ADD_W : integer := 11; --ram address width
---
signal dout_ram_dout : std_logic_vector(7 downto 0);
signal dout_ram_addr : std_logic_vector(DOUT_ADD_W - 1 downto 0);
---
signal dout_w_cnt_out, dout_r_cnt_out : std_logic_vector(DOUT_ADD_W -1 downto 0);
signal clr_dout_w_cnt, en_dout_w_cnt, en_dout_r_cnt : std_logic;

signal sel_dout_addr : std_logic;
signal wr_dout_ram: std_logic;


begin
----FOR DEBUG ONLY

----
--FSM
dutComm: entity work.dutComm(behav)
port map(
		--To Ctrl_top_level
		clock => dut_clk,
		reset => rst,
		snd_to_dut => snd_to_dut,
		done => done,
		trigger => trigger,
      long_trigger => long_trigger,
		--To dut
		di_ready => di_ready,
	   di_valid => di_valid,
		do_ready => do_ready,
	   do_valid => do_valid,
		---Internal --din ctrl
		en_din_w_cnt => en_din_w_cnt, --enable din ram write counter
		en_din_r_cnt => en_din_r_cnt, --enable din ram read counter
		clr_din_w_cnt => clr_din_w_cnt,
		clr_din_r_cnt => clr_din_r_cnt,
		sel_din_addr => sel_din_addr,
		---Internal --dout ctrl
		en_dout_w_cnt => en_dout_w_cnt, --enable din ram write counter
		en_dout_r_cnt => en_dout_r_cnt, --enable din ram read counter
		clr_dout_w_cnt => clr_dout_w_cnt,
		--clr_dout_r_cnt => clr_dout_r_cnt,
		sel_dout_addr => sel_dout_addr,
		wr_dout_ram => wr_dout_ram,
		---Debug
		state_debug => state_debug
		--rd_dout_fifo : out std_logic
);

--DIN
--- datain ram to store data sent from pc
din_ram : entity work.ram(behav)

	generic map( 
				W => DIN_W,
				ADD_W => DIN_ADD_W --ADDRESS WIDTH
				)
    port map(
			  clk => sys_clk,
           din => data_to_dut,
           dout => din_ram_dout,
           addr => din_ram_addr,
           we => wr,
			 debug_ram => debug_ram,
			  debug_addr => ("000" & debug_addr)
			  
	); 
-- a counter running at the system clock.	
--debug_ram <= din_w_cnt_out(7 downto 0);
din_write_cnt : entity work.counter(Behavioral) 
	generic map( N => DIN_ADD_W)
	port map( 
			clk => sys_clk,
			reset => clr_din_w_cnt,
			enable => wr, 
			counter_out => din_w_cnt_out
   );
 -- a counter running at the dut clock.			
din_read_cnt : entity work.counter(Behavioral)
	generic map( N => (DIN_ADD_W + 1))
	port map( 
			clk => dut_clk,
			reset => clr_din_r_cnt,
			enable => en_din_r_cnt, 
			counter_out => din_r_cnt_out
	);

--din ram address mux
din_ram_addr <= din_w_cnt_out when sel_din_addr = '0' else (din_r_cnt_out(DIN_ADD_W downto 1));
--mux to send 4 bit at a time to dut
din <= din_ram_dout(7 downto 4) when din_r_cnt_out(0) = '0' else din_ram_dout(3 downto 0);
----DOUT	
--- datain ram to store data sent from pc
dout_ram : entity work.dout_ram(behav)
	generic map( 
				ADD_W => DOUT_ADD_W --ADDRESS WIDTH
				)
    port map(
			  clk => dut_clk,
           din => dout,
           dout => data_from_dut,
           addr => dout_ram_addr,
           we => wr_dout_ram,
			  debug_dout_ram => debug_dout_ram,
			  debug_addr => ("000" & debug_addr)

	); 
---a counter running at the system clock.	
dout_write_cnt : entity work.counter(Behavioral) 
	generic map( N => DOUT_ADD_W)
	port map( 
			clk => dut_clk,
			reset => clr_dout_w_cnt,
			enable => wr_dout_ram, 
			counter_out => dout_w_cnt_out
	);
-- a counter running at the dut clock.			
dout_read_cnt : entity work.counter(Behavioral)
	generic map( N => DOUT_ADD_W)
	port map( 
			clk => EppDstb, --sys_clk,--
			reset => clr_dout_r_cnt,-- reset seem to have issues
			enable => rd, 
			counter_out => dout_r_cnt_out
	);
--dout ram address mux
dout_ram_addr <= dout_w_cnt_out when sel_dout_addr = '0' 
          else dout_r_cnt_out(DOUT_ADD_W -2 downto 0) & '0'; --need to jump to byte boundry

end struct;