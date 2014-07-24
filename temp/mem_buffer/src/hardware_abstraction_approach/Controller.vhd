library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
    Port ( 
	        clk : IN STD_LOGIC;
			  rst : IN STD_LOGIC;
			  Capture : IN STD_LOGIC; --When we wish to take ADC output into our memory
			  Readback : IN STD_LOGIC; --When we wish to read the ADC out values
			  empty_fifo : IN STD_LOGIC; --fifo is empty
			  full_fifo : IN STD_LOGIC; --fifo is full
			  empty_hal : IN STD_LOGIC; --dram is empty
			  full_hal : IN STD_LOGIC; --dram is full
			  wr_en_fifo : OUT STD_LOGIC;
			  rd_en_fifo : OUT STD_LOGIC;
			  wr_en_hal : OUT STD_LOGIC;
			  rd_en_hal : OUT STD_LOGIC;
			  full_out : OUT STD_LOGIC; --stall
			  empty_out: OUT STD_LOGIC
			  );
end Controller;

architecture controller_arch of Controller is

begin


--control the wr_en and rd_en depending upon full and empty signals and the capture/readback signals
test: process (clk, rst)
begin
  empty_out <= '0';
end process;

end controller_arch;

