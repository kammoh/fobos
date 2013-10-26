----------------------------------------------------------------------------------- 
--Title       : Single-port Block RAM
-- Design     : Library
-- Author      : Panasayya Yalla
-- Company     : George Mason University
-- File        : sbram.vhd
---------------------------------------------------------------------------------
-- Description 	: Single-port Block RAM with synchronous read/write
--	en		: enable for block ram
-- 	wen		: write enable		
-- 	addr    : address for read/write
--  din		: input data
--	dout	: output from bram
---	Mode	: read_first_write_next
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
entity sbram is	
	generic ( bits      : integer:=8 ; -- number of bits per RAM word
	addr_bits : integer:=8); -- 2^addr_bits = number of words in RAM	
	port	    ( clk   : in std_logic;
				en	  	: in std_logic;
				wen     : in std_logic;
				addr    : in std_logic_vector(addr_bits-1 downto 0);
				din     : in std_logic_vector(bits-1 downto 0);
				dout    : out std_logic_vector (bits-1 downto 0)
			);
	attribute ram_style:string;
	attribute ram_style of sbram: entity is "block";
		
	end sbram;
architecture behavioral of sbram is	
type ram_type is array (2**addr_bits-1 downto 0) of std_logic_vector (bits-1 downto 0);
signal RAM : ram_type;
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			if(en='1') then
				if (wen = '1') then
					RAM(conv_integer(unsigned(addr))) <= din;
				end if;					--place the line here for write_first_read_next mode
				dout <= RAM(conv_integer(unsigned(addr)));--place this line after the write enable condition for write_first_read_next mode
			end if;
		end if;
		end process;
end behavioral;