library  ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity COUNTER is
	generic(
		WIDTH_CNT: natural;
		MAX_CNT: natural
			);
	port(
		rst: in std_logic;
		clk: in std_logic;
		en: in std_logic;
		clear: in std_logic;
		cnt: out std_logic_vector(WIDTH_CNT-1 downto 0)
		);
end COUNTER;

architecture behavioral of COUNTER is

	signal q: std_logic_vector(WIDTH_CNT-1 downto 0);

begin

	process(rst, clk)
	begin
		if (rst = '1') then
			q <= (others => '0');
		else
			if rising_edge(clk) then
				if (clear = '1') then
					q <= (others => '0');
				elsif (en = '1') then
					if (unsigned(q) = conv_unsigned(MAX_CNT, WIDTH_CNT)) then
						q <= (others => '0');
					else
						q <= unsigned(q) + 1;
					end if;
				end if;
			end if;
		end if;
	end process;

	cnt <= q;
	
end architecture;
