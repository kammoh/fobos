----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:26 05/25/2012 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bram_add_counter is
	generic ( 
	    N : integer := 32
	);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
--	   load : in std_logic;
	   enable : in std_logic;
       we_enable : in std_logic;	   
--		input  : in std_logic_vector(N-1 downto 0);
      counter_out : out std_logic_vector(N-1 downto 0)
	);
end bram_add_counter;

architecture Behavioral of bram_add_counter is
	signal en_temp : std_logic;
	signal temp : std_logic_vector(N-1 downto 0);
	
begin
	en_temp <= enable and we_enable;
	
	counting : process( clk, reset )
	begin
		if reset = '1' then
			temp <= (others => '0');
		elsif rising_edge( clk ) then
--			if (load = '1' ) then
--				temp <= input;
--			els
			if ( en_temp = '1' ) then
				temp <=  unsigned(temp) + 1 ;
			end if;
		end if;
	end process;  
	counter_out <= temp;
	
end Behavioral;

