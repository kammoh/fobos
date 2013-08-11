LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY TOP IS
	PORT(
				Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				CLOCK : IN STD_LOGIC;
				RESET : IN STD_LOGIC;
				MUX_SEL : IN STD_LOGIC;
				DRAM_ADDR : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
				FIFO1_RD_EN : IN STD_LOGIC;
				FIFO2_RD_EN : IN STD_LOGIC;
				FIFO1_WR_EN : IN STD_LOGIC;
				FIFO2_WR_EN : IN STD_LOGIC;
				DRAM_WR_EN : IN STD_LOGIC;
				--REG_EN : IN STD_LOGIC;
				FIFO1_FULL : OUT STD_LOGIC;
				FIFO2_FULL : OUT STD_LOGIC;
				FIFO1_EMPTY : OUT STD_LOGIC;
				FIFO2_EMPTY : OUT STD_LOGIC;
				fif1out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!
				fif2out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!
				muxout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!				
				Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		 );
	END TOP;

ARCHITECTURE top_arch OF TOP IS
SIGNAL FIFO1_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL FIFO2_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DRAM_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
fif1out <= FIFO1_OUT;
fif2out <= FIFO2_OUT;
muxout <= DRAM_IN;

WITH MUX_SEL SELECT
DRAM_IN <= FIFO1_OUT WHEN '0',
			  FIFO2_OUT WHEN OTHERS;

FIFO1 : ENTITY work.FIFO214(FIFO214_a)
		  PORT MAP(
		      clk=>CLOCK,
				srst=>RESET,
				din=>Input,
				wr_en=>FIFO1_WR_EN,
				rd_en=>FIFO1_RD_EN,
				dout=>FIFO1_OUT,
				full=>FIFO1_FULL,
				empty=>FIFO1_EMPTY
		  );

FIFO2 : ENTITY work.FIFO214(FIFO214_a)
		  PORT MAP(
		      clk=>CLOCK,
				srst=>RESET,
				din=>Input,
				wr_en=>FIFO2_WR_EN,
				rd_en=>FIFO2_RD_EN,
				dout=>FIFO2_OUT,
				full=>FIFO2_FULL,
				empty=>FIFO2_EMPTY

		  );



DRAM : ENTITY work.DRAM211(DRAM211_a)
		 PORT MAP(
		     a=>DRAM_ADDR,
			  d=>DRAM_IN,
			  clk=>CLOCK,
			  we=>DRAM_WR_EN,
			  spo=>Output
		 );


--DRAM : ENTITY work.dist_mem_gen_v7_1(dist_mem_gen_v7_1_a)
--		 PORT MAP(
--		     a=>DRAM_ADDR,
--			  d=>DRAM_IN,
--			  clk=>CLOCK,
--			  we=>DRAM_WR_EN,
--			  spo=>Output
--		 );




END top_arch;