--Shaunak Shah

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_arith.all;

entity registern is		 
	 generic (N : integer := 128);
	 port(
		 clock : in STD_LOGIC;
		 la : in STD_LOGIC;
		 data_in : in STD_LOGIC_VECTOR(0 to N-1);
		 q : out STD_LOGIC_VECTOR(0 to N-1)
	     );	

end registern;

architecture registern_arch of registern is	
	--
begin
	process(clock)
	begin
	--	q <= (others => '0')  ;
		if (clock'event and clock = '1') then
			if la = '1' then
				q <= data_in ;
			end if;
		end if;
	end process;
end registern_arch;
