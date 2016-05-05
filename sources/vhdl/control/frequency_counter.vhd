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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fobos_package.all;

entity frequency_counter is
generic (board : integer := NEXYS2);
port (
refclk : in std_logic;
sampleclk : in std_logic;
reset : in std_logic;
frequency_counter_out : out std_logic_vector(31 downto 0));

end frequency_counter;

architecture Behavioral of frequency_counter is
	component counter is
		generic (N : integer := 8);
		port ( 	  
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic; 
			counter_out : out std_logic_vector(N-1 downto 0));
	end component;
		
	 component rege32 IS 
		 PORT (a		 : IN  std_logic_vector(31 downto 0);
				 clk   : IN  std_logic;
				 reset : IN  std_logic;
				 en    : IN  std_logic;            
				 b     : OUT std_logic_vector(31 downto 0));
	end component;

signal refclk_counter_enable : std_logic;
signal refclk_counter_out, sampleclk_counter_out : std_logic_vector(31 downto 0);

begin

CNTL_NEXYS2 : if(board = NEXYS2) generate                                                         
refclk_counter_enable <= '0' when (refclk_counter_out>= x"02FAF080") else '1';
end generate;

CNTL_NEXYS3 : if(board = NEXYS3) generate                                                          
refclk_counter_enable <= '0' when (refclk_counter_out>= x"05F5E100") else '1';
end generate;

refclk_counter : counter generic map (N => 32) port map (clk => refclk, reset => reset,
enable => refclk_counter_enable, counter_out => refclk_counter_out);

sampleclk_counter: counter generic map (N => 32) port map (clk => sampleclk, reset => reset,
enable => refclk_counter_enable, counter_out => sampleclk_counter_out);

frequency_counter_out <= sampleclk_counter_out;

end Behavioral;