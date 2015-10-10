LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftregDataToPC IS
generic (dataSize: integer := 128);
port
(
clock: in std_logic;
load: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (dataSize-1 downto 0);
sr_output: out std_logic_vector (7 downto 0)

) ;
end shiftregDataToPC;

ARCHITECTURE beh OF shiftregDataToPC IS                                                                                                              
signal temp:std_logic_vector (dataSize-1 downto 0):=(others=>'0');

begin

process(clock,load)
begin                                 
	if(rising_edge(clock))then
		if(load='1') then
    		temp<=sr_input;
		elsif (sr_e = '1') then
			sr_output <= temp(dataSize-1 downto dataSize-8);
			temp(dataSize-1 downto 8) <= temp(dataSize-9 downto 0);
		end if;
	end if;
end process; 

end beh;
