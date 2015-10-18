LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY shiftregDataFromVictim IS
generic( interfaceSize : integer := 4;
		dataSize: integer:= 128);
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (interfaceSize-1 downto 0);
sr_output: out std_logic_vector (dataSize-1 downto 0)

) ;
end shiftregDataFromVictim;

ARCHITECTURE beh OF shiftregDataFromVictim IS                                                                                                              
signal temp:std_logic_vector (dataSize-1 downto 0):=(others=>'0');

begin

process(clock,reset)
begin                                 
	if(rising_edge(clock))then
		if(reset='1') then
    		temp<=(others=>'0');
		elsif (sr_e = '1') then
     		temp(dataSize-1 downto interfaceSize) <= temp(dataSize-interfaceSize-1 downto 0) ;
	 		temp(interfaceSize-1 downto 0) <= sr_input;
		end if;
	end if;
end process; 
sr_output <= temp; 

end beh;
