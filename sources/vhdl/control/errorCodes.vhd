library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.fobos_package.all;


entity errorCodes is
port (
		victimDCMLocked : in std_logic;
		dataReadyToPickup : in std_logic;
		statusCode : out std_logic_vector(7 downto 0));

end errorCodes;
		
architecture structural of errorCodes is 
begin
statusCode <= x"01" when victimDCMLocked = '0' else
			     x"02" when dataReadyToPickUp = '1' else
			     x"00";
end structural;