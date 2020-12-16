-- Shaunak


library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_arith.all;

entity upcount is  
	generic (N : integer := 4);
	 port(
		 clock : in STD_LOGIC;
		 l : in STD_LOGIC;
		 e : in STD_LOGIC;
		-- data_in : in STD_LOGIC_VECTOR(N downto 1);
		 q : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end upcount;


architecture upcount_arch of upcount is
signal qtemp : std_logic_vector(N-1 downto 0);

begin
	process(clock)
	begin
	if (clock'event and clock='1') then
		if l = '1' then
			qtemp <= (others => '0') ; 
			--qtemp <= qtemp + 1;
		elsif e = '1' then
			qtemp <= qtemp + 1;
		end if;
	end if;
end process;
q <= qtemp;

end upcount_arch;
