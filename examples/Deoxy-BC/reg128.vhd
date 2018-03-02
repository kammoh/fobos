----------------------------------------------------------------------------------
-- Company: GMU 
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    11:55:28 11/08/2015 
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
use work.AES_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg128 is
    Port ( D : in t_AES_state;
           Q : out  t_AES_state;
           clk : in  STD_LOGIC;
			  enable : in STD_LOGIC);
end reg128;

architecture behav of reg128 is

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

