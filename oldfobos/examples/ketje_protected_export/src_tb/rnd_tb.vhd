----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rnd_tb is

end rnd_tb;

architecture behavioral of rnd_tb is
constant period : time:= 8 ns;

signal x1, x2, x3, x4 : std_logic_vector(63 downto 0);

begin

    x1 <= x"bc94830293bcadea";
    x2 <= x"bace98671209e87a";
    x3 <= x1 xor x2;
    x4 <= x2 xor x3;

test_process: process
begin
   

    wait for period;
    
    wait;
		
end process;

end behavioral;
