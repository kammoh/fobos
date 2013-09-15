library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
	         Clock : in  STD_LOGIC;
            Reset : in  STD_LOGIC;
				Input : in  STD_LOGIC_VECTOR (15 downto 0);
            Output : out  STD_LOGIC_VECTOR (15 downto 0)
			  
			  );
end top;

architecture top_arch of top is

begin



--read in input 16 bits
--even cycle to external DRAM
--odd cycle to internal BRAM
--pass output to usb



end top_arch;

