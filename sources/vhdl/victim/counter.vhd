library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_arith.all;

entity counter is  
	generic (N : integer := 4);
	 port(
		 clock : in STD_LOGIC;
		 reset : in STD_LOGIC;	
		 load : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 data_in : in STD_LOGIC_VECTOR(N downto 1);
		 q : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end counter;


architecture count_arch of counter is
signal qtemp : std_logic_vector(N-1 downto 0);

begin
	process(clock)
	begin
	if (clock'event and clock='1') then
		if reset = '1' then
			qtemp <= (others => '0') ; 
		elsif load = '1' then 	
			qtemp <= data_in;
		elsif enable = '1' then
			qtemp <= qtemp - 1;
		end if;
	end if;
end process;
q <= qtemp;

end count_arch;
