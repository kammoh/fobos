library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity bram_adc_store is
    Port (clock : in std_logic;
		  addr : in std_logic_vector(14 downto 0);
		  wen : in std_logic;
		  en : in std_logic;
		  din : in std_logic_vector(15 downto 0);
		  dout : out std_logic_vector(15 downto 0));
end bram_adc_store;

architecture Behavioral of bram_adc_store is

		component sbram is	
			generic ( bits      : integer:=8 ; -- number of bits per RAM word
						addr_bits : integer:=8); -- 2^addr_bits = number of words in RAM	
			port( clk   : in std_logic;
					en	  	: in std_logic;
					wen     : in std_logic;
					addr    : in std_logic_vector(addr_bits-1 downto 0);
					din     : in std_logic_vector(bits-1 downto 0);
					dout    : out std_logic_vector (bits-1 downto 0));
		
		end component;

signal we_bram1 : std_logic;
signal we_bram2 : std_logic;
signal we_bram3 : std_logic;
signal we_bram4 : std_logic;
signal we_bram5 : std_logic;
signal we_bram6 : std_logic;		
signal we_bram7 : std_logic;
signal we_bram8 : std_logic;
signal we_bram9 : std_logic;
signal we_bram10 : std_logic;		
signal we_bram11 : std_logic;
signal we_bram12 : std_logic;
signal we_bram13 : std_logic;
signal we_bram14 : std_logic;		
signal we_bram15 : std_logic;
signal we_bram16 : std_logic;
signal we_bram17 : std_logic;
signal we_bram18 : std_logic;		
signal we_bram19 : std_logic;
signal we_bram20 : std_logic;

signal dout_bram1 : std_logic_vector(15 downto 0);
signal dout_bram2 : std_logic_vector(15 downto 0);
signal dout_bram3 : std_logic_vector(15 downto 0);
signal dout_bram4 : std_logic_vector(15 downto 0);
signal dout_bram5 : std_logic_vector(15 downto 0);
signal dout_bram6 : std_logic_vector(15 downto 0);
signal dout_bram7 : std_logic_vector(15 downto 0);
signal dout_bram8 : std_logic_vector(15 downto 0);
signal dout_bram9 : std_logic_vector(15 downto 0);
signal dout_bram10 : std_logic_vector(15 downto 0);
signal dout_bram11 : std_logic_vector(15 downto 0);
signal dout_bram12 : std_logic_vector(15 downto 0);
signal dout_bram13 : std_logic_vector(15 downto 0);
signal dout_bram14 : std_logic_vector(15 downto 0);
signal dout_bram15 : std_logic_vector(15 downto 0);
signal dout_bram16 : std_logic_vector(15 downto 0);
signal dout_bram17 : std_logic_vector(15 downto 0);
signal dout_bram18 : std_logic_vector(15 downto 0);
signal dout_bram19 : std_logic_vector(15 downto 0);
signal dout_bram20 : std_logic_vector(15 downto 0);
		
begin
-----------------------------------------------------------------------------
we_bram1 <= '1' when (wen = '1' and addr(14 downto 10) = "00000") else '0';
we_bram2 <= '1' when (wen = '1' and addr(14 downto 10) = "00001") else '0';
we_bram3 <= '1' when (wen = '1' and addr(14 downto 10) = "00010") else '0';
we_bram4 <= '1' when (wen = '1' and addr(14 downto 10) = "00011") else '0';
we_bram5 <= '1' when (wen = '1' and addr(14 downto 10) = "00100") else '0';
we_bram6 <= '1' when (wen = '1' and addr(14 downto 10) = "00101") else '0';
we_bram7 <= '1' when (wen = '1' and addr(14 downto 10) = "00110") else '0';
we_bram8 <= '1' when (wen = '1' and addr(14 downto 10) = "00111") else '0';
we_bram9 <= '1' when (wen = '1' and addr(14 downto 10) = "01000") else '0';
we_bram10 <= '1' when (wen = '1' and addr(14 downto 10) = "01001") else '0';
we_bram11 <= '1' when (wen = '1' and addr(14 downto 10) = "01010") else '0';
we_bram12 <= '1' when (wen = '1' and addr(14 downto 10) = "01011") else '0';
we_bram13 <= '1' when (wen = '1' and addr(14 downto 10) = "01100") else '0';
we_bram14 <= '1' when (wen = '1' and addr(14 downto 10) = "01101") else '0';
we_bram15 <= '1' when (wen = '1' and addr(14 downto 10) = "01110") else '0';
we_bram16 <= '1' when (wen = '1' and addr(14 downto 10) = "01111") else '0';
we_bram17 <= '1' when (wen = '1' and addr(14 downto 10) = "10000") else '0';
we_bram18 <= '1' when (wen = '1' and addr(14 downto 10) = "10001") else '0';
we_bram19 <= '1' when (wen = '1' and addr(14 downto 10) = "10010") else '0';
we_bram20 <= '1' when (wen = '1' and addr(14 downto 10) = "10011") else '0';
-----------------------------------------------------------------------------

dout <= dout_bram1 when addr(14 downto 10) = "00000" else
		  dout_bram2 when addr(14 downto 10) = "00001" else
		  dout_bram3 when addr(14 downto 10) = "00010" else
		  dout_bram4 when addr(14 downto 10) = "00011" else
		  dout_bram5 when addr(14 downto 10) = "00100" else
		  dout_bram6 when addr(14 downto 10) = "00101" else
		  dout_bram7 when addr(14 downto 10) = "00110" else
		  dout_bram8 when addr(14 downto 10) = "00111" else
		  dout_bram9 when addr(14 downto 10) = "01000" else
		  dout_bram10 when addr(14 downto 10) = "01001" else
		  dout_bram11 when addr(14 downto 10) = "01010" else
		  dout_bram12 when addr(14 downto 10) = "01011" else
		  dout_bram13 when addr(14 downto 10) = "01100" else
		  dout_bram14 when addr(14 downto 10) = "01101" else
		  dout_bram15 when addr(14 downto 10) = "01110" else
		  dout_bram16 when addr(14 downto 10) = "01111" else
		  dout_bram17 when addr(14 downto 10) = "10000" else
		  dout_bram18 when addr(14 downto 10) = "10001" else
		  dout_bram19 when addr(14 downto 10) = "10010" else
		  dout_bram20 ;
-----------------------------------------------------------------------------

data_bram1 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram1, addr => addr(9 downto 0),
			din => din, dout => dout_bram1);	

data_bram2 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram2, addr => addr(9 downto 0),
			din => din, dout => dout_bram2);
			
data_bram3 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram3, addr => addr(9 downto 0),
			din => din, dout => dout_bram3);	

data_bram4 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram4, addr => addr(9 downto 0),
			din => din, dout => dout_bram4);
			
data_bram5 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram5, addr => addr(9 downto 0),
			din => din, dout => dout_bram5);	

data_bram6 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram6, addr => addr(9 downto 0),
			din => din, dout => dout_bram6);
			
data_bram7 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram7, addr => addr(9 downto 0),
			din => din, dout => dout_bram7);	

data_bram8 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram8, addr => addr(9 downto 0),
			din => din, dout => dout_bram8);

data_bram9 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram9, addr => addr(9 downto 0),
			din => din, dout => dout_bram9);	

data_bram10 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram10, addr => addr(9 downto 0),
			din => din, dout => dout_bram10);
			
data_bram11 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram11, addr => addr(9 downto 0),
			din => din, dout => dout_bram11);	

data_bram12 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram12, addr => addr(9 downto 0),
			din => din, dout => dout_bram12);

data_bram13 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram13, addr => addr(9 downto 0),
			din => din, dout => dout_bram13);	

data_bram14 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram14, addr => addr(9 downto 0),
			din => din, dout => dout_bram14);
			
data_bram15 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram15, addr => addr(9 downto 0),
			din => din, dout => dout_bram15);	

data_bram16 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram16, addr => addr(9 downto 0),
			din => din, dout => dout_bram16);

data_bram17 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram17, addr => addr(9 downto 0),
			din => din, dout => dout_bram17);	

data_bram18 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram18, addr => addr(9 downto 0),
			din => din, dout => dout_bram18);
			
data_bram19 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram19, addr => addr(9 downto 0),
			din => din, dout => dout_bram19);	

data_bram20 : sbram generic map(bits => 16, addr_bits => 10)
		    port map ( clk => clock, en => en, wen => we_bram20, addr => addr(9 downto 0),
			din => din, dout => dout_bram20);			

end Behavioral;
			