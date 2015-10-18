library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_arith.all;
use work.fobos_package.all;

entity integerCounter is  
	 port(
		 clock : in STD_LOGIC;
		 reset : in STD_LOGIC;	
		 load : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 q : out integer range 0 to (maxBlockSize/interfaceWidth)
	     );
end integerCounter;


architecture count_arch of integerCounter is
signal qtemp : integer  range 0 to (maxBlockSize/interfaceWidth);

begin
	process(clock)
	begin
	if (clock'event and clock='1') then
		if reset = '1' then
			qtemp <= 0; 
		elsif enable = '1' then
			qtemp <= qtemp + 1;
		end if;
	end if;
end process;
q <= qtemp;

end count_arch;
