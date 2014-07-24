library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frequency_counter is
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
                                                          
refclk_counter_enable <= '0' when (refclk_counter_out>= x"05F5E100") else '1';

refclk_counter : counter generic map (N => 32) port map (clk => refclk, reset => reset,
enable => refclk_counter_enable, counter_out => refclk_counter_out);

sampleclk_counter: counter generic map (N => 32) port map (clk => sampleclk, reset => reset,
enable => refclk_counter_enable, counter_out => sampleclk_counter_out);

frequency_counter_out <= sampleclk_counter_out;

end Behavioral;