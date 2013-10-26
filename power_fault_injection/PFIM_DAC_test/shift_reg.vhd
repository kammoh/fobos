----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:02:43 10/19/2013 
-- Design Name: 
-- Module Name:    shift_reg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SHIFT_REG is
	generic(
		DEPTH: natural
			);
	port(rst : in  STD_LOGIC;
			clk : in  STD_LOGIC;
			en : in STD_LOGIC;
			din : in  STD_LOGIC;
			dout : out  STD_LOGIC);
end SHIFT_REG;

architecture Behavioral of SHIFT_REG is
	
	signal q: std_logic_vector(DEPTH-1 downto 0);

begin

	process(rst, clk)
	begin
		if (rst = '1') then
			q <= (others => '0');
		else
			if rising_edge(clk) then
				if (en = '1') then
					q <= q(DEPTH-2 downto 0) & din;
				end if;
			end if;
		end if;
	end process;

	dout <= q(DEPTH-1);

end Behavioral;

