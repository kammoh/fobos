library  ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.my_utils.all;

entity CLK_DIV is
	generic(
		DIV_AMT: natural	-- Divisor value, should be even to ensure proper divison amount
			);
	port(
		rst: in std_logic;
		clk: in std_logic;
		rst_div: in std_logic;
		en_div: in std_logic;
		clk_div: out std_logic
		);
end CLK_DIV;

architecture behavioral of CLK_DIV is

	signal q: std_logic_vector(log2(DIV_AMT)-1 downto 0);
	
begin
	process(rst, clk)
	begin
		if (rst = '1') then
			q <= (others => '0');
			clk_div <= '0';
		else
			if rising_edge(clk) then
				if (rst_div = '1') then 
					q <= (others => '0');
					clk_div <= '0';
				elsif (en_div = '1') then
					if (unsigned(q) = conv_unsigned(DIV_AMT, log2(DIV_AMT))-1) then
						q <= (others => '0');
						clk_div <= '1';
					else
						q <= unsigned(q) + 1;
						clk_div <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;

end architecture;

