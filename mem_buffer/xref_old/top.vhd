library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port ( Input : in  STD_LOGIC_VECTOR (15 downto 0);
           Output : out  STD_LOGIC_VECTOR (15 downto 0);
           process_data : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           CLOCK : in  STD_LOGIC;
           Stall : out  STD_LOGIC;
			  fif1out : out std_logic_vector(15 downto 0); --test signal!
			  fif2out : out std_logic_vector(15 downto 0); --test signal!
			  muxout : out std_logic_vector(15 downto 0) --test signal!
			  );
end top;

architecture top_arch of top is
SIGNAL FIFO1_RD_EN : STD_LOGIC;
SIGNAL FIFO2_RD_EN : STD_LOGIC;
SIGNAL FIFO1_WR_EN : STD_LOGIC;
SIGNAL FIFO2_WR_EN : STD_LOGIC;
SIGNAL MUX_SEL : STD_LOGIC;
SIGNAL FIFO1_EMPTY : STD_LOGIC;
SIGNAL FIFO2_EMPTY : STD_LOGIC;
SIGNAL FIFO1_FULL : STD_LOGIC;
SIGNAL FIFO2_FULL : STD_LOGIC;
SIGNAL DRAM_WR_EN : STD_LOGIC;
SIGNAL DRAM_Count_en : STD_LOGIC;
SIGNAL DRAM_RESET : STD_LOGIC;
begin




data: ENTITY work.Datapath(datapath_arch)
	PORT MAP(
				Input=>Input,
				CLOCK=>CLOCK,
				RESET=>RESET,
				MUX_SEL=>MUX_SEL,
				DRAM_Count_en=>DRAM_Count_en,
				DRAM_RESET=>DRAM_RESET,
				FIFO1_RD_EN=>FIFO1_RD_EN,
				FIFO2_RD_EN=>FIFO2_RD_EN,
				FIFO1_WR_EN=>FIFO1_WR_EN,
				FIFO2_WR_EN=>FIFO2_WR_EN,
				DRAM_WR_EN=>DRAM_WR_EN,
				FIFO1_FULL=>FIFO1_FULL,
				FIFO2_FULL=>FIFO2_FULL,
				FIFO1_EMPTY=>FIFO1_EMPTY,
				FIFO2_EMPTY=>FIFO2_EMPTY,
				fif1out=>fif1out, --test signal!
				fif2out=>fif2out, --test signal!
				muxout=>muxout, --test signal!				
				Output=>Output
		 );


cont: entity work.controller(contr_arch)
    PORT MAP( 
				process_data=>process_data,
				clock=>CLOCK,
				reset=>RESET,
				FIFO1_EMPTY=>FIFO1_EMPTY,
				FIFO2_EMPTY=>FIFO2_EMPTY,
				FIFO1_FULL=>FIFO1_FULL,
				FIFO2_FULL=>FIFO2_FULL,
				MUX_SEL=>MUX_SEL,
				FIFO1_RD_EN=>FIFO1_RD_EN,
				FIFO2_RD_EN=>FIFO2_RD_EN,
				FIFO1_WR_EN=>FIFO1_WR_EN,
				FIFO2_WR_EN=>FIFO2_WR_EN,
				DRAM_WR_EN=>DRAM_WR_EN,
				DRAM_Count_en=>DRAM_Count_en,
				DRAM_RESET=>DRAM_RESET,
				stall=>stall
			);

end top_arch;

