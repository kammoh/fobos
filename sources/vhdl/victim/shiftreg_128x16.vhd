LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftreg_128x16 IS
port
(
clock: in std_logic;
reset: in std_logic; 
sr_l : in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (127 downto 0);
sr_output: out std_logic_vector (15 downto 0)

) ;
end shiftreg_128x16;

ARCHITECTURE beh OF shiftreg_128x16 IS                                                                                                              
signal temp:std_logic_vector (127 downto 0):=(others=>'0');

begin

process(clock,reset)
begin                                 
	if(rising_edge(clock))then
		if(reset='1') then
    		temp<=(others=>'0');
		elsif (sr_l = '1') then
			temp <= sr_input;
		elsif (sr_e = '1') then
			sr_output <= temp(127 downto 112);
			temp(127 downto 16) <= temp(111 downto 0);
		end if;
	end if;
end process; 


end beh;
