----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Bakr Abdulgadir
-- 
-- Create Date:    11:39:04 08/22/2016 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
	generic (N : integer := 8);
    Port ( enable : in  STD_LOGIC;
           load : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (N - 1 downto 0);
			  D : in   STD_LOGIC_VECTOR (N - 1 downto 0);
           clk : in  STD_LOGIC);
end counter;

architecture behav of counter is
	signal count : STD_LOGIC_VECTOR (N - 1 downto 0);
begin
	process(clk, load)
	begin
		if load = '1' then
			count <= D;
		else 
			if rising_edge(clk) then
				if enable = '1' then
					count <= count + 1;
				end if;
			end if;
		end if;
	
	end process;
	Q <= count;
end behav;

