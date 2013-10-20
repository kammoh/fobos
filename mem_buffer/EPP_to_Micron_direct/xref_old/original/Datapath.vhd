LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY Datapath IS
	PORT(
				Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				CLOCK : IN STD_LOGIC;
				RESET : IN STD_LOGIC;
				MUX_SEL : IN STD_LOGIC;
				DRAM_Count_en : IN STD_LOGIC;
				DRAM_RESET : IN STD_LOGIC;
				--DRAM_ADDR : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
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
	END Datapath;

ARCHITECTURE datapath_arch OF Datapath IS
SIGNAL FIFO1_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL FIFO2_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DRAM_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DRAM_ADDR : STD_LOGIC_VECTOR(10 DOWNTO 0);

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

--Using this to increment the address we are writing to or reading from on the DRAM
--To reduce the overall number of controller states
DRAM_ADDR_CNTR : ENTITY work.counter(count_arch)
	GENERIC MAP(N =>11)
	PORT MAP( 	  
			clk=>clock,
			reset=>DRAM_RESET,
			enable=>DRAM_Count_en,
			counter_out=>DRAM_ADDR
	);


END datapath_arch;