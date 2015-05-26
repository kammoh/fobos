LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftreg_8x128 IS
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (7 downto 0);
sr_output: out std_logic_vector (127 downto 0)

) ;
end shiftreg_8x128;

ARCHITECTURE beh OF shiftreg_8x128 IS                                                                                                              
signal temp:std_logic_vector (127 downto 0):=(others=>'0');

begin

process(clock,reset)
begin                                 
	if(rising_edge(clock))then
		if(reset='1') then
    		temp<=(others=>'0');
		elsif (sr_e = '1') then
     		temp(127 downto 8) <= temp(119 downto 0) ;
	 		temp(7 downto 0) <= sr_input;
		end if;
	end if;
end process; 
sr_output <= temp; 

end beh;
