----------------------------------------------------------------------------------
-- Company: GMU 
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    11:55:28 9/26/2016
-- Design Name: 
-- Module Name:    reg128 - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg128_bit is
    Port ( D : in STD_LOGIC_VECTOR(127 downto 0);
           Q : out  STD_LOGIC_VECTOR(127 downto 0);
           clk : in  STD_LOGIC;
			  enable : in STD_LOGIC);
end reg128_bit;

architecture behav of reg128_bit is

begin
	process(clk)
	begin
	if rising_edge(clk) then
			if enable = '1' then
				Q <= D;
			end if;
	end if;
	end process;
end behav;

