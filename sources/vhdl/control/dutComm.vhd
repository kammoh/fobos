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
use work.fobos_package.all;

entity dutCommunicationHandler is 
	port(
	     clock: in std_logic;
		 start : in std_logic;
		 reset: in std_logic;	 
		 targetClock : in std_logic;
		 src_read  : in std_logic;
		 dst_write : in std_logic;
		 databusHandle : out std_logic; -- data/key to dut selection line
		 vdlRst : out std_logic; -- dut TO Data load 
		 vdlEnb : out std_logic; -- dut TO Data enable
		 vklRst : out std_logic; -- dut TO Key load
		 vklEnb : out std_logic; -- dut TO Key load		 
		 vrRst : out std_logic; -- dut FROM data load
		 vrEnb : out std_logic; -- dut FROM data enable
		 src_ready : out std_logic;
		 stateMachineStatus: out std_logic_vector(7 downto 0); -- For debug purpose
		 dst_ready : out std_logic;
                 encStart : out std_logic		 
		 );
end dutCommunicationHandler;


architecture structure of dutCommunicationHandler is
type state is (boot, init1, st1, st2, st3, st3a, st4, st5); 
signal pr_state,nx_state:state;

signal load_cnt_key, enb_cnt_key, load_cnt_data, enb_cnt_data, load_cnt_ct, enb_cnt_ct : std_logic;
signal data_set, key_set, ct_set : std_logic;  
signal dataBlockSize, keyBlockSize, vDataBlockSize : integer RANGE 0 to (maxBlockSize/interfaceWidth);

begin
	
------------------------ Control signals to dut Controller------------
counterInputkey : integerCounter port map(clock => clock, reset => reset, load => load_cnt_key, enable => enb_cnt_key, q => keyBlockSize);
key_set <= '1' when  keyBlockSize >= (maxKeySize/interfaceWidth) else '0';

counterInputdata : integerCounter port map(clock => clock, reset => reset, load => load_cnt_data, enable => enb_cnt_data, q => dataBlockSize);
data_set <= '1' when  dataBlockSize >= (maxBlockSize/interfaceWidth) else '0';

counterOutputData : integerCounter port map(clock => clock, reset => reset, load => load_cnt_ct, enable => enb_cnt_ct, q => vDataBlockSize);	
ct_set <= '1' when vDataBlockSize >= (maxBlockSize/interfaceWidth) else '0';

-----------------------------------------------------------------------------------	
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=boot;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-------------------------------------------------------------------------------------
next_state_function: process(clock,src_read,key_set,data_set, dst_write, ct_set, start, pr_state)
  begin
	  case pr_state is
		  when boot =>
		  if(start = '0') then
		  nx_state <= boot;
		  else
		  nx_state <= init1;
		  end if;
		  when init1 =>
		  if (src_read = '0') then
		  nx_state <= init1;
		  else
		  nx_state <= st1;
		  end if;

		  when st1 =>
		  if (key_set = '0') then	
			  nx_state <= st1;
		  else
			  nx_state<= st2;
		  end if;

		  when st2 =>
		  if (data_set = '0') then	
			  nx_state <= st2;
		  else
			  nx_state<= st3a;
		  end if;
		  
                  when st3a =>
		  if (dst_write = '0') then
			  nx_state <= st3;
		  else 
			  nx_state <= st4;
		  end if;
		  
		  when st3 => 
		  if (dst_write = '0') then
			  nx_state <= st3;
		  else 
			  nx_state <= st4;
		  end if;
		  
		  when st4 =>
		  if (ct_set='0') then
				nx_state <= st4;
		  else
				nx_state <= st5;
		  end if;
		  when st5 =>
		  if (start='1') then
				nx_state <= st5;
		  else
				nx_state <= boot;
		  end if;		  
		end case;
end process; 
------------------------------------------------------------------------
 output_function: process(pr_state)
 begin	 
   src_ready <= '0';dst_ready <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
		databusHandle <= '0'; encStart <= '0';
	case pr_state is 
		 when boot =>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1';load_cnt_ct <= '1';enb_cnt_ct <= '0'; databusHandle <= '0';
		 enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '1'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 stateMachineStatus <= x"09";
		 when init1 =>
		 src_ready <= '1'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '0'; databusHandle <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '1'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 stateMachineStatus <= x"02";
		 when st1 => 
		 src_ready <= '1'; load_cnt_key <= '0'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '1';dst_ready <= '0'; databusHandle <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '1'; vrRst <= '1'; vrEnb <= '0';
		 stateMachineStatus <= x"03";
		 when st2 =>		 
	 	 src_ready <= '1'; load_cnt_key <= '1'; load_cnt_data <= '0'; enb_cnt_data<= '1'; enb_cnt_key<= '0';dst_ready <= '0'; databusHandle <= '1';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '1'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 stateMachineStatus <= x"04";
		 when st3a=>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1'; databusHandle <= '1';	 
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0'; encStart <= '1';
		 stateMachineStatus <= x"09";
		 when st3=>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1'; databusHandle <= '1';	 
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 stateMachineStatus <= x"05";
		 when st4=>		  
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1'; databusHandle <= '1';	 
		 load_cnt_ct <= '0';enb_cnt_ct <= '1';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '1';
		 stateMachineStatus <= x"06";
		 when st5=>		  
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1'; databusHandle <= '1';	 
		 load_cnt_ct <= '0';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
		 stateMachineStatus <= x"07";
		 when others =>
		 stateMachineStatus <= x"08";
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0'; dst_ready <= '0'; databusHandle <= '1';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
	end case;
end process;


end structure; 
