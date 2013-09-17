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


FIFO : ENTITY work.FIFO_16(FIFO_16_a)
  PORT MAP(
    clk=>Clock,
    rst=>Reset,
    din =>,
    wr_en=>,
    rd_en=>,
    dout=>,
    full=>,
    empty=>
  );



end top_arch;

