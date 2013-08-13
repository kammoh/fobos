library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is
	generic ( 
	    N : integer := 32
	);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
	   enable : in std_logic; 
      counter_out : out std_logic_vector(N-1 downto 0)
	);
end counter;

architecture Behavioral of counter is
	
	signal temp : std_logic_vector(N-1 downto 0);
	
begin
	
	counting : process( clk, reset )
	begin
		if reset = '1' then
			temp <= (others => '0');
		elsif rising_edge( clk ) then
			if ( enable = '1' ) then
				temp <=  unsigned(temp) + 1 ;
			end if;
		end if;
	end process;  
	counter_out <= temp;
	
end Behavioral;
