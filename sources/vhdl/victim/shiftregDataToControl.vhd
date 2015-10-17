LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftregDataToControl IS
generic( interfaceSize : integer := 4;
		dataSize: integer:= 128);
port
(
clock: in std_logic;
load: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (dataSize-1 downto 0);
sr_output: out std_logic_vector (interfaceSize-1 downto 0)

) ;
end shiftregDataToControl;

ARCHITECTURE beh OF shiftregDataToControl IS                                                                                                              
signal temp:std_logic_vector (dataSize-1 downto 0):=(others=>'0');

begin

process(clock,load)
begin                                 
	if(rising_edge(clock))then
		if(load='1') then
    		temp<=sr_input;
		elsif (sr_e = '1') then
			sr_output <= temp(dataSize-1 downto dataSize-interfaceSize);
			temp(dataSize-1 downto interfaceSize) <= temp(dataSize-interfaceSize-1 downto 0);
		end if;
	end if;
end process; 

end beh;
