library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
	        CLOCK : IN STD_LOGIC;
			  RESET : IN STD_LOGIC;
			  Capture : IN STD_LOGIC;
			  Readback : IN STD_LOGIC;
	        Input_from_ADC : in  STD_LOGIC_VECTOR (15 downto 0) := "1111111111111111";
			  empty : OUT STD_LOGIC; --tell that our memories are empty
			  full_ie_stall : OUT STD_LOGIC; --tells that our memory is full
           Output_to_PC : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  RamAdv : OUT STD_LOGIC;
			  RamCRE : OUT STD_LOGIC;
			  RamCS : OUT STD_LOGIC;
			  MemOE : OUT STD_LOGIC;
			  MemWr : OUT STD_LOGIC;
			  RamLB : OUT STD_LOGIC;
			  RamUB : OUT STD_LOGIC;
			  RamWait : IN STD_LOGIC;
			  MemAdr : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
			  RamClk : OUT STD_LOGIC;			  
           MemDB : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			  
			  
			 );
end top;

architecture top_arch of top is
SIGNAL fifo_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL fifo_full : STD_LOGIC;
SIGNAL fifo_empty : STD_LOGIC;
SIGNAL fifo_wr_en : STD_LOGIC;
SIGNAL fifo_rd_en : STD_LOGIC;
SIGNAL hal_empty : STD_LOGIC;
SIGNAL hal_full : STD_LOGIC;
SIGNAL wr_en_hal : STD_LOGIC;
SIGNAL rd_en_hal : STD_LOGIC;
--SIGNAL hal_data_from_adc : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL hal_data_to_dout : STD_LOGIC_VECTOR(15 DOWNTO 0);
--HAL TO MEM CONTROL SIGNALS
SIGNAL hal_addr_o : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL hal_data_from_mem : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL hal_data_to_mem : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL hal_we_o : STD_LOGIC;
SIGNAL hal_go_o : STD_LOGIC;

begin
--EPP

------------------------------------------------------------------------
-- FIFO Module
------------------------------------------------------------------------		
FIFO_14 : ENTITY work.FIFO_14(FIFO_14_a)
  PORT MAP(
    clk=>CLOCK,
    rst=>RESET,
    din=>Input_from_ADC,
    wr_en=>fifo_wr_en,
    rd_en=>fifo_rd_en,
    dout=>fifo_out,
    full=>fifo_full,
    empty=>fifo_empty
  );


------------------------------------------------------------------------
-- Controller Module
------------------------------------------------------------------------		

Controller : ENTITY work.Controller(controller_arch)
    Port Map( 
	        clk=>CLOCK,
			  rst=>RESET,
			  Capture=>Capture,
			  Readback=>Readback,
			  empty_fifo=>fifo_empty,
			  full_fifo=>fifo_full,
			  empty_hal=>hal_empty,
			  full_hal=>hal_full,
			  wr_en_fifo=>fifo_wr_en,
			  rd_en_fifo=>fifo_rd_en,
			  wr_en_hal=>wr_en_hal,
			  rd_en_hal=>rd_en_hal,
			  full_out=>full_ie_stall,
			  empty_out=>empty
			  );
			  

------------------------------------------------------------------------
-- HAL Module
------------------------------------------------------------------------		

HAL : ENTITY work.HAL(slow_mem)
	 GENERIC MAP( 
	              addr_width=>26,
			        data_width=>16)
    PORT MAP( 
			clk_i=>CLOCK,
			rst=>RESET,
			-- Interface to rest of Sample Collection module
			sample_din=>fifo_out,
			sample_dout=>hal_data_to_dout,
			wr_en=>wr_en_hal,
			rd_en=>rd_en_hal,
			full=>hal_full,
			empty=>hal_empty,
			-- Interface to Memory Controller
			addr_o=>hal_addr_o,
			data_i=>hal_data_from_mem,
			data_o=>hal_data_to_mem,
			we_o=>hal_we_o,
			go_o=>hal_go_o
			);

------------------------------------------------------------------------
-- Memory Controller
------------------------------------------------------------------------		

memControl : ENTITY work.memory_interface(Behavioral1)
	GENERIC MAP( 
	            addr_width=>26,
				   data_width=>16)
	PORT MAP(
		-- These pins are used to talk to the celular ram  (memory_interface <--> cellular_ram);
		addr_o=>MemAdr,
		clk_o=>RamClk,
		addr_valid_o=>RamAdv,
		cntl_reg_enable_o=>RamCRE,
		chip_enable_o=>RamCS,
		output_enable_o=>MemOE,
		write_en_o=>MemWR,
		lower_byte_en_o=>RamLB,
		upper_byte_en_o=>RamUB,
		data_io=>MemDB,
		wait_i=>RamWait,
		-- These are the pins used to help interface the memory as if it were a block ram ( some module <--> memory_interface);
		addr_i=>hal_addr_o,
		we_i=>hal_we_o,
		data_i=>hal_data_to_mem,
		data_o=>hal_data_from_mem,
		clk_i=>CLOCK,
		go_i=>hal_go_o--top module should set this to 0.  when ready to use, set to 1 for one cycle (max 90 ns) then bring down.  when go_i is high it will read or write otherwise it will be idle.;
	);
	
	
	
------------------------------------------------------------------------
-- USB Controller
------------------------------------------------------------------------			
--EPP_Controller : ENTITY work.EppCtrl(Behavioral)
--    port map (
--		  clk => clk,
--		  EppAstb => EppAstb,
--		  EppDstb => EppDstb,
--		  EppWr => EppWrite,
--		  EppRst => active,
--		  EppDB => EppDB,
--		  EppWait => EppWait,
--		  busEppOut => hosttofpga_data,
--		  busEppIn => fpgatohost_data,
--		  regEppAdrOut => regEppAdrOut,
--		  ctlEppDwrOut => ctlEppDwrOut,
--		  ctlEppRdCycleOut => ctlEppRdCycleOut,
--		  HandShakeReqIn => inactive,
--		  ctlEppStartOut => ctlEppStartOut,
--		  ctlEppDoneIn => ctlEppDoneIn
--		  );
	
end top_arch;

