LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--Need to add control logic

ENTITY test_module IS
	PORT(
				Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				CLOCK : IN STD_LOGIC;
				RESET : IN STD_LOGIC;
				Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				FIFO_WR_EN : IN STD_LOGIC;
				FIFO_RD_EN : IN STD_LOGIC;
				FIFO_FULL : OUT STD_LOGIC;
				FIFO_EMPTY : OUT STD_LOGIC
		 );
	END test_module;

ARCHITECTURE test_arch OF test_module IS

BEGIN


FIFO1 : ENTITY work.FIFO214(FIFO214_a)
		  PORT MAP(
		      clk=>CLOCK,
				srst=>RESET,
				din=>Input,
				wr_en=>FIFO_WR_EN,
				rd_en=>FIFO_RD_EN,
				dout=>Output,
				full=>FIFO_FULL,
				empty=>FIFO_EMPTY
		  );


END test_arch;